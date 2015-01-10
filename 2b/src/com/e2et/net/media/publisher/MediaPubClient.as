package com.e2et.net.media.publisher
{
import com.e2et.Session;
import com.e2et.datalogic.AVStream;
import com.e2et.net.ServerList;
import com.e2et.net.nc_internal;
import com.e2et.net.ncp_internal;
import com.e2et.net.connection.INetConnection;
import com.e2et.net.connection.NetConnectionPool;
import com.e2et.net.media.IMediaSink;
import com.e2et.net.media.IMediaSource;
import com.e2et.net.media.MediaClient;
import com.e2et.net.media.audio.IAudioCapture;
import com.e2et.net.media.video.IVideoCapture;
import com.e2et.utils.LEByteArray;

import flash.events.Event;
import flash.events.NetStatusEvent;
import flash.events.OutputProgressEvent;
import flash.events.TimerEvent;
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
 * 媒体发布 - 发布连接中断后，不能在原来的实例上进行重新连接
 * @author Bin Tian
 * rtmp/rtmfp - 直接上传，无回音消除，只支持 mic + camera
 */
public class MediaPubClient extends MediaClient implements IMediaSink, IMediaPubClient
{
    public static const ERROR_DUPNAME:int = 0;
    public static const ERROR_TIMEOUT:int = 1;
    public static const ERROR_BADKEY:int = 2;
    public static const ERROR_OVERLOAD:int = 3;

    private var _audio_cap:IAudioCapture = null;
    private var _video_cap:IVideoCapture = null;

    private var _handlers:Vector.<IMediaPubHandler> = new Vector.<IMediaPubHandler>;

    private var _stm:NetStream = null;
    private var _flv_pkts:Array = [];
    private var _flushing:Boolean = false;
    private var _last_audio_pkt:ByteArray;

    private var _connectTimer:Timer = new Timer (5000, 1);

    public function MediaPubClient($:Session, av:AVStream)
    {
        super($, av);
        _logTag = '媒体发布[' + name + ']: ';
        _ping_timer_interval = 10;
        _connectTimer.addEventListener (TimerEvent.TIMER, function (e:Event):void {
            publishFailed ("timeout");
        });
    }
    public final function addHandler (h:IMediaPubHandler):void
    {
        var v:Vector.<IMediaPubHandler> = _handlers;
        if (v.indexOf (h) < 0)
            v.push (h);
    }
    public final function delHandler (h:IMediaPubHandler):void
    {
        var i:int, v:Vector.<IMediaPubHandler> = _handlers;
        if ((i = v.indexOf (h)) >= 0)
            v.splice (i, 1);
    }
    [Inline]
    private final function publishStarting (stm:NetStream):void
    {
        var v:Vector.<IMediaPubHandler> = _handlers;
        var i:uint, c:uint = v.length;
        for (i=0; i<c; ++i)
            v[i].publishStarting (this, stm);
        _avstm.state = AVStream.STARTING;
        _connectTimer.reset ();
        _connectTimer.start ();
    }
    [Inline]
    private final function publishStarted (stm:NetStream):void
    {
        var v:Vector.<IMediaPubHandler> = _handlers;
        var i:uint, c:uint = v.length;
        for (i=0; i<c; ++i)
            v[i].publishStarted (this, stm);
        _avstm.state = AVStream.STARTED;
        _connectTimer.stop ();
        startClientTimer ();
        if ($.recording)
            this.recordStart ($.videoId+'.'+name+'.flv', true);
    }
    [Inline]
    private final function publishInterrupted (reason:String, delay:uint = 1500):void
    {
        var v:Vector.<IMediaPubHandler> = _handlers;
        var i:uint, c:uint = v.length;
        for (i=0; i<c; ++i)
            v[i].publishInterrupted (this, reason);
        _avstm.state = AVStream.BROKEN;
        _connectTimer.stop ();
        reconnect (delay);
    }
    [Inline]
    private final function publishFailed (reason:String):void
    {
        var v:Vector.<IMediaPubHandler> = _handlers;
        var i:uint, c:uint = v.length;
        for (i=0; i<c; ++i)
            v[i].publishFailed (this, reason);
        _avstm.state = AVStream.FAILED;
        _connectTimer.stop ();
        close ();
    }
    override protected final function get protos ():Array
    {
        var protos:Array;
        if ($.mpc == null)
            protos = ['tcp://', 'udp://'];
        else
            protos = ['rtmp://', 'rtmfp://'];
        if (_video_cap != null)
            _video_cap.checkProtoSupport(protos);
        if (_audio_cap != null)
            _audio_cap.checkProtoSupport(protos);
        if (protos.length == 0)
            throw new Error('没有合适的服务器');
        if ($.publishServers.serversByPriority(protos).length == 0)
            throw new Error('没有合适的服务器');

        return protos;
    }
    override protected final function get servers ():ServerList
    {
        return $.publishServers;
    }

    /**
     * 断开连接
     */
    override public function close ():void
    {
        if (_stm)
            rtmpPublishStop();
        else
            tcpPublishStop ();
        attachVideo(null);
        attachAudio(null);
        super.close ();
        this.dispatchEvent (new Event(Event.CLOSE));
    }
    private final function reconnect (delay:int = 1500):void
    {
        if (_stm)
            rtmpPublishStop();
        else
            tcpPublishStop ();
        stopClientTimer ();
        if (delay > 0) {
            var id:uint = setTimeout (function ():void {
                connect ();
                clearTimeout (id);
            }, delay);
        } else {
            connect ();
        }
    }
    public final function simInterrupt (delay:uint = 1500):void
    {
        $.logd(logTag, '模拟中断');
        $.publishServers.decPriority (_nc.uri);
        publishInterrupted ('simulate-interrupt', delay);
    }
    public function get audioCap():IAudioCapture
    {
        return _audio_cap;
    }
    public function get videoCap():IVideoCapture
    {
        return _video_cap;
    }
    public final function get hasAudio():Boolean
    {
        return _audio_cap != null;
    }
    public final function get hasVideo():Boolean
    {
        return _video_cap != null;
    }
    /**
     * 绑定视频流 - Notes: 发布成功后，调用 attachVideo 不会改变 videoOn 属性
     * @param video
     * @param close
     */
    public function attachVideo (video:IVideoCapture = null, close:Boolean = true):IVideoCapture
    {
        var old:IVideoCapture = _video_cap;

        _video_cap = video;

        this.dispatchEvent(new Event('avStatus'));

        if (_videoOn)
        {
            if (video == null)
                sendVideoStatus (_videoOn = false);
            else
                video.addSink(this), video.start(_stm);
        }
        if (!close)
            return old;
        if (old) old.dispose();
        return null;
    }
    /**
     * 绑定音频流 - Notes: 发布成功后，调用 attachAudio 不会改变 audioOn 属性
     * @param audio
     * @param close
     */
    public function attachAudio (audio:IAudioCapture = null, close:Boolean = true):IAudioCapture
    {
        var old:IAudioCapture = _audio_cap;

        _audio_cap = audio;

        this.dispatchEvent(new Event('avStatus'));

        if (_audioOn)
        {
            if (audio == null)
                sendAudioStatus (_audioOn = false);
            else
                audio.addSink(this), audio.start(_stm);
        }
        if (!close)
            return old;
        if (old) old.dispose();
        return null;
    }

    override public function set videoOn(on:Boolean):void
    {
        if (_video_cap == null || _nc == null)
            return;
        if (_videoOn && !on)
        {
            _video_cap.stop();
            _video_cap.delSink(this);
        }
        else if (!_videoOn && on)
        {
            _video_cap.addSink(this);
            _video_cap.start(_stm);
        }
        else
            return;

        sendVideoStatus (_videoOn = on);
    }

    override public function set audioOn(on:Boolean):void
    {
        if (_audio_cap == null || _nc == null)
            return;
        if (_audioOn && !on)
        {
            _audio_cap.delSink(this);
            _audio_cap.stop();
            if (_last_audio_pkt)
            {   // 关闭音频后,需要发送一个长度为 0 的音频包, 否则下次播放音频数据时会清空缓冲区
                _last_audio_pkt.length = 5;
                this.handleMediaData(null, _last_audio_pkt);
                _last_audio_pkt = null;
            }
        }
        else if (!_audioOn && on)
        {
            _audio_cap.addSink(this);
            _audio_cap.start(_stm);
        }
        else
            return;

        sendAudioStatus (_audioOn = on);
    }

    public final function recordStart (file:String, recordVideo:Boolean):void
    {
        $.logw(logTag, '调用录制开始: ', file, ' 录制视频: ', recordVideo);
        if (_nc == null)
            throw new Error ('未连接');
        if (_nc is NetConnection)
        {
            (_nc as NetConnection).call('record', null, file, recordVideo, $.videoId);
        }
        else
        {
            _nc.writeBytes(recordPacket (true, file, recordVideo, $.videoId));
            _nc.flush ();
        }
    }
    public final function recordStop ():void
    {
        $.logw(logTag, '调用录制结束');
        if (_nc == null)
            throw new Error ('未连接');
        if (_nc is NetConnection)
        {
            (_nc as NetConnection).call('stoprecord', null);
        }
        else
        {
            _nc.writeBytes(recordPacket (false));
            _nc.flush ();
        }
    }
    [Inline]
    private final function sendAudioStatus (on:Boolean):void
    {
        if (_nc == null) return;
        if (_stm != null)
            _stm.receiveAudio(on);
        else
            _nc.writeBytes(avStatPacket (8, on)), _nc.flush();
    }
    [Inline]
    private final function sendVideoStatus (on:Boolean):void
    {
        if (_nc == null) return;
        if (_stm != null)
            _stm.receiveVideo(on);
        else
            _nc.writeBytes(avStatPacket (9, on)), _nc.flush();
    }

    /* ---------------------------- INetConnectionHandler ----------------------------*/
    nc_internal override function onClose (nc:INetConnection, e:Event):void
    {
        $.publishServers.decPriority(nc.uri);
        if (_connectTimer.running)
        {
            $.loge (logTag, '发布失败: 连接中断 ', nc.uri);
            publishFailed ("close");
        }
        else
        {
            $.loge (logTag, '发布连接中断: ', nc.uri);
            publishInterrupted ('close');
        }
    }

    nc_internal override function onError (nc:INetConnection, e:Event):void
    {
        $.publishServers.decPriority(nc.uri);
        if (_connectTimer.running)
        {
            $.loge (logTag, '发布失败: 连接IO错误 ', nc.uri);
            publishFailed ("ioerror");
        }
        else
        {
            $.loge (logTag, '发布连接IO错误: ', nc.uri);
            publishInterrupted ('ioerror');
        }
    }

    nc_internal override function handlePacket (nc:INetConnection, type:uint, pkt:ByteArray):void
    {
        if (pkt == null)
            return;
        switch (type)
        {
        case 62:
            $.logi (logTag, '收到测速包, 开始发布');
            tcpPublishStart ();
            break;
        case 1:
            handlePublishStarted(pkt);
            break;
        case 3:
            handleRecord (!pkt.readBoolean(), pkt.readUTF(), pkt.readBoolean());
            break;
        case 5: // 心跳
            handlePingPacket (pkt);
            break;
        case 10:
            handlePingResponsePacket (pkt);
            break;
        case 6: // 服务器要求切换至其他服务器
            var server:String = nc.uri;
            $.publishServers.decPriority(server);
            $.publishServers.decPriority(server);
            $.logw (logTag, '发布服务器要求切换成其他服务器');
            publishInterrupted ('switch');
            break;
        }
    }

    private final function handlePublishStarted (pkt:ByteArray):void
    {
        var ok:Boolean = pkt.readBoolean();
        pkt.readUTF();
        remoteAddr = [pkt.readUTF(), pkt.readUnsignedShort()].join(':');
        $.logi(logTag, '本机外网地址: ', remoteAddr);
        if (ok)
        {
            $.logi(logTag, '流发布成功');
            sendAudioStatus (_audioOn = false);
            sendVideoStatus (_videoOn = false);
            this.audioOn = true;
            this.videoOn = true;
            publishStarted (_stm);
        }
        else
            handlePublishError (name, pkt.readInt());
    }

    private function tcpPublishStart ():void
    {
        $.addEventListener(Session.PROXY_CLOSE, onProxyClose);
        $.addEventListener(Session.PROXY_IOERROR, onProxyClose);
        var pkts:ByteArray = new ByteArray;
        if (_nc is Socket)
            pkts.writeByte (14);
        pkts.writeBytes (loginPacket (1));
        _nc.writeBytes (pkts);
        _nc.flush ();
        _connectTimer.reset ();
        _connectTimer.start ();
    }

    private function tcpPublishStop ():void
    {
        $.removeEventListener(Session.PROXY_CLOSE, onProxyClose);
        $.removeEventListener(Session.PROXY_IOERROR, onProxyClose);
        this.audioOn = false;
        this.videoOn = false;
        if (_nc != null)
        {
            _nc.dispose();
            _nc = null;
        }
    }

    private function onProxyClose (e:Event):void
    {
        $.loge(logTag, '媒体代理连接中断');
        publishInterrupted ('proxy-closed');
    }
    /* ---------------------------- INetConnectionPoolHandler ----------------------------*/
    override ncp_internal function onConnectDone (nc:INetConnection, count:uint):void
    {
        super.ncp_internal::onConnectDone(nc, count);
        $.logi(logTag, '成功连接至媒体发布服务器: ', nc.uri);

        nc.netHandler = this;
        if (nc is NetConnection)
        {
            var c:NetConnection = nc as NetConnection;
            remoteAddr = nc['remoteAddr'];
            $.logi(logTag, '本机外网地址: ', remoteAddr);
            c.client.PublishError = handlePublishError;
            c.client.record = function (file:String, result:Boolean):void {
                handleRecord (true, file, result);
            };
            c.client.stoprecord = function (file:String, result:Boolean):void {
                handleRecord (false, file, result);
            };
            _nc = nc;
            _stm = new NetStream (_nc as NetConnection);
            _stm.audioReliable = true;
            // RTMFP 服务端暂时不支持，先不设置了
            //_stm.videoReliable = false;
            _stm.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus, false, 0, true);
            $.logi(logTag, '准备发布中');
            publishStarting (_stm);
            _stm.publish (streamName);browserLog('streamName', streamName);
            _stm.receiveAudio(false);
            _stm.receiveVideo(false);
        }
        else
        {
            _nc = nc;
            publishStarting (_stm = null);
            // 发送一个大包, 保证 PMTU Discoverty 提前完成
            var pkt:ByteArray = NetConnectionPool.testSpeedPacket ();
            nc.writeBytes(pkt);
            nc.flush();
        }
    }

    override ncp_internal function onConnectFail ():void
    {
        super.ncp_internal::onConnectFail ();
        $.loge(logTag, '无法连接上任何发布服务器');
        publishFailed ('connect');
    }

    private function rtmpPublishStart ():void
    {
        this.sendAudioStatus(false);
        this.sendAudioStatus(false);
        this.audioOn = true;
        this.videoOn = true;
        publishStarted (_stm);
    }
    private function rtmpPublishStop ():void
    {
        this.audioOn = false;
        this.videoOn = false;
        if (_stm)
        {
            _stm.removeEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
            _stm.close ();
            _stm.dispose ();
            _stm = null;
        }
        if (_nc != null)
        {
            _nc.dispose();
            _nc = null;
        }
    }

    nc_internal override function handleTimer (seq:uint):void
    {
        if (getTimer () - _last_ping_in >= 40000)
        {
            var server:String = _nc.uri;
            publishInterrupted ('ping-timeout');
            $.playServers.decPriority (server);
            $.playServers.decPriority (server);
            $.loge (logTag, '发布连接 ping 包超时');
            return;
        }
        super.handleTimer(seq);
    }

    protected override function updateJitterValue (jv:Array, time:int, dir:int):void
    {
        var d:String = dir ? '(发送): ' : '(接收): ';
        $.logd (logTag, '网络抖动评估', d, jv.join(','), ' 时间: ', time);
        //_handler.publishUpdateJitterValue(this, jv, time, dir);
    }
    private function onNetStatus (e:NetStatusEvent):void
    {
        switch (e.info.code)
        {
        case 'NetStream.Publish.Start':
            $.logi(logTag, '流发布成功');
            rtmpPublishStart ();
            break;
        }
    }
    private function handlePublishError (name:String, code:int):void
    {
        $.loge (logTag, '流发布失败: code=', code);
        publishFailed ('publish');
    }

    public final function handleMediaData (source:IMediaSource, flv:ByteArray):void
    {
        var sock:Socket = _nc as Socket;
        if (sock == null)
        {
            // 16 - 8 = 8 音频
            // 16 - 9 = 7 视频
            var pkt:ByteArray = new LEByteArray;
            pkt.writeByte (16 - flv[0]);
            pkt.writeUnsignedInt(flv.length - 1);
            pkt.writeBytes(flv, 1, flv.length - 1);
            _nc.writeBytes(pkt);
            return;
        }
        var tag:uint = flv[0];
        if (!_audioOn && tag == 8)
            return;
        if (!_videoOn && tag == 9)
            return;
        if (tag == 8)
            _last_audio_pkt = flv;
        /*
        if (sock.bytesPending)
        {
            if (_flv_pkts.length == 0)
                sock.addEventListener(OutputProgressEvent.OUTPUT_PROGRESS, _onOut);
            _flv_pkts.push (flv);
        }
        else
        */
            sendMediaData (sock, flv);
    }

    private function _onOut (e:OutputProgressEvent):void
    {
        var sock:Socket = e.target as Socket;
        if (sock.bytesPending)
            return;
        sock.removeEventListener(OutputProgressEvent.OUTPUT_PROGRESS, _onOut);
        if (_flv_pkts.length)
        {
            var i:int, c:int = _flv_pkts.length;
            for (i=0; i<c; ++i)
            {
                if (sock.bytesPending) break;
                sendMediaData (sock, _flv_pkts[i]);
            }
            _flv_pkts.splice(0, i);
        }
    }

    private function handleRecord (record:Boolean, file:String, result:Boolean):void
    {
        $.logw(logTag, '录制回调: ', record, ' ', file);
        //_handler.recordStatus (this, record, file, result);
    }
    static private function sendMediaData (sock:Socket, pkt:ByteArray):void
    {
        // 16 - 8 = 8 音频
        // 16 - 9 = 7 视频
        sock.writeByte (16 - pkt[0]);
        sock.writeUnsignedInt(pkt.length - 1);
        sock.writeBytes(pkt, 1, pkt.length - 1);
        sock.flush();
    }
}
}
