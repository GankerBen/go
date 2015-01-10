package com.e2et.replay
{
import com.e2et.utils.LEByteArray;

import flash.events.HTTPStatusEvent;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLRequest;
import flash.net.URLStream;
import flash.utils.ByteArray;
import flash.utils.Endian;

/**
 * 回放会话
 * 1、每个回放会话里可能录制有多段内容，每段内容由 ReplaySegment 对象来表示。
 *
 * 几个很实际的问题
 * 1. 回放 seek 至 10 秒，stream A 经检查需要从 9.5 秒处播放，stream B 经检查需要从 7 秒播放。
 * 2. stream 中有视频时的 seek 处理，无视频时的 seek 处理
 * 3. 回放 seek 至 10 秒，stream 中 5 秒至 15 秒之间没有任何音视频数据
 * 4. 回放中有多个 stream 时，几个 stream 的缓冲等待问题。
 * 5. 从视频非关键帧位置开始播放时，无视频画面的问题
 * 只有一个流时问题容易解决，每次 seek 都从关键帧处开始播放就可以了，但有两个会更多个流时就麻烦了，没办法
 * 保障多个流的关键帧位置是一致的
 */
public class ReplaySession
{
    static private const BASE_URL:String = 'http://118.26.146.78/record/';
    private var _videoId:String;
    private var _handler:IReplayHandler;
    private var _segs:Vector.<ReplaySegment> = new Vector.<ReplaySegment>;

    private var _state:uint = 0;
    private var _urlstm:URLStream;
    private var _ts:uint, _ms:uint, _type:uint, _size:uint;
    private var _streams:Vector.<FLVStreamInfo>;

    public function ReplaySession (videoId:String, handler:IReplayHandler)
    {
        _videoId = videoId;
        _handler = handler;

        // 从网络上加载录制文件
        var req:URLRequest = new URLRequest (BASE_URL + videoId);

        _urlstm = new URLStream;
        _urlstm.load (req);
        _urlstm.endian = Endian.LITTLE_ENDIAN;
        setup (_urlstm.addEventListener);
    }
    private function setup (func:Function):void
    {
        func (IOErrorEvent.IO_ERROR, onIOError);
        func (ProgressEvent.PROGRESS, onProgress);
        func (HTTPStatusEvent.HTTP_STATUS, onHttpStatus);
        func (SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
    }
    private function onIOError(event:IOErrorEvent):void
    {
        loadFailed ('ioError');
    }
    private function onSecurityError(event:SecurityErrorEvent):void
    {
        loadFailed ('securityError');
    }

    /**
     * 加载解析录制文件
     */
    private function onProgress (event:ProgressEvent):void
    {
        while (_urlstm != null)
        {
            if (_state == 0)
            {   // 读取头部
                if (_urlstm.bytesAvailable < 11)
                    break;
                // 4 字节时间戳，秒
                _ts = _urlstm.readUnsignedInt ();
                // 2 字节时间戳，毫秒
                _ms = _urlstm.readUnsignedShort ();
                // 1 字节类型
                _type = _urlstm.readUnsignedByte ();
                // 4 字节大小
                _size = _urlstm.readUnsignedInt ();
                _state = 1;
            }
            if (_state == 1)
            {   // 读取后续数据
                if (_urlstm.bytesAvailable < _size)
                    break;
                var pkt:ByteArray = new LEByteArray;
                if (_size > 0)
                    _urlstm.readBytes (pkt, 0, _size);
                add (_ts, _ms, _type, pkt);
                _state = 0;
            }
        }
        if (_urlstm != null)
        {   // 进度提示, 加载录制文件占总进度的 80%
            _handler.loadProgress (this, 0.8*event.bytesLoaded/event.bytesTotal);
        }
    }

    private function onHttpStatus (event:HTTPStatusEvent):void
    {
        var bytesAvailable:uint = _urlstm.bytesAvailable;
        setup (_urlstm.removeEventListener);
        _urlstm = null;
        if (event.status < 200 || event.status >= 300)
            return loadFailed ('http status ' + event.status);

        if (_state != 0 || bytesAvailable > 0)
            return loadFailed ('bad record file');
        if (_segs.length == 0)
            return loadFailed ('empty record file');
        // 加载成功，等待每个 segment 中的流预加载完成
        var i:uint, c:uint = _segs.length;
        var streams:Vector.<FLVStream> = new Vector.<FLVStream>;
        for (i=0; i<c; ++i)
            _segs[i].getStreams (streams);
        if (streams.length == 0)
            return loadComplete ();
        c = streams.length;
        _streams = new Vector.<FLVStreamInfo>;
        for (i=0; i<c; ++i)
            _streams.push (new FLVStreamInfo (streams[i], this));
        var sum:Number = 0.0;
        _streams.every (function (e:FLVStreamInfo, i:int, o:*):void {
            sum += e.progress;
        });
        if (sum == c)
            return loadComplete ();
    }

    internal function loadFailed (reason:String):void
    {
        if (_urlstm != null)
        {
            _urlstm.stop ();
            _urlstm.close ();
            setup (_urlstm.removeEventListener);
            _urlstm = null;
        }
        _handler.loadFailed (this, reason);
    }
    private function loadComplete ():void
    {
        if (_streams != null)
        {
            var i:uint, c:uint = _streams.length;
            for (i=0; i<c; ++i)
                _streams[i].dispose ();
            _streams = null;
        }
        _handler.loadProgress (this, 1.0);
        _handler.loadComplete (this);
    }
    internal function updateLoadProgress ():void
    {
        var sum:Number = 0.0, c:uint = _streams.length;
        _streams.every (function (e:FLVStreamInfo, i:int, o:*):void {
            sum += e.progress;
        });

        if (sum == 0)
            return;
        if (sum < c)
            _handler.loadProgress (this, 0.8 + 0.2 * sum / c);
        else
            loadComplete ();
    }
    public function get segments ():Vector.<ReplaySegment>
    {
        return _segs;
    }

    private function add (ts:uint, ms:uint, type:uint, pkt:ByteArray):void
    {
        var seg:ReplaySegment;
        if (_segs.length > 0)
            seg = _segs[_segs.length-1];
        if (type == 0x0d && pkt[0] == 0)
        {
            seg = new ReplaySegment (_videoId, _handler, this);
            _segs.push (seg);
        }
        if (seg != null)
            seg.add (ts, ms, type, pkt);
        else
            loadFailed ('bad record file');
    }
}
}
