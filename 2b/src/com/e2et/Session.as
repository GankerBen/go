package com.e2et
{
import com.e2et.datalogic.AVReq;
import com.e2et.datalogic.AVStream;
import com.e2et.datalogic.LocalUser;
import com.e2et.datalogic.Room;
import com.e2et.datalogic.User;
import com.e2et.datalogic.Users;
import com.e2et.net.ServerList;
import com.e2et.net.SpeedTest;
import com.e2et.net.TimeSync;
import com.e2et.net.ULog;
import com.e2et.net.media.audio.IAudioCapture;
import com.e2et.net.media.audio.MicCapture;
import com.e2et.net.media.player.IMediaPlayClient;
import com.e2et.net.media.player.MediaPlayClient;
import com.e2et.net.media.publisher.IMediaPubClient;
import com.e2et.net.media.publisher.MediaPubClient;
import com.e2et.net.media.video.CamCapture;
import com.e2et.net.media.video.IPCamCapture;
import com.e2et.net.media.video.IVideoCapture;
import com.e2et.net.media.video.ScreenCapture;
import com.e2et.net.proxy.MediaProxyClient;
import com.e2et.net.signal.SignalClient;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.media.Camera;
import flash.media.H264Level;
import flash.media.H264Profile;
import flash.media.H264VideoStreamSettings;
import flash.media.Microphone;
import flash.media.VideoStreamSettings;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.system.Capabilities;
import flash.utils.ByteArray;
import flash.utils.Dictionary;

/**
 * 会话信息
 * @author Bin Tian
 */
public class Session implements ISession, IEventDispatcher
{
    public static const PROXY_CONNECTED:String = "proxy-connected";
    public static const PROXY_IOERROR:String = "proxy-ioerror";
    public static const PROXY_CLOSE:String = "proxy-closed";

    private var _key:String;
    private var _room:Room;
    private var _user:LocalUser;
    private var _tokenUser:User;
    private var _videoId:String;
    private var _plugins:Object;

    private var _docBase:String = 'http://doc.tetequ.com/';

    private var _signal_servers:ServerList = null;
    private var _play_servers:ServerList = null;
    private var _pub_servers:ServerList = null;

    private var _mpc:MediaProxyClient;
    private var _signal:SignalClient;
    private const _user_update_requests:Dictionary = new Dictionary;

    private var _sid:String;

    private var _steps:int = 0;

    private var _handler:ISessionHandler;
    private var _pub_count:int = 0;
    private var _pub_clients:Object = {}; // key: 流名字
    private var _play_clients:Object = {}; // key: 流名字
    private var _bufferTime:Array, _bufferTimeMax:Array;
    private var _ncpDelay:int = 1000;
    private var _rpc_client:Object = { };
    private var _rpc_client_internal:Object = { };

    private var _speed_test:SpeedTest;
    private var _log:ULog;
    private var _ed:EventDispatcher;
    private var _userClass:Class = User;

    /**
     * 各种调试数据或统计数据将发向 _inspectors
     */
    private const _inspectors:Vector.<User> = new Vector.<User>;

    static public const LIVE_MODE:int = 0;
    static public const INTERACT_MODE:int = 1;

    public function Session (room:Room)
    {
        _user = room.localUser;
        _room = room;
        var rand:uint = Math.floor(Math.random()*900000) + 100000;
        var sid:String = [room.app, room.org, room.id, rand, user.userid, user.name].join(',');
        _log = new ULog (sid);
        _ed = new EventDispatcher (this);

        init_rpc_client_internal ();
    }

    [Inline]
    public final function init (handler:ISessionHandler):void
    {
        _steps = 0;
        _handler = handler;
        _handler.sessionStarting (this);
        mediaProxyInit ();
        loadServerList ();
        syncTime ();
        _signal = new SignalClient (this, _room, new SignalHandler (this));
    }

    [Inline]
    public final function close ():void
    {
        if (_signal)
        {
            _signal.logout ();
            _signal = null;
        }
    }
    public function newMediaPlayClient (av:AVStream):IMediaPlayClient
    {
        var client:MediaPlayClient = new MediaPlayClient (this, av);
        var avid:uint = av.avid;
        function onClose (e:Event):void
        {
            delete _play_clients[avid];
            client.removeEventListener(Event.CLOSE, onClose);
        }
        client.addEventListener(Event.CLOSE, onClose);
        return _play_clients[avid] = client;
    }
    public function newMediaPubClient (av:AVStream):IMediaPubClient
    {
        var client:MediaPubClient = new MediaPubClient (this, av);
        var avid:uint = av.avid;
        function onClose (e:Event):void
        {
            if (avid in _pub_clients)
            {
                delete _pub_clients[avid];
                if (0 == --_pub_count)
                    dispatchEvent(new Event('modeChanged'));
            }
            client.removeEventListener(Event.CLOSE, onClose);
        };
        client.addEventListener(Event.CLOSE, onClose);
        _pub_clients[avid] = client;
        if (1 == ++_pub_count)
            dispatchEvent(new Event('modeChanged'));
        return client;
    }
    public function newMicCapture (mic:Microphone):IAudioCapture
    {
        return new MicCapture (this, mic);
    }
    public function newCamCapture (cam:Camera):IVideoCapture
    {
        return new CamCapture (this, cam);
    }
    public function newScreenCapture (closure:Function):IVideoCapture
    {
        var mpc:MediaProxyClient = this.mpc;
        if (mpc == null)
            throw new Error ('未连接插件代理');
        if (mpc.screencap)
            throw new Error ('屏幕共享运行中...');
        var cap:ScreenCapture = new ScreenCapture (this, mpc, closure);
        mpc.screencap = cap;
        return cap;
    }
    public function newIPCamCapture (ipcam:String):IVideoCapture
    {
        return new IPCamCapture (this, ipcam);
    }
    public function get ipcams():Array
    {
        if (mpc)
            return mpc.ipcams;
        else
            return [];
    }

    public function simulateSignalInterrupt():void
    {
        _signal.simInterrupt();
    }
    public function simulateMediaPlayInterrupt (mc:IMediaPlayClient):void
    {
        (mc as MediaPlayClient).simInterrupt (2000);
    }
    public function simulateMediaPubInterrupt (mc:IMediaPubClient):void
    {
        (mc as MediaPubClient).simInterrupt (2000);
    }

    public final function get key():String
    {
        return _key;
    }
    public final function set key(k:String):void
    {
        _key = k;
    }
    public final function get room():Room
    {
        return _room;
    }
    public final function get user():LocalUser
    {
        return _user;
    }
    public final function get userList ():Users
    {
        return _room.users;
    }
    public final function get log ():ULog
    {
        return _log;
    }
    public final function get videoId():String
    {
        return _videoId;
    }
    public final function get isANE():Boolean
    {
        return hasANE;
    }
    public final function get docBase():String
    {
        return _docBase;
    }
    public final function get mpc():MediaProxyClient
    {
        if (_mpc == null || !_mpc.connected)
            return null;
        else
            return _mpc;
    }
    public final function get hasAudioCap():Boolean
    {
        return _mpc != null && _mpc.audiocap != null;
    }

    public final function get signalServers():ServerList
    {
        return _signal_servers;
    }
    public final function get playServers():ServerList
    {
        return _play_servers;
    }
    public final function get publishServers():ServerList
    {
        return _pub_servers;
    }
    [Inline]
    public final function pluginURL (id:String):String
    {
        return _plugins[id];
    }

    public final function get mode():int
    {
        return _pub_count == 0 ? LIVE_MODE : INTERACT_MODE;
    }
    public final function get bufferTime():Number
    {
        return _bufferTime[mode];
    }
    public final function get bufferTimeMax():Number
    {
        return _bufferTimeMax[mode];
    }
    public final function get ncpDelay():int
    {
        return _ncpDelay;
    }

    public final function set signalServers(servers:ServerList):void
    {
        if (_signal_servers == null)
            _signal_servers = servers;
        else
            throw new Error ('bad call');
    }

    public final function set playServers(servers:ServerList):void
    {
        if (_play_servers == null)
            _play_servers = servers;
        else
            throw new Error ('bad call');
    }

    public final function set publishServers(servers:ServerList):void
    {
        if (_pub_servers == null)
            _pub_servers = servers;
        else
            throw new Error ('bad call');
    }
    public final function get signal ():SignalClient
    {
        return _signal;
    }
    public function get videoStreamSettings ():VideoStreamSettings
    {
        var s:H264VideoStreamSettings = new H264VideoStreamSettings;
        s.setProfileLevel(H264Profile.MAIN, H264Level.LEVEL_2_1);
        s.setKeyFrameInterval(30);
        return s;
    }

    /*
    public function simulateInterrupted(name:String, arg:String):void
    {
        var obj:Object;
        if (name in _pub_clients)
        {
            obj = _pub_clients[name];
            this.logw('模拟发布中断: ', name);
            var pubc:MediaPubClient = obj.client as MediaPubClient;
            var pubh:IMediaPubHandler = obj.handler as IMediaPubHandler;
            pubh.publishInterrupted(pubc, arg);
            return;
        }
        if (name in _play_clients)
        {
            obj = _play_clients[name];
            this.logw('模拟播放中断: ', name);
            var playc:MediaPlayClient = obj.client as MediaPlayClient;
            var playh:IMediaPlayHandler = obj.handler as IMediaPlayHandler;
            playh.mediaPlayInterrupted(playc, arg);
            playc.nc_internal::reconnect();
            return;
        }
    }
    */

    private function mediaProxyInit ():void
    {
        //logv ('尝试启动插件中...');
        _mpc = new MediaProxyClient(this);

        _mpc.addEventListener(Event.CONNECT, mpcConnected);
        _mpc.addEventListener(Event.CLOSE, mpcClosed);
        _mpc.addEventListener(IOErrorEvent.IO_ERROR, mpcIOError);
        _mpc.connect (mps_url);
        return;
    }

    private function mpcConnected (e:Event):void
    {
        if (_mpc.majorVer != 1 || _mpc.minorVer < 1)
        {
            logw ('不兼容当前运行的插件版本(', _mpc.version, ')');
            _mpc.removeEventListener (Event.CONNECT, mpcConnected);
            _mpc.removeEventListener (Event.CLOSE, mpcClosed);
            _mpc.removeEventListener (IOErrorEvent.IO_ERROR, mpcIOError);
            _mpc = null;
            stepForward ();
        }
        else
        {
            logi ('插件启动成功');
            stepForward ();
            this.dispatchEvent(new Event(PROXY_CONNECTED));
        }
    }
    private function mpcClosed (e:Event):void
    {
        this.dispatchEvent(new Event(PROXY_CLOSE));
        _mpc.removeEventListener(Event.CONNECT, mpcConnected);
        _mpc.removeEventListener(Event.CLOSE, mpcClosed);
        _mpc.removeEventListener(IOErrorEvent.IO_ERROR, mpcIOError);
        _mpc = null;
        mediaProxyInit ();
    }
    private function mpcIOError (e:Event):void
    {
        if (!_mpc.connected)
        {
            _mpc.removeEventListener(Event.CONNECT, mpcConnected);
            _mpc.removeEventListener(Event.CLOSE, mpcClosed);
            _mpc.removeEventListener(IOErrorEvent.IO_ERROR, mpcIOError);
            _mpc = null;
            //logw('插件启动失败');
            stepForward ();
        }
        else
        {
            this.dispatchEvent(new Event(PROXY_IOERROR));
            _mpc.removeEventListener(Event.CONNECT, mpcConnected);
            _mpc.removeEventListener(Event.CLOSE, mpcClosed);
            _mpc.removeEventListener(IOErrorEvent.IO_ERROR, mpcIOError);
            _mpc = null;
            mediaProxyInit ();
        }
    }
    private function syncTime ():void
    {
        stepForward ();
        return;
        if (TimeSync.synced)
        {
            stepForward ();
        }
        else
        {
            var $:Session = this;
            function setup(func:Function):void
            {
                func(Event.COMPLETE, done);
                func(IOErrorEvent.IO_ERROR, error);
            }
            function done(e:Event):void
            {
                setup(loader.removeEventListener);
                try
                {
                    var obj:Object = JSON.parse (e.target.data);
                    TimeSync.sync (obj as Array, 50, function (b:Boolean):void {
                        if (b)
                            stepForward();
                        else
                        {
                            loge ('时间同步失败');
                            _handler.sessionStartFailed ($, 'timeSync');
                        }
                    });
                }
                catch (e:Error)
                {
                    loge('时间服务器列表格式错误!');
                    _handler.sessionStartFailed ($, 'badServers');
                    return;
                }
            }
            function error(e:Event):void
            {
                setup(loader.removeEventListener);
                _handler.sessionStartFailed($, 'timeSyncServers');
            }
            var url:String = 'http://www.bukav.com/timesync.php';
            var req:URLRequest = new URLRequest (url);
            var loader:URLLoader = new URLLoader;

            setup(loader.addEventListener);
            loader.load(req);
        }
    }
    private function loadServerList ():void
    {
        var $:Session = this;
        function setup(func:Function):void
        {
            func(Event.COMPLETE, done);
            func(IOErrorEvent.IO_ERROR, error);
        }
        function done(e:Event):void
        {
            setup(loader.removeEventListener);
            try
            {
                var obj:Object = JSON.parse (e.target.data);
                var key:String, servers:ServerList;
                //_speed_test = new SpeedTest;
                //_speed_test.addEventListener(Event.COMPLETE, onSpeedTestDone);

                servers = new ServerList;
                for (key in obj.pub)
                {
                //    if (key.substr(0, 6) == "tcp://")
                //        _speed_test.add (key);
                    servers.addServer(key, obj.pub[key]);
                }
                publishServers = servers;

                servers = new ServerList;
                for (key in obj.play)
                {
                //    if (key.substr(0, 6) == "tcp://")
                //        _speed_test.add (key);
                    servers.addServer(key, obj.play[key]);
                }
                playServers = servers;

                servers = new ServerList;
                for (key in obj.signal)
                    servers.addServer(key, obj.signal[key]);
                signalServers = servers;

                _docBase = obj.document;
                _bufferTime = obj.bufferTime;
                _bufferTimeMax = obj.bufferTimeMax;

                _log.trace_level = obj.logLevel[0];
                _log.console_level = obj.logLevel[1];
                _log.log_level = obj.logLevel[2];
                _ncpDelay = obj.ncpDelay;
                _plugins = obj.plugins;
            }
            catch (e:Error)
            {
                loge('服务器列表格式错误!');
                _handler.sessionStartFailed ($, 'badServers');
                return;
            }
            stepForward();
        }
        function error(e:Event):void
        {
            setup(loader.removeEventListener);
            _handler.sessionStartFailed($, 'loadServers');
        }
        var url:String = 'http://www.tetequ.com/servers.php'
            + '?app=' + encodeURIComponent (_room.app)
            + '&org=' + encodeURIComponent (_room.org)
            + '&room=' + encodeURIComponent (_room.id)
            + '&flash=' + encodeURIComponent (Capabilities.version);
        var req:URLRequest = new URLRequest (url);
        var loader:URLLoader = new URLLoader;
        //logi ('Flash 版本: ', Capabilities.version);

        setup(loader.addEventListener);
        loader.load(req);
    }
    private function stepForward ():void
    {
        var step:uint = ++_steps; trace("step",step);
        _handler.sessionStartProgress (this, step/5.0);
        if (step == 3)
        {
            _signal.connect();
            if (_mpc)
            {
                for each (var url:String in _plugins)
                {
                    var req:URLRequest = new URLRequest(url);
                    var ldr:URLLoader = new URLLoader;
                    ldr.dataFormat = URLLoaderDataFormat.BINARY;
                    function dummy(e:Event):void { trace (e.type);};
                    ldr.addEventListener(IOErrorEvent.IO_ERROR, dummy);
                    ldr.addEventListener(SecurityErrorEvent.SECURITY_ERROR, dummy);
                    ldr.addEventListener(Event.COMPLETE, function (e:Event):void {
                        mpc.loadPlugin ((e.target as URLLoader).data);
                    });
                    ldr.load (req);
                }
            }
            /*
            try
            {
                _handler.sessionStarted(this);
            }
            catch (e:Error)
            {
                loge('错误: ' + e.getStackTrace());
            }
            */
        }
    }
    private function onSpeedTestDone(e:Event):void
    {
        var result:Object = _speed_test.result;
        for each (var o:Object in result)
        {
            logi('测速结果 ', JSON.stringify(o));
        }
        _pub_servers.updateWithSpeedTestResult(result);
        _play_servers.updateWithSpeedTestResult(result);
        _speed_test.removeEventListener(Event.COMPLETE, onSpeedTestDone);
        _speed_test = null;
    }

    public final function logd(...args):void
    {
        _log.vlog (ULog.D, args);
    }
    public final function logv(...args):void
    {
        _log.vlog (ULog.V, args);
    }
    public final function logi(...args):void
    {
        _log.vlog (ULog.I, args);
    }
    public final function logw(...args):void
    {
        _log.vlog (ULog.W, args);
    }
    public final function loge(...args):void
    {
        _log.vlog (ULog.E, args);
    }

    public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void
    {
        _ed.addEventListener (type, listener, useCapture, priority, useWeakReference);
    }

    public function dispatchEvent(event:Event):Boolean
    {
        return _ed.dispatchEvent (event);
    }

    public function hasEventListener(type:String):Boolean
    {
        return _ed.hasEventListener (type);
    }

    public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void
    {
        _ed.removeEventListener (type, listener, useCapture);
    }

    public function willTrigger(type:String):Boolean
    {
        return _ed.willTrigger(type);
    }

    [Inline]
    internal final function signalConnectDone ():void
    {
        stepForward ();
    }
    [Inline]
    internal final function signalConnectFail (reason:String):void
    {
        _handler.sessionStartFailed (this, reason);
    }
    [Inline]
    internal final function signalInterrupted (reason:String):void
    {
        _handler.sessionInterrupted (this, reason);
    }
    [Inline]
    internal final function handleLoginResult (res:uint, code:uint):void
    {
        if (res != 0)
            _handler.sessionStartFailed (this, 'login failed with error code ' + code);
    }
    [Inline]
    internal final function handleJoinResult (userCount:uint, id:uint):void
    {
        _handler.sessionStarted (this);
    }
    [Inline]
    internal final function handleAcquireToken (code:uint):void
    {
        if (code != 0)
            _handler.acquireTokenFailed (this, code);
    }
    [Inline]
    internal final function handleTokenChanged (token:User, prevToken:User):void
    {
        _tokenUser = token;
        _handler.tokenChanged (this, token, prevToken);
    }
    [Inline]
    internal final function handleUserIn (user:User):void
    {
        _handler.handleUserIn (this, user);
    }
    [Inline]
    internal final function handlerUserOut (user:User, type:uint):void
    {
        _handler.handleUserOut (this, user, type);
        var i:int = _inspectors.indexOf (user);
        if (i >= 0) _inspectors.splice (i, 1);
    }
    [Inline]
    internal final function handleUserUpdate (user:User):void
    {
        var stms:Vector.<AVStream> = user.streams;
        var i:uint, c:uint = stms ? stms.length : 0;
        for (i=0; i<c; ++i)
        {
            var avstm:AVStream = stms[i];
            if (!avstm.isOpened)
                continue;
            var mp:IMediaPlayClient = newMediaPlayClient (avstm);
            if (avstm.state == AVStream.STARTED)
                mp.connect ();
            avstm.mp = mp;
        }
        _handler.handleUserUpdate (this, user);
        var func:Function = _user_update_requests[user];
        if (func != null)
        {
            func (this, user);
            delete _user_update_requests[user];
        }
    }
    [Inline]
    internal final function handleChat (sender:User, receiver:User, time:uint, msg:String):void
    {
        _handler.handleChat (this, sender, receiver, time, msg);
    }
    [Inline]
    internal final function handleRPC (sender:User, receiver:User, func:String, args:Array):void
    {
        var f:Function;
        if (func.charAt (0) == '%')
            f = _rpc_client_internal[func];
        else
            f = _rpc_client [func];
        if (f != null)
        {
            args.unshift (sender, receiver);
            f.apply(null, args);
        }
    }
    [Inline]
    internal final function handleRemoteLogin ():void
    {
        _handler.handleRemoteLogin (this);
    }
    public final function get rpcClient ():Object
    {
        return _rpc_client;
    }
    public final function set rpcClient (c:Object):void
    {
        _rpc_client = c;
    }

    /**
     * 开始录制
     * @param videoId 录制文件名称
     */
    public final function startRecord (videoId:String):void
    {
        if (_signal != null)
            _signal.startRecord (videoId);
    }

    /**
     * 结束录制
     */
    public final function stopRecord ():void
    {
        if (_signal != null)
            _signal.stopRecord ();
    }

    public final function get recording ():Boolean
    {
        return _signal == null ? false : _signal.recording;
    }
    /**
     * 开始录制失败了
     * @param code
     */
    internal final function handleRecordStartFailed (code:uint):void
    {
        _handler.handleRecordStartFailed (this, code);
    }
    /**
     * 开始录制成功 - 所有人都可以收到该消息
     * @param videoId
     */
    internal final function handleRecordStarted (videoId:String):void
    {
        _videoId = videoId;
        for each (var o:Object in _pub_clients)
        {
            var pc:MediaPubClient = o as MediaPubClient;
            if (pc.avstm.state == AVStream.STARTED)
                pc.recordStart (videoId+'.'+pc.name+'.flv', true);
        }
        _handler.handleRecordStarted (this, videoId);
    }
    /**
     * 录制停止了
     */
    internal final function handleRecordStopped ():void
    {
        for each (var o:Object in _pub_clients)
        {
            var pc:MediaPubClient = o as MediaPubClient;
            if (pc.avstm.state == AVStream.STARTED)
                pc.recordStop ();
        }
        _handler.handleRecordStopped (this);
    }
    /* ---------------------------- 令牌相关 ---------------------------- */
    public final function get tokenUser ():User
    {
        return _tokenUser;
    }
    public final function get hasToken ():Boolean
    {
        return _tokenUser === _user;
    }
    public final function acquireToken ():void
    {
        _signal.acquireToken();
    }

    public final function sendChat (msg:String, to:User = null):void
    {
        _signal.sendChat (to, msg);
    }
    public final function sendRPC (to:User, func:String, ...args):void
    {
        _signal.sendRPCv (func, args, to);
    }
    public final function sendRPCv (func:String, args:Array, to:User = null):void
    {
        _signal.sendRPCv (func, args, to);
    }
    private final function init_rpc_client_internal ():void
    {
        _rpc_client_internal['%sendAVReq'] = onSendAVReq;
        _rpc_client_internal['%cancelAVReq'] = onCancelAVReq;
        _rpc_client_internal['%requestUserUpdate'] = onRequestUserUpdate;
        _rpc_client_internal['%inspectOn'] = onInspectOn;
        _rpc_client_internal['%inspectOff'] = onInspectOff;
        _rpc_client_internal['%simulateInterrupt'] = onSimulateInterrupt;
    }
    public final function sendAVReq (info:* = null):void
    {
        if (hasToken)
            throw new Error ('!!!!');
        var x:User = _tokenUser;
        if (x === null)
            return;
        _signal.updateUser ();
        _signal.sendRPC (x, "%sendAVReq", info);
    }
    private final function onSendAVReq (sender:User, receiver:User, info:*):void
    {
        if (hasToken)
        {
            _room.addAVReq (sender, info);
        }
    }
    public final function cancelAVReq (info:* = null):void
    {
        if (hasToken)
            throw new Error ('!!!!');
        var x:User = _tokenUser;
        if (x === null)
            return;
        _signal.updateUser ();
        _signal.sendRPC (x, "%cancelAVReq", info);
    }
    private final function onCancelAVReq (sender:User, receiver:User, info:*):void
    {
        if (hasToken)
        {
            var reqs:Vector.<AVReq> = _room.avReqs;
            var i:uint, c:uint = reqs.length;
            for (i=0; i<c; ++i) {
                var req:AVReq = reqs[i];
                if (req.equals (sender, info)) {
                    _room.delAVReq (req, sender);
                    return;
                }
            }
        }
    }
    public final function requestUserUpdate (to:User = null, callback:Function = null):void
    {
        if (to != null && callback != null)
        {
            if (!to.isNewBorn ())
            {
                callback (this, to);
                return;
            }
            _user_update_requests[to] = callback;
        }
        _signal.sendRPC (to, "%requestUserUpdate");
    }
    private final function onRequestUserUpdate (sender:User, receiver:User):void
    {
        _signal.updateUser ();
    }
    public final function inspectOn (to:User):void
    {
        _signal.sendRPC (to, '%inspectOn');
    }
    private final function onInspectOn (sender:User, receiver:User):void
    {
        if (receiver != null && _inspectors.indexOf (sender) < 0)
            _inspectors.push (sender);
    }
    public final function inspectOff (to:User):void
    {
        _signal.sendRPC (to, '%inspectOff');
    }
    private final function onInspectOff (sender:User, receiver:User):void
    {
        var i:int = _inspectors.indexOf (sender);
        if (i >= 0)
            _inspectors.splice (i, 1);
    }
    public final function get hasInspector ():Boolean
    {
        return _inspectors.length > 0;
    }
    private final function onSimulateInterrupt (sender:User, receiver:User, avid:uint, delay:uint):void
    {
        var pc:MediaPubClient = _pub_clients[avid];
        if (pc != null)
        {
            pc.simInterrupt (delay);
            return;
        }
        var mp:MediaPlayClient = _play_clients[avid];
        if (mp != null)
        {
            mp.simInterrupt (delay);
            return;
        }
        if (avid == 0)
        {
            _signal.simInterrupt (delay);
        }
    }
    public final function sendTSInfo (avid:uint, bytes:ByteArray):void
    {
        var i:uint, c:uint = _inspectors.length;
        for (i=0; i<c; ++i)
        {
            bytes.position = 0;
            _signal.sendRPC (_inspectors[i], 'handleTSInfo', avid, bytes);
        }
    }
}
}

import flash.utils.getDefinitionByName;

const mps_url:String = 'rtmp://127.0.0.1:53248/live';
const hasANE:Boolean = detectANE ();

function detectANE():Boolean
{
    var has:Boolean = false;
    return has; // FIXME: 先不使用 ANE
    try
    {
        has = getDefinitionByName("flash.external.ExtensionContext") != null;
    }
    catch (e:Error)
    {
    }
    return has;
}
