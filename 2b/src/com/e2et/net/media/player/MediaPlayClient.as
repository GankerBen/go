package com.e2et.net.media.player
{
import com.e2et.Session;
import com.e2et.datalogic.AVStream;
import com.e2et.net.ServerList;
import com.e2et.net.nc_internal;
import com.e2et.net.ncp_internal;
import com.e2et.net.connection.INetConnection;
import com.e2et.net.connection.NetConnectionPool;
import com.e2et.net.media.MediaClient;
import com.e2et.net.media.audio.AudioPlayoutMP;
import com.e2et.net.media.audio.IAudioPlayout;
import com.e2et.utils.FLVPacket;
import com.e2et.utils.LEByteArray;
import com.e2et.utils.Misc;

import flash.events.Event;
import flash.events.NetStatusEvent;
import flash.events.TimerEvent;
import flash.external.ExternalInterface;
import flash.net.NetConnection;
import flash.net.NetStream;
import flash.net.Socket;
import flash.utils.ByteArray;
import flash.utils.Timer;
import flash.utils.clearTimeout;
import flash.utils.getTimer;
import flash.utils.setTimeout;

use namespace nc_internal;
use namespace ncp_internal;

[ExcludeClass]
/**
 * 媒体播放 - 支持断线自动重连
 * @author Bin Tian
 */
public class MediaPlayClient extends MediaClient implements IMediaPlayClient
{
    private var _handlers:Vector.<IMediaPlayHandler> = new Vector.<IMediaPlayHandler>;

    private var _hbo:uint, _last_hbo:int;
    private var _hbi:uint, _last_hbi:int;
    private var _audio_pkt_count:uint;
    private var _video_pkt_count:uint;
    private var _last_audio_pkts:uint;
    private var _last_video_pkts:uint;
    private var _seek_status:int = SEEK_IDLE;

    private var _vstm:NetStream = null;
    private var _audio_playout:IAudioPlayout = null;

    private var _hasAudio:Boolean = true;
    private var _hasVideo:Boolean = true;

    private var _upload_jitter:Array = [0, 0, 0];
    private var _download_jitter:Array = [0, 0, 0];
    private var _last_audio_time:uint, _audio_detected:Boolean = false;
    private var _ts_info:TSInfo = new TSInfo;
	
	private var _min_vstm_buffer_length:uint = 0;

    private var _connectTimer:Timer = new Timer (5000, 1);

    /**
     * 当 NetStream.bufferLength > NetStream.bufferTimeMax + _btm_jitter 时触发 seek 操作
     */
    private var _btm_jitter:Number = 0.3;

    private var _audio_jitter:Number, _video_jitter:Number;
    private var _ajb:JitterBuffer, _vjb:JitterBuffer;
    private var _show_jb:Boolean = false;

    public function MediaPlayClient($:Session, av:AVStream)
    {
        super($, av);
        _audioOn = true;
        _videoOn = true;
        _logTag = '媒体播放[' + name + ']: ';
        $.addEventListener("modeChanged", onModeChanged, false, 0, true);
        try { _show_jb = ExternalInterface.call('showJB'); } catch (e:Error) { }
        _connectTimer.addEventListener (TimerEvent.TIMER, function (e:Event):void {
            playFailed ("timeout");
        });
    }
    public final function addHandler (h:IMediaPlayHandler):void
    {
        var v:Vector.<IMediaPlayHandler> = _handlers;
        if (v.indexOf (h) < 0)
            v.push (h);
    }
    public final function delHandler (h:IMediaPlayHandler):void
    {
        var i:int, v:Vector.<IMediaPlayHandler> = _handlers;
        if ((i = v.indexOf (h)) >= 0)
            v.splice (i, 1);
    }
    [Inline]
    private final function playStarting ():void
    {
        var v:Vector.<IMediaPlayHandler> = _handlers;
        var i:uint, c:uint = v.length;
        for (i=0; i<c; ++i)
            v[i].mediaPlayStarting (this);
        _connectTimer.reset ();
        _connectTimer.start ();
    }
    [Inline]
    private final function playStarted (stm:NetStream):void
    {
        var v:Vector.<IMediaPlayHandler> = _handlers;
        var i:uint, c:uint = v.length;
        for (i=0; i<c; ++i)
            v[i].mediaPlayStarted (this, stm);
        _connectTimer.stop ();
        startClientTimer ();
    }
    [Inline]
    private final function playInterrupted (reason:String, delay:uint = 1500):void
    {
        var v:Vector.<IMediaPlayHandler> = _handlers;
        var i:uint, c:uint = v.length;
        for (i=0; i<c; ++i)
            v[i].mediaPlayInterrupted (this, reason);
        _connectTimer.stop ();
        reconnect (delay);
    }
    [Inline]
    private final function publishStopped ():void
    {
        var v:Vector.<IMediaPlayHandler> = _handlers;
        var i:uint, c:uint = v.length;
        for (i=0; i<c; ++i)
            v[i].publishStopped (this);
        close ();
    }
	
	[Inline]
	private final function mediaAVStatusChanged(mc:IMediaPlayClient):void
	{
		var v:Vector.<IMediaPlayHandler> = _handlers;
        var i:uint, c:uint = v.length;
        for (i=0; i<c; ++i)
            v[i].mediaAVStatusChanged (this);
	}
	
    [Inline]
    private final function playFailed (reason:String):void
    {
        var v:Vector.<IMediaPlayHandler> = _handlers;
        var i:uint, c:uint = v.length;
        for (i=0; i<c; ++i)
            v[i].mediaPlayFailed (this, reason);
        _connectTimer.stop ();
        close ();
    }
    private final function connectTimeout ():void
    {
        playFailed ("timeout");
    }
    /* ---------------------------- 业务逻辑 ----------------------------*/
    /**
     * 流中是否有音频数据
     */
    public final function get hasAudio ():Boolean
    {
        return _hasAudio;
    }
    /**
     * 流中是否有视频数据
     */
    public final function get hasVideo ():Boolean
    {
        return _hasVideo;
    }
    public final function set bufferTime (time:Number):void
    {
        if (_vstm) _vstm.bufferTime = time;
        if (_audio_playout) _audio_playout.bufferTime = time;
    }
    public final function set bufferTimeMax (time:Number):void
    {
        if (_vstm) _vstm.bufferTimeMax = time;
        if (_audio_playout) _audio_playout.bufferTimeMax = time;
    }
    protected override function updateJitterValue (jv:Array, time:int, dir:int):void
    {
        var d:String = dir ? '(发送): ' : '(接收): ';
        $.logd (logTag, '网络抖动评估', d, jv.join(','), ' 时间: ', time);
        //_handler.mediaPlayUpdateJitterValue(this, jv, time, dir);
        _download_jitter = jv;
        _btm_jitter = (_download_jitter[0] + _upload_jitter[0])/1000.0;
    }
    override public final function set audioOn (on:Boolean):void
    {
        if (_nc == null)
            throw new Error("MediaPlayClient 连接未建立");
        if (_nc is NetConnection)
        {
            _vstm.receiveAudio(_audioOn = on);
        }
        else
        {
            _nc.writeBytes(avStatPacket (8, _audioOn = on));
            _nc.flush ();
            if (_audio_playout != null)
                _audio_playout.flush();
            else if (_audio_detected && _hasAudio)
                _vstm.appendBytes(FLVPacket.zeroAudioPacket(_last_audio_time));
        }
    }
    override public final function set videoOn (on:Boolean):void
    {
        if (_nc == null)
            throw new Error("MediaPlayClient 连接未建立");
        if (_nc is NetConnection)
        {
            _vstm.receiveVideo(_videoOn = on);
        }
        else
        {
            _nc.writeBytes (avStatPacket (9, _videoOn = on));
            _nc.flush ();
        }
    }

    override protected function get servers ():ServerList
    {
        return $.playServers;
    }
    override protected function get protos ():Array
    {
        var protos:Array = ['tcp://', 'http://', 'rtmp://', 'rtmfp://'];
        if ($.mpc)
            protos.push ('udp://');
        return protos;
    }

    override public final function close ():void
    {
        super.close ();
        if (_vstm != null && timerStarted)
        {
            _vstm.close();
            _vstm.dispose();
        }
        if (_audio_playout != null && timerStarted)
        {
            _audio_playout.close();
            _audio_playout.dispose();
        }
        $.removeEventListener('audioCapStop', stopAudioPlayoutMP);
        $.removeEventListener('audioCapStart', startAudioPlayoutMP);
        this.dispatchEvent(new Event(Event.CLOSE));
    }
    public final function simInterrupt (delay:uint = 1000):void
    {
        $.logd (logTag, '模拟中断');
        $.playServers.decPriority (_nc.uri);
        playInterrupted ('simulate-interrupt', delay);
    }
    private function _startPlayFLV ():void
    {
        _vstm = newFLVStream (5);
        if ($.hasAudioCap)
            startAudioPlayoutMP ();

        bufferTime = $.bufferTime;
        bufferTimeMax = $.bufferTimeMax;

        _hbo = _hbi = 0;
        _last_hbo = _last_hbi = 0;
        _audio_pkt_count = _video_pkt_count = 0;
        _last_audio_pkts = _last_video_pkts = 0;
        var pkts:ByteArray = new ByteArray;
        if (_nc is Socket)
            pkts.writeByte (12);
        pkts.writeBytes(loginPacket (2));
        pkts.writeBytes(avStatPacket(8, _audioOn));
        pkts.writeBytes(avStatPacket(9, _videoOn));
        _nc.writeBytes(pkts);
        _nc.flush ();

        _ts_info.clear ();
    }

    private function _stopPlayFLV ():void
    {
        if (timerStarted)
        {
            _vstm.close();
            _vstm.dispose();
            if (_audio_playout != null)
                stopAudioPlayoutMP (null);
        }
    }

    private function stopAudioPlayoutMP (e:Event):void
    {
        if (_audio_playout != null)
        {
            _audio_playout.close();
            _audio_playout.dispose();
            _audio_playout = null;
        }
        $.removeEventListener('audioCapStop', stopAudioPlayoutMP);
        if (e != null)
            $.addEventListener('audioCapStart', startAudioPlayoutMP);
    }
    private function startAudioPlayoutMP(e:Event = null):void
    {
        _audio_playout = AudioPlayoutMP.create($.mpc);
        if (_audio_playout != null)
        {
            if (_audio_detected && hasAudio)
            {
                _vstm.appendBytes(FLVPacket.zeroAudioPacket(_last_audio_time));
                _audio_detected = false;
            }
            $.removeEventListener('audioCapStart', startAudioPlayoutMP);
            $.addEventListener('audioCapStop', stopAudioPlayoutMP);
        }
    }
    private function _startPlayRtmp ():void
    {
        var nc:NetConnection = _nc as NetConnection;
        _vstm = new NetStream (nc);
        _vstm.bufferTime = $.bufferTime;
        _vstm.bufferTimeMax = $.bufferTimeMax;
        _vstm.inBufferSeek = true;
        nc.client.PlayError = handlePlayError;
        nc.client.onPublishControl = onPublishControl;
        _vstm.addEventListener(NetStatusEvent.NET_STATUS, _onStatus, false, 0, true);
        _vstm.play (streamName);
        _vstm.receiveAudio(_audioOn);
        _vstm.receiveVideo(_videoOn);
    }
    private function _stopPlayRtmp ():void
    {
        if (timerStarted)
        {
            _vstm.close();
            _vstm.dispose();
        }
    }
    private function _onStatus (e:NetStatusEvent):void
    {
        if (e.info.clientid && e.info.code == "NetStream.Play.Start")
        {
            $.logi(logTag, '开始播放');
            playStarted (_vstm);
        }
    }
    /* ---------------------------- INetConnectionHandler ----------------------------*/
    nc_internal override function onClose(nc:INetConnection, e:Event):void
    {
        $.playServers.decPriority (_nc.uri);
        if (_connectTimer.running)
        {
            $.loge (logTag, "播放失败: 连接中断 ", nc.uri);
            playFailed ("close");
        }
        else
        {
            $.loge(logTag, '播放连接中断: ', nc.uri);
            playInterrupted ('close');
        }
    }
    nc_internal override function onError(nc:INetConnection, e:Event):void
    {
        $.playServers.decPriority(nc.uri);
        if (_connectTimer.running)
        {
            $.loge (logTag, "播放失败: 连接IO错误 ", nc.uri);
            playFailed ("ioerror");
        }
        else
        {
            $.loge (logTag, '播放连接IO错误: ', nc.uri);
            playInterrupted ('ioerror');
        }
    }

    nc_internal function reconnect (delay:uint = 1000):void
    {
        if (_nc is NetConnection)
            _stopPlayRtmp();
        else
            _stopPlayFLV ();
        if (_nc != null)
        {
            _nc.dispose();
            _nc = null;
        }
        super.close ();
        $.removeEventListener('audioCapStop', stopAudioPlayoutMP);
        $.removeEventListener('audioCapStart', startAudioPlayoutMP);
        if (delay > 0)
        {
            var id:uint = setTimeout (function ():void {
                connect ();
                clearTimeout (id);
            }, delay);
        }
        else
        {
            connect ();
        }
    }
    nc_internal override function handlePacket(nc:INetConnection, type:uint, pkt:ByteArray):void
    {
        if (pkt == null)
            return;
        switch (type)
        {
        case 62:
            $.logi(logTag, '收到测速包，准备开始播放');
            _nc = nc;
            _startPlayFLV ();
            break;
        case 1: // play started
            handlePlayStarted (pkt);
            break;
        case 5:
            handlePingPacket (pkt);
            break;
        case 10:
            handlePingResponsePacket (pkt);
            break;
        case 7: // video data
            if (_videoOn)
                handleVideoPacket (pkt);
            break;
        case 8: // audio data
            if (_audioOn)
                handleAudioPacket (pkt);
            break;
        case 9:
            handleStatusPacket (pkt);
            break;
        }
    }

    private function handlePlayStarted (pkt:ByteArray):void
    {
        var ok:Boolean = pkt.readBoolean();
        var name:String = pkt.readUTF();
        remoteAddr = [pkt.readUTF(), pkt.readUnsignedShort()].join(':');
        $.logi(logTag, '本机外网地址: ', remoteAddr);
        if (ok)
        {
            $.logi(logTag, '开始播放');
            playStarted (_vstm);
        }
        else
            handlePlayError (name, pkt.readInt());
    }
    private function handleAudioPacket (pkt:ByteArray):void
    {
        var localTS:int = getTimer();
        var mediaTS:uint = pkt.readUnsignedInt();
        _ts_info.push (mediaTS, localTS, true);
        _ajb.update (mediaTS, localTS);
        ++_audio_pkt_count;
        if (_audio_playout)
        {
            if (_seek_status == SEEK_AUDIO && _audio_playout != null)
            {
                _audio_playout.flush();
                _seek_status = SEEK_IDLE;
            }
            if (pkt.length > 4)
                _audio_playout.handleAudioPacket (mediaTS, pkt, 4, pkt.length - 4);
        }
        else
        {
            _audio_detected = pkt.length > 4;
            _last_audio_time = mediaTS;
            _vstm.appendBytes(FLVPacket.makeFLVPacket(8, mediaTS, pkt));
        }
    }
    private function handleVideoPacket (pkt:ByteArray):void
    {
        var localTS:int = getTimer ();
        var mediaTS:uint = pkt.readUnsignedInt();
        _ts_info.push (mediaTS, localTS, false);
        _vjb.update (mediaTS, localTS);
        if (_seek_status == SEEK_VIDEO && (pkt[4]&0xf0) == 0x10)
        {
            $.logi (logTag, 'Seek Video');
            _flvSeek (_vstm);
            if (_audio_playout)
                _audio_playout.flush();
            _seek_status = SEEK_IDLE;
        }
        ++_video_pkt_count;

        _vstm.appendBytes(FLVPacket.makeFLVPacket(9, mediaTS, pkt));
		
		if (_min_vstm_buffer_length == 0)
		{
			_min_vstm_buffer_length = _vstm.bufferLength;
		}
		if(_min_vstm_buffer_length > _vstm.bufferLength)
		{
			_min_vstm_buffer_length = _vstm.bufferLength;
		}
    }
    private function handleStatusPacket (pkt:ByteArray):void
    {
        switch (pkt[0])
        {
        case 1: // 流关闭
            _hasAudio = false;
            _hasVideo = false;
            $.logi(logTag, '发布端关闭');
            publishStopped ();
            break;
        case 2: // 视频打开
            $.logi(logTag, '视频打开');
            _hasVideo = true;
            if (_videoOn && !(_nc is NetConnection))
                _flvSeek (_vstm);
            mediaAVStatusChanged(this);
            break;
        case 3: // 视频关闭
            $.logi(logTag, '视频关闭');
            _hasVideo = false;
            mediaAVStatusChanged(this);
            if (!_hasAudio)
            {
                _seek_status = SEEK_IDLE;
                break;
            }
            break;
        case 4: // 音频打开
            $.logi(logTag, '音频打开');
            _hasAudio = true;
            if (_audio_playout != null)
                _audio_playout.flush();
            mediaAVStatusChanged(this);
            break;
        case 5: // 音频关闭
            $.logi(logTag, '音频关闭');
            _hasAudio = false;
            if (_audio_playout != null)
                _audio_playout.flush();
            mediaAVStatusChanged(this);
            break;
        case 6: // 上传流的抖动状态
            pkt.readByte();
            _upload_jitter[0] = pkt.readInt();
            _upload_jitter[1] = pkt.readInt();
            _upload_jitter[2] = pkt.readInt();
            _btm_jitter = (_download_jitter[0] + _upload_jitter[0])/1000.0;
            $.logv(logTag, '抖动状态: ', _upload_jitter.join(','));
            break;
        }
    }
    private var _vbl_ar:Array, _abl_ar:Array;
    nc_internal override function handleTimer (seq:uint):void
    {
        var now:int = getTimer();
        var aj:int = 1, vj:int = 1;
        if (!(_nc is NetConnection) && $.hasInspector && _ts_info.count)
        {
            var bytes:ByteArray = new LEByteArray;
            _ts_info.pack (bytes);
            bytes.compress();
            $.sendTSInfo (avstm.avid, bytes);
        }
        if (_audioOn && _hasAudio)
        {
            _ajb.clean_b(15000, now);
            var ajb:Array = _ajb.calc();
            if (ajb) aj = ajb[1];
        }
        if (_videoOn && _hasVideo)
        {
            _vjb.clean_b(15000, now);
            var vjb:Array = _vjb.calc();
            if (vjb) vj = vjb[1];
        }
        if (_show_jb)
        {
            ExternalInterface.call('updateAVJitter', name, aj, vj);
        }
        if (now - _last_ping_in >= 40000)
        {
            var server:String = _nc.uri;
            playInterrupted ('ping-timeout');
            $.playServers.decPriority(server);
            $.playServers.decPriority(server);
            $.logw(logTag, '播放连接 ping 包超时');
            reconnect ();
            return;
        }

        if (seq == 1)
        {
            _vbl_ar = [0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0];
            _abl_ar = [0,0,0,0, 0,0,0,0, 0,0,0,0, 0,0,0,0];
        }
        var index:uint = (seq-1)&15;
        _vbl_ar[index] = _vstm.bufferLength;
        if (_audio_playout != null)
            _abl_ar[index] = _audio_playout.bufferLength;
        if ((seq & 15) == 0)
            printBufferDetail();
        if ((seq & 7) == 0)
        {
            $.logv (logTag, '音频包: ', _audio_pkt_count - _last_audio_pkts,
                ', 视频包: ', _video_pkt_count - _last_video_pkts);
            _last_audio_pkts = _audio_pkt_count;
            _last_video_pkts = _video_pkt_count;
        }
		
		// history the min buffer size
		if (_min_vstm_buffer_length == 0)
		{
			_min_vstm_buffer_length = _vstm.bufferLength;
		}
		if(_min_vstm_buffer_length > _vstm.bufferLength)
		{
			_min_vstm_buffer_length = _vstm.bufferLength;
		}
		
        super.nc_internal::handleTimer(seq);
        var threshold:Number = $.bufferTimeMax + _btm_jitter;
        if (_nc is NetConnection)
        {
            if (_vstm.bufferLength > threshold)
            {
                $.logi (logTag, '快进一帧 ', _vstm.inBufferSeek);
                _vstm.step(1);
            }
        }
        else
        {
            if ((_hasAudio || _hasVideo) && (seq & 5) == 0)
            {
                var needSeek:Boolean = false;
                if (_hasVideo && (_min_vstm_buffer_length > threshold || (_audio_playout && _audio_playout.bufferLength > threshold))) //_vstm.bufferLength > threshold
                {
                    if (_seek_status == SEEK_IDLE || _seek_status == SEEK_AUDIO)
                    {
                        $.logi(logTag, '准备 Seek Video 中...');
                        _seek_status = SEEK_VIDEO;
                    }
					_min_vstm_buffer_length = 0;
                    return;
                }
				_min_vstm_buffer_length = 0;
                if (_hasAudio && _audio_playout && _audio_playout.bufferLength > threshold)
                {
                    if (_seek_status == SEEK_IDLE)
                    {
                        $.logi(logTag, 'Seek Audio');
                        _audio_playout.flush();
                    }
                }
            }
        }
    }
    private function printBufferDetail ():void
    {
        var ar:Array = Misc.average_sd(_vbl_ar, 16);
        if (_nc is NetConnection || _audio_playout == null)
        {   // 用 RTMP/RTMPFP 连接的话，音频和视频是在同一个 NetStream 对象上播放
            // _audio_playout 为 null 表示音视频未分开播放
            $.logd(logTag, '缓冲区 平均值: ', ar[0].toFixed(3), ' 标准差: ', ar[1].toFixed(5));
            return;
        }
        // 其他情况下，音频和视频是分开播放的
        if (_hasVideo)
        {
            $.logd(logTag, '视频缓冲区 平均值: ', ar[0].toFixed(3), ' 标准差: ', ar[1].toFixed(5));
        }
        if (_hasAudio)
        {
            ar = Misc.average_sd(_abl_ar, 16);
            $.logd(logTag, '音频缓冲区 平均值: ', ar[0].toFixed(3), ' 标准差: ', ar[1].toFixed(5));
        }
    }
    /* ---------------------------- INetConnectionPoolHandler ----------------------------*/
    ncp_internal override function onConnectDone (nc:INetConnection, count:uint):void
    {
        super.ncp_internal::onConnectDone (nc, count);
        $.logi(logTag, '成功连接至媒体播放服务器: ', nc.uri);

        _ajb = new JitterBuffer;
        _vjb = new JitterBuffer;
        nc.netHandler = this;
        _nc = nc;
        playStarting ();
        if (nc is NetConnection)
        {   // RTMP 连接，直接播放
            remoteAddr = nc['remoteAddr'];
            $.logi(logTag, '本机外网地址: ', remoteAddr);
            _startPlayRtmp ();
        }
        else
        {   // 发送一个大包, 保证 PMTU Discoverty 提前完成
            var pkt:ByteArray = NetConnectionPool.testSpeedPacket ();
            nc.writeBytes(pkt);
            nc.flush();
        }
    }
    ncp_internal override function onConnectFail ():void
    {
        super.ncp_internal::onConnectFail ();
        $.loge(logTag, '无法连接至任何播放服务器 ',
            JSON.stringify($.playServers.serversByPriority()));
        playFailed ('connect');
    }

    private function onPublishControl (code:uint, ...args):void
    {
        var pkt:ByteArray = new LEByteArray;
        pkt.writeByte (code);
        if (code == 6)
        {
            pkt.writeInt(args[0]);
            pkt.writeInt(args[1]);
            pkt.writeInt(args[2]);
        }
        pkt.position = 0;
        handleStatusPacket (pkt);
    }
    private function handlePlayError (name:String, code:int):void
    {
        $.loge(logTag, '播放失败: code=', code);
        switch (code)
        {
        case ERROR_TIMEOUT:
            playInterrupted ('timeout');
            break;
        case ERROR_BADKEY:
            playFailed ('badkey');
            break;
        case ERROR_OVERLOAD:
            var server:String = _nc.uri;
            $.playServers.decPriority (server);
            $.playServers.decPriority (server);
            $.logw (logTag, '播放服务器要求切换成其他服务器');
            playInterrupted ('overload');
            break;
        }
    }
    private function onModeChanged (e:Event):void
    {
        bufferTime = $.bufferTime;
        bufferTimeMax = $.bufferTimeMax;
    }
}
}
import com.e2et.utils.Misc;

import flash.net.NetStreamAppendBytesAction;

[Inline]
function _flvSeek (stm:Object):void
{
    stm.seek(0);
    stm.appendBytesAction(NetStreamAppendBytesAction.RESET_SEEK);
}
const SEEK_IDLE:int = 0;
const SEEK_AUDIO:int = 1;
const SEEK_VIDEO:int = 2;

const ERROR_TIMEOUT:int = 1;
const ERROR_BADKEY:int = 2;
const ERROR_OVERLOAD:int = 3;

class JitterBuffer
{
    private var _ta:int, _tb:int;
    private var _tsa:Array, _tsb:Array, _tsd:Array;
    private var _updated:Boolean;
    private var _result:Array;
    public function JitterBuffer ()
    {
        _tsa = [];
        _tsb = [];
        _tsd = [];
    }
    public function update(ta:int, tb:int):void
    {
        _ta = ta & 0xffffff;
        _tb = tb & 0xffffff;
        _updated = true;
        _result = null;
    }
    public function clean_a(alen:int, ts:int):void
    {
        ts &= 0xffffff;
        var i:int, c:int = _tsa.length;
        for (i=0; i<c; ++i)
        {
            var diff:int = ts - _tsa[i];
            if (diff < 0) diff += 0x1000000;
            if (diff <= alen)
                break;
        }
        if (i)
        {
            _tsa.splice(0, i);
            _tsb.splice(0, i);
            _tsd.splice(0, i);
            _result = null;
        }
    }
    public function clean_b(blen:int, ts:int):void
    {
        ts &= 0xffffff;
        var i:int, c:int = _tsb.length;
        for (i=0; i<c; ++i)
        {
            var diff:int = ts - _tsb[i];
            if (diff < 0) diff += 0x1000000;
            if (diff <= blen)
                break;
        }
        if (i)
        {
            _tsa.splice(0, i);
            _tsb.splice(0, i);
            _tsd.splice(0, i);
            _result = null;
        }
    }
    public function calc ():Array
    {
        if (_result)
            return _result;

        if (_updated)
        {
            _tsa.push (_ta);
            _tsb.push (_tb);
            _tsd.push (_tb - _ta);
            _updated = false;
        }
        var c:int = _tsd.length;
        if (c >= 5)
        {
            _result = Misc.average_sd(_tsd);
            _result[0] = Number(_result[0].toFixed(0));
            _result[1] = Number(_result[1].toFixed(0));
            _result.push (c, _tsa[0], _tsa[c-1], _tsb[0], _tsb[c-1]);
        }
        else
            _result = null;
        return _result;
    }
}
