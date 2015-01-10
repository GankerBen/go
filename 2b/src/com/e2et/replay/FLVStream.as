package com.e2et.replay
{
import flash.events.Event;
import flash.events.HTTPStatusEvent;
import flash.events.IOErrorEvent;
import flash.events.NetStatusEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.events.StatusEvent;
import flash.net.NetStream;
import flash.net.NetStreamAppendBytesAction;
import flash.net.URLRequest;
import flash.net.URLRequestHeader;
import flash.net.URLStream;
import flash.utils.ByteArray;
import flash.utils.Endian;

public class FLVStream extends NetStream
{
    static public const DATA_BUFFER_FULL:String = 'data_buffer_full';
    static public const DATA_BUFFER_PROGRESS:String = 'data_buffer_progress';
    static public const LOAD_FAILED:String = 'loadFailed';

    static private const BASE_URL:String = 'http://118.26.146.78/media/';

    private var _url:String;
    private var _urlstm:URLStream;
    private var _size:int = 0;
    private var _body:ByteArray;
    private var _full:Boolean = false;

    private var _pos:uint = 0;
    private var _next_append_pos:uint = 0;
    /**
     * 媒体总时长 (ms)
     */
    private var _duration:uint;

    /**
     * 数据缓冲默认为 20 秒
     */
    private var _dataBufferTime:uint = 20000;

    /**
     * 文件总长度 
     */
    private var _totalLength:uint = 0;

    private var _tags:Vector.<FLVTag>;

    /**
     * key video frames
     */
    private var _kvfs:Vector.<KVFrame>;

    public function FLVStream (name:String)
    {
        super (fakeNC ());
        // 预加载 20 秒
        _url = BASE_URL + name;
        _urlstm = new URLStream;
        _urlstm.load (newReq (_url, 13));
        urlStreamSetup (_urlstm.addEventListener);
        _urlstm.endian = Endian.BIG_ENDIAN;

        _body = new ByteArray;
        var flv:ByteArray = new ByteArray;
        flv.writeUTFBytes("FLV\x01\x05\x00\x00\x00\x09\x00\x00\x00\x00");
        play (null);
        appendBytes (flv);
        appendBytesAction (NetStreamAppendBytesAction.RESET_SEEK);
        bufferTime = 0.1;
        bufferTimeMax = 20;
        pause ();
        this.addEventListener (NetStatusEvent.NET_STATUS, onNetStatus);
        _kvfs = new Vector.<KVFrame>;
        _tags = new Vector.<FLVTag>;
        _next_append_pos = _pos = 13;
    }
    public final function get dataBufferTime ():Number
    {
        return _dataBufferTime/1000.0;
    }
    public final function set dataBufferTime (v:Number):void
    {
        _dataBufferTime = v * 1000;
        if (_urlstm == null)
        {
            // TODO: 修复数据缓冲区大小有可能要继续下载数据
        }
    }
    public final function get dataBufferFull ():Boolean
    {
        return _full;
    }

    override public function seek (offset:Number):void
    {
        var timepos:uint = offset * 1000;
        //super.seek (offset);
    }
    private function urlStreamSetup (func:Function):void
    {
        func (HTTPStatusEvent.HTTP_STATUS, onHttpStatus);
        func (IOErrorEvent.IO_ERROR, onError);
        func (SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
        func (ProgressEvent.PROGRESS, onProgress);
    }
    static private function newReq (url:String, pos:uint):URLRequest
    {
        var req:URLRequest = new URLRequest (url);
        req.method = "GET";
        req.requestHeaders = [new URLRequestHeader ("Range", "bytes=" + pos + "-")];
        return req;
    }

    protected function onNetStatus(event:NetStatusEvent):void
    {
        trace (event.info.code);
    }

    protected function onProgress(event:ProgressEvent):void
    {
        for (;;)
        {
            if (_size == 0)
            {   // 下一个 FLVTag
                if (_urlstm.bytesAvailable < 4)
                    return stopIfDataFull ();
                _body = new ByteArray;
                // 第一个字节为 tag type, 后三个字节为 tagSize (BigEndian)
                var v:uint = _urlstm.readUnsignedInt ();
                _size = (v & 0xffffff) + 11;
                _body.writeUnsignedInt (v);
                var tag:uint = _body[0];
                if (tag != 8 && tag != 9 && tag != 18)
                    return loadFailed ('bad media file ' + _url);
            }

            if (_urlstm.bytesAvailable < _size)
                return stopIfDataFull ();
            var t:uint = _urlstm.readUnsignedInt ();
            _body.writeUnsignedInt (t);
            t = ((t>>8)&0xffffff) + (t << 24);
            _urlstm.readBytes (_body, 8, _size - 4);
            if (_next_append_pos == _pos && this.bufferLength < 20)
            {
                appendBytes (_body);
                _next_append_pos = _pos + _body.length;
            }
            if (_body[0] == 8 || _body[0] == 9)
                _tags.push (new FLVTag (t, _pos, _body));
            _pos += _body.length;
            _size = 0;
        }
    }
    private function stopIfDataFull ():void
    {
        if (_tags.length == 0)
            return;
        var diff:uint = _tags[_tags.length-1].time - _tags[0].time;
        if (this.hasEventListener (DATA_BUFFER_PROGRESS))
        {
            var event:ProgressEvent = new ProgressEvent (DATA_BUFFER_PROGRESS, false, false,
                diff < _dataBufferTime ? diff : _dataBufferTime, _dataBufferTime);
            this.dispatchEvent (event);
        }
        if (diff > _dataBufferTime)
        {
            _full = true;
            _urlstm.stop ();
            _urlstm.close ();
            urlStreamSetup (_urlstm.removeEventListener);
            _urlstm = null;
            if (this.hasEventListener (DATA_BUFFER_FULL))
                this.dispatchEvent (new Event (DATA_BUFFER_FULL));
        }
    }

    private function onSecurityError(event:SecurityErrorEvent):void
    {
        if (this.hasEventListener (LOAD_FAILED))
        {
            var e:StatusEvent = new StatusEvent (LOAD_FAILED, false, false, "securityError", event.text);
            this.dispatchEvent (e);
        }
    }

    private function onError(event:IOErrorEvent):void
    {
        if (this.hasEventListener (LOAD_FAILED))
        {
            var e:StatusEvent = new StatusEvent (LOAD_FAILED, false, false, "ioError", event.text);
            this.dispatchEvent (e);
        }
    }

    /**
     * 如果调用了 URLStream.stop，则不会产生 HTTPStatusEvent.HTTP_STATUS 事件
     */
    private function onHttpStatus (event:HTTPStatusEvent):void
    {
        if (event.status < 200 || event.status >= 300)
            return loadFailed ('http status ' + event.status);
        if (_size != 0 || _urlstm.bytesAvailable != 0)
            return loadFailed ('bad media file ' + _url);
        if (this.hasEventListener (DATA_BUFFER_PROGRESS))
        {
            var e:ProgressEvent = new ProgressEvent (DATA_BUFFER_PROGRESS, false, false,
                _dataBufferTime, _dataBufferTime);
            this.dispatchEvent (e);
        }
        _full = true;
        urlStreamSetup (_urlstm.removeEventListener);
        _urlstm = null;
        if (this.hasEventListener (DATA_BUFFER_FULL))
            this.dispatchEvent (new Event (DATA_BUFFER_FULL));
    }
    private function loadFailed (code:String, info:String = ""):void
    {
        _urlstm.stop ();
        _urlstm.close ();
        urlStreamSetup (_urlstm.removeEventListener);
        _urlstm = null;
        if (this.hasEventListener (LOAD_FAILED))
        {
            var e:StatusEvent = new StatusEvent (LOAD_FAILED, false, false, code, info);
            this.dispatchEvent (e);
        }
    }
    public function onMetaData (d:*):void
    {
        _totalLength = d.filesize;
        _duration = d.duration * 1000;
        var kf:Object = d.keyframes;
        if (kf != null)
        {
            var times:Array = kf.times;
            var fpos:Array = kf.filepositions;
            var i:uint, c:uint = times.length;
            var lt:uint = 0xffffffff;
            for (i=0; i<c; ++i)
            {
                var t:uint = times[i]*1000;
                if (t == lt)
                    continue;
                _kvfs.push (new KVFrame (lt=t, fpos[i]));
            }
        }
    }
}
}
import flash.utils.ByteArray;

class FLVTag
{
    public var time:uint;
    public var fpos:uint;
    public var data:ByteArray;
    public function FLVTag (time:uint, fpos:uint, data:ByteArray)
    {
        this.time = time;
        this.fpos = fpos;
        this.data = data;
    }
}

class KVFrame
{
    public var time:uint;
    public var fpos:uint;
    public function KVFrame (time:uint, fpos:uint)
    {
        this.time = time;
        this.fpos = fpos;
    }
}
