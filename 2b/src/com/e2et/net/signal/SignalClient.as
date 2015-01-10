package com.e2et.net.signal
{
import com.e2et.Session;
import com.e2et.datalogic.*;
import com.e2et.datalogic.utils.readObject;
import com.e2et.net.NetClient;
import com.e2et.net.ServerList;
import com.e2et.net.nc_internal;
import com.e2et.net.ncp_internal;
import com.e2et.net.connection.INetConnection;
import com.e2et.net.media.audio.IAudioCapture;
import com.e2et.net.media.player.IMediaPlayClient;
import com.e2et.net.media.publisher.IMediaPubClient;
import com.e2et.net.media.video.IVideoCapture;

import flash.events.Event;
import flash.events.TimerEvent;
import flash.net.Socket;
import flash.utils.ByteArray;
import flash.utils.Dictionary;
import flash.utils.Endian;
import flash.utils.Timer;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

use namespace nc_internal;
use namespace ncp_internal;

/**
 * 信令客户端 - 支持断线自动重连
 * @author Bin Tian
 */
public class SignalClient extends NetClient implements IMetaActionHandler
{
    private var _handler:ISignalHandler;

    private var _room:Room;
    private var _user:LocalUser;
    private var _tokenUser:User;
    private var _users:Users;

    private var _updatedForAll:Boolean = true;
    private var _updateNow:uint = 0;

    private var _roomUpdateTimer:Timer = new Timer (30000, 1);
    private var _roomActionCount:uint = 0;
    private var _recording:Boolean = false;

    private var _play_streams:Vector.<AVStream> = new Vector.<AVStream>;

    // 连接登录超时检测
    private var _connectTimer:Timer = new Timer (5000, 1);

    private var cmap:Object =  { };
    private var amap:Dictionary = new Dictionary;

    public function SignalClient ($:Session, room:Room, handler:ISignalHandler)
    {
        super ($);
        _room = room;
        _user = room.localUser;
        _users = room.users;
        _handler = handler;

        _user.addHandler (this);
        _room.addHandler (this);

        init_cmap ();
        init_amap ();

        _roomUpdateTimer.addEventListener (TimerEvent.TIMER, onRoomUpdate);
        _connectTimer.addEventListener (TimerEvent.TIMER, onConnectTimeout);
    }

    override protected function get logTag ():String
    {
        return "信令: ";
    }

    public final function startRecord (videoId:String):void
    {
        if (_recording)
            return;
        sendPkt (RecordPacket (true, videoId));
    }
    public final function stopRecord ():void
    {
        if (!_recording)
            return;
        sendPkt (RecordPacket (false));
    }
    public final function get recording ():Boolean
    {
        return _recording;
    }
    /* ---------------------------- 业务逻辑 ----------------------------*/
    private function login ():void
    {
        sendPkt (loginPacket (_user));
        $.logd (logTag, '发送登录指令');
        _connectTimer.reset ();
        _connectTimer.start ();
    }
    public function logout ():void
    {
        var i:uint, c:uint = _user.streamCount;
        var streams:Vector.<AVStream> = _user.streams;
        while (c-- > 0)
            streams[i].close ();
        sendPkt (dummyPacket (SignalProtocol.LOGOUT));
        close ();
        _room.delHandler (this);
        var users:Users = _users;
        c = users.length;
        for (i=0; i<c; ++i)
            users[i].delHandler (this);
        c = _play_streams.length;
        for (; c-->0; )
        {
            var stm:AVStream = _play_streams[c];
            if (stm.mp != null)
                stm.mp.close ();
        }
        _play_streams.length = 0;
        _users = null;
        _room = null;
    }
    private function joinRoom ():void
    {
        _connectTimer.reset ();
        _connectTimer.start ();
        sendPkt (joinRoomPacket (_room, _user));
    }
    [Inline]
    public final function updateRoom ():void
    {
        _roomActionCount = 0;
        if (_tokenUser === _user)
            sendPkt (updateRoomPacket (_room));
    }
    [Inline]
    private final function sendRoomAction (act:RoomAction):void
    {
        sendPkt (actionPacket (SignalProtocol.SEND_ROOM_ACTION, act, _recording));
    }
    [Inline]
    public final function updateUser ():void
    {
        if (_updatedForAll)
            return; // 已给房间内所有用户发送过用户状态了
        sendPkt (updateUserPacket (_user, _recording&&_user.dirty));
        _user.undirty ();
        _updatedForAll = true;
    }
    [Inline]
    private final function sendUserAction (act:UserAction):void
    {
        sendPkt (actionPacket (SignalProtocol.SEND_USER_ACTION, act, _recording));
    }
    [Inline]
    public final function acquireToken ():void
    {
        if (_user.level & 0x80)
        {
            updateUser ();
            sendPkt (dummyPacket (SignalProtocol.ACQUIRE_TOKEN));
        }
    }
    [Inline]
    public final function sendChat (to:User, msg:String):void
    {
        updateUser ();
        sendPkt (chatPacket(to ? to.sid : 0, msg));
    }
    public final function sendRPC (to:User, func:String, ...args):void
    {
        updateUser ();
        sendPkt (RPCPacket (to ? to.sid : 0, func, args));
    }
    [Inline]
    public final function sendRPCv (func:String, args:Array, to:User = null):void
    {
        updateUser ();
        sendPkt (RPCPacket (to ? to.sid : 0, func, args));
    }

    private function init_cmap ():void
    {
        cmap [SignalProtocol.LOGIN_RESULT] = handleLoginResult;
        cmap [SignalProtocol.JOIN_ROOM_RESULT] = handleJoinResult;
        cmap [SignalProtocol.UPDATE_USER] = handleUpdateUser;
        cmap [SignalProtocol.SEND_ROOM_ACTION] = handleRoomAction;
        cmap [SignalProtocol.SEND_USER_ACTION] = handleUserAction;
        cmap [SignalProtocol.USER_IN] = handleUserIn;
        cmap [SignalProtocol.USER_OUT] = handleUserOut;
        cmap [SignalProtocol.CHAT] = handleChat;
        cmap [SignalProtocol.RPC] = handleRPC;
        cmap [SignalProtocol.ACQUIRE_TOKEN] = handleAcquireToken;
        cmap [SignalProtocol.TOKEN_CHANGED] = handleTokenChanged;
        cmap [SignalProtocol.PING] = handlePing;
        cmap [SignalProtocol.REPEAT] = handleRemoteLogin;
        cmap [SignalProtocol.RECORD_RESULT] = handleRecordResult;
        cmap [SignalProtocol.RECORD_INFO] = handleRecordInfo;
    }
    private function handleLoginResult (pkt:ByteArray):void
    {
        var ok:int = pkt.readByte ();
        var code:uint = pkt.readUnsignedInt ();
        _handler.handleLoginResult (this, ok, code);
        _connectTimer.stop ();
        if (ok == 0)
        {
            _user.sid = code;
            joinRoom ();
        }
    }
    private function handleJoinResult (pkt:ByteArray):void
    {
        // 非空字符串表示房间里面正在录制
        var videoId:String = pkt.readUTF ();
        _recording = videoId != '';
        // 读取用户列表
        _connectTimer.stop ();
        var users:Vector.<User> = new Vector.<User>;
        var userCount:uint = pkt.readUnsignedInt ();
        var id:uint, sid:uint, len:uint, user:User;
        while (userCount--) {
            id = pkt.readUnsignedInt ();
            sid = pkt.readUnsignedInt ();
            users.push (user = new User (id, sid));
            user.addHandler (this);
        }
        // 房间初始化
        id = pkt.readUnsignedInt ();
        _room.init (users, id);
        // 读取房间状态
        _room.handlerOff ();
        len = pkt.readUnsignedInt ();
        if (len > 0)
        {    // 房间状态解封装会用到用户列表，所以要在这之前调用 _room.init ()
            _room.unpack (pkt);
        }
        // 读取房间动作
        var acount:uint = pkt.readUnsignedShort ();
        while (acount--)
        {
            pkt.readShort ();
            _room.addRawAction (pkt);
        }
        _room.handlerOn ();
        _handler.handleJoinResult (this, userCount, id);
        startClientTimer ();
        if (_recording) // 正在录制
            _handler.handleRecordStarted (this, videoId);
    }
    private function handleRecordResult (pkt:ByteArray):void
    {
        var code:uint = pkt.readByte ();
        if (code != 0)
        {
            // 1 无权限(非令牌用户), 2 录制中，重复录制
            _handler.handleRecordStartFailed (this, code);
        }
    }
    private function handleRecordInfo (pkt:ByteArray):void
    {
        var code:uint = pkt.readByte ();
        if (code == 0)
        {
            var record:Boolean = pkt.readBoolean ();
            var videoId:String = pkt.readUTF ();
            if (record)
            {
                _recording = true;
                _updatedForAll = false;
                updateRoom ();
                _handler.handleRecordStarted (this, videoId);
            }
            else
            {
                _recording = false;
                _handler.handleRecordStopped (this);
            }
        }
    }
    private function handleUpdateUser (pkt:ByteArray):void
    {
        _handler.handleUserUpdate (this, parseUser (pkt));
    }
    private function handleRoomAction (pkt:ByteArray):void
    {
        _room.addRawAction (pkt);
    }
    private function handleUserAction (pkt:ByteArray):void
    {
        var id:uint = pkt.readUnsignedInt ();
        var user:User = _users.getUser(id);
        if (user == null)
            throw new Error ('bad user id');
        if (user.isNewBorn ())
            throw new Error ('bad user sequence');
        user.addRawAction (pkt);
    }
    private final function handleUserIn (pkt:ByteArray):void
    {
        var id:uint = pkt.readUnsignedInt ();
        var user:User = _users.getUser(id);
        if (user != null)
            throw new Error ("bad user id");
        user = new User (id, 0);
        user.addHandler (this);
        _room.userIn (user.unpack (pkt));
        _handler.handleUserIn (this, user);
        _updatedForAll = false; // 新进来的用户还未收到用户状态
    }
    private final function handleUserOut (pkt:ByteArray):void
    {
        var type:uint = pkt.readByte ();
        var user:User = _room.userOut (parseUser (pkt));
        user.delHandler (this);
        if ($.tokenUser == user)
            _handler.handleTokenChanged (this, _tokenUser = null, $.tokenUser);
        _handler.handleUserOut (this, user, type);
        var stms:Vector.<AVStream> = user.streams;
        if (stms != null && stms.length > 0)
        {
            var i:uint, c:uint = stms.length;
            for (i=0; i<c; ++i)
            {
                var stm:AVStream = stms[i];
                if (!stm.isOpened)
                    continue;
                if (stm.mp != null)
                {
                    stm.mp.close ();
                    stm.mp = null;
                }
                var k:int = _play_streams.indexOf (stm);
                if (k >= 0) _play_streams.splice (k, 1);
            }
        }
    }
    private final function handleChat (pkt:ByteArray):void
    {
        var s:uint = pkt.readUnsignedInt ();
        var r:uint = pkt.readUnsignedInt ();
        var su:User = _users.getUser (s);
        var ru:User = _users.getUser (r);
        if (su == null)
            throw new Error ('bad user id');
        var time:uint = pkt.readUnsignedInt ();
        var msg:String = pkt.readUTF ();
        _handler.handleChat(this, su, ru, time, msg);
    }
    private final function handleRPC (pkt:ByteArray):void
    {
        var s:uint = pkt.readUnsignedInt ();
        var r:uint = pkt.readUnsignedInt ();
        var su:User = _users.getUser (s);
        var ru:User = _users.getUser (r);
        if (su == null)
            throw new Error ('bad user id');
        if (ru != null && ru !== _user)
            return;

        var func:String = pkt.readUTF();
        var i:int, cnt:int = pkt.readShort ();
        var args:Array = [];
        for (i=0; i<cnt; ++i)
        {
            args.push (readObject(pkt));
        }
        _handler.handleRPC (this, su, ru, func, args);
    }
    private final function handleAcquireToken (pkt:ByteArray):void
    {
        _handler.handleAcquireToken (this, pkt.readByte ());
    }
    private final function handleTokenChanged (pkt:ByteArray):void
    {
        var prevToken:User = _tokenUser;
        // 新的 TokenUser 是谁？
        var id:uint = pkt.readUnsignedInt ();
        var i:uint, c:uint, len:uint;
        _tokenUser = _users.getUser (id);
        var newBorn:Boolean = (_tokenUser.isNewBorn ());

        // 有必要的话，读取 TokenUser 的状态
        len = pkt.readShort ();
        if (newBorn)
            _tokenUser.unpack (pkt);
        else
            pkt.position += len;

        // 有必要的话，读取 TokenUser 的动作
        if (newBorn) _tokenUser.handlerOff ();
        c = pkt.readShort ();
        for (i=0; i<c; ++i)
        {
            len = pkt.readShort ();
            if (newBorn)
                _tokenUser.addRawAction (pkt);
            else
                pkt.position += len;
        }
        if (newBorn)
        {
            _tokenUser.handlerOn ();
            _handler.handleUserUpdate (this, _tokenUser);
        }

        // 有必要的话，读取房间状态和房间动作
        var hasStat:Boolean = pkt.readBoolean ();
        _handler.handleTokenChanged (this, _tokenUser, prevToken);
        if (prevToken === _user && hasStat)
        {
            len = pkt.readInt ();
            _room.unpack (pkt);
            _room.handlerOff ();
            if (pkt.position < pkt.length)
            {
                c = pkt.readShort ();
                for (i=0; i<c; ++i)
                {
                    pkt.readShort ();
                    _room.addRawAction (pkt);
                }
            }
            _room.handlerOn ();
        }
        if (_tokenUser === _user)
        {   // 我获得令牌了，更新一下房间状态吧
            updateRoom ();
        }
    }
    private final function handlePing (pkt:ByteArray):void
    {
        pkt.position = 0;
        pkt.writeByte (SignalProtocol.PONG);
        sendPkt (pkt);
    }
    private final function sendPkt (pkt:ByteArray):void
    {
        if (_nc == null)
        {
            trace ('连接中断了，无法发送数据');
            return;
        }
		
		if(pkt[0]!=0 && pkt[0] != 251 && pkt[0] != 252 )
			$.logd ("发送数据包，type:" + pkt[0]);
        _nc.writeBytes(pkt);
        _nc.flush();
    }

    override protected function get servers ():ServerList
    {
        return $.signalServers;
    }
    /* ---------------------------- 网络连接 ---------------------------- */
    private function reconnect (delay:int = 2000):void
    {
        if (_nc != null)
        {
            _nc.dispose();
            _nc = null;
        }
        close ();
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
    public function simInterrupt (delay:uint = 3000):void
    {
        $.logd (logTag, '模拟信令中断, ', delay, '毫秒后重连');
        signalInterrupted ('simulate-interrupt', delay);
    }
    public function queryClose ():Boolean
    {
        if (_nc == null)
            return true;
        if (_nc is Socket)
        {
            if ((_nc as Socket).bytesPending)
                return false;
        }
        return true;
    }
    public function get closed ():Boolean
    {
        return _nc == null;
    }
    public function dispose ():void
    {
        logout ();
        _handler = null;
    }
    /* ---------------------------- INetConnectionHandler ----------------------------*/
    nc_internal override function onClose (nc:INetConnection, e:Event):void
    {
        $.signalServers.decPriority(nc.uri);
        if (_connectTimer.running)
            signalConnectFail ("close");
        else
            signalInterrupted ("close");
    }
    nc_internal override function onError (nc:INetConnection, e:Event):void
    {
        $.signalServers.decPriority(nc.uri);
        if (_connectTimer.running)
            signalConnectFail ("ioerror");
        else
            signalInterrupted ("ioerror");
    }
    nc_internal override function handlePacket (nc:INetConnection, type:uint, pkt:ByteArray):void
    {
		if(type!=0 && type != 251 && type != 252 )
			$.logd( "收到数据包,type:" + type );
        if (pkt == null)
        {
            if (_updateNow)
                updateUser ();
            return;
        }
        var func:Function = cmap[type];
        if (func != null)
            func (pkt);
    }
    [Inine]
    private final function handleRemoteLogin (pkt:ByteArray):void
    {
        $.logi (logTag, "在别处登录了");
        _handler.handleRemoteLogin(this);
        close ();
    }

    private function onConnectTimeout (e:Event):void
    {
        signalConnectFail ("timeout");
    }
    private function signalConnectDone ():void
    {
        _handler.signalConnectDone (this);

        _nc.netHandler = this;
        _nc.endian = Endian.LITTLE_ENDIAN;

        login ();
    }
    private function signalConnectFail (reason:String):void
    {
        if (_nc != null)
            $.loge (logTag, '连接或登录服务器失败: ', reason, " ", _nc.uri);
        else
            $.loge (logTag, '连接或登录服务器失败: ', reason);
        _handler.signalConnectFail (this, reason);
        close ();
        _connectTimer.stop ();
    }
    private function signalInterrupted (reason:String, delay:uint = 2000):void
    {
        $.loge (logTag, "连接中断: ", reason, " ", _nc.uri);
        _handler.signalInterrupted (this, reason);
        reconnect (delay);
    }
    ncp_internal override function onConnectDone (nc:INetConnection, count:uint):void
    {
        super.ncp_internal::onConnectDone (nc, count);
        signalConnectDone ();
    }
    ncp_internal override function onConnectFail ():void
    {
        super.ncp_internal::onConnectFail ();
        signalConnectFail ("connect");
    }
    nc_internal override function handleTimer (seq:uint):void
    {
        if (seq % 10 == 1) // ping 心跳
            sendPkt (dummyPacket (SignalProtocol.PING));
    }

    private function onRoomUpdate (e:Event):void
    {
        if (_nc != null)
            updateRoom ();
    }
    public function handleMetaAction(a:MetaAction, isLocal:Boolean):void
    {
        var func:Function = amap[a['constructor']];
        if (func != null)
            func (a, isLocal);
        if (!isLocal)
            return;

        var ua:UserAction = a as UserAction;
        if (ua != null)
        {
            if (ua.user !== _user)
            {
                throw new Error ('非当前用户对象上不能做任何操作');
                return;
            }
            sendUserAction (ua);
            if (!_updatedForAll) // 有用户未收到我的用户状态
                queueAPC (updateUser);
            return;
        }
        var ra:RoomAction = a as RoomAction;
        if (ra != null)
        {
            if (_tokenUser !== _user)
            {
                throw new Error ('未执有令牌，不能在房间对象上做任何操作');
                return;
            }
            _roomUpdateTimer.reset ();
            if (!(a is DocLineAddPoint))
            {
                ++_roomActionCount;
                _roomUpdateTimer.start ();
            }
            sendRoomAction (a as RoomAction);
            if (a is DocLineEnd || _roomActionCount >= 30)
            {
                _roomUpdateTimer.reset ();
                updateRoom ();
            }
            return;
        }
        throw new Error ('未知动作');
    }
    private function init_amap ():void
    {
        amap[RoomAddDelAVItem] = handleAddDelAVItem;
        amap[RoomAddDelAVReq] = handleAddDelAVReq;
        amap[AVStreamOpen] = handleAVStreamOpen;
        amap[AVStreamClose] = handleAVStreamClose;
        amap[AVStreamChangeState] = handleAVStreamChangeState;
        amap[AVStreamToggleAudio] = handleAVStreamToggleAudio;
        amap[AVStreamToggleVideo] = handleAVStreamToggleVideo;
    }
    private function handleAddDelAVItem (a:RoomAddDelAVItem, isLocal:Boolean):void
    {
        var item:AVItem = a.item;
        if (item != null && item.user == _user)
        {
            if (a.add)
                ++_updateNow;
            else
                --_updateNow;
        }
    }
    private function handleAddDelAVReq (a:RoomAddDelAVReq, isLocal:Boolean):void
    {
        var req:AVReq = a.avReq;
        if (req != null && req.user == _user)
        {
            if (a.add)
                ++_updateNow;
            else
                --_updateNow;
        }
    }
    private function handleAVStreamOpen (a:AVStreamOpen, isLocal:Boolean):void
    {
        var avstm:AVStream = a.stream;
        var pc:IMediaPubClient, mp:IMediaPlayClient;

        if (isLocal)
        {
            ++_updateNow;
            pc = $.newMediaPubClient (avstm);
            avstm.pc = pc;
            pc.attachAudio (avstm.audioCap);
            pc.attachVideo (avstm.videoCap);
            pc.connect ();
        }
        else
        {
            avstm.mp = (mp = $.newMediaPlayClient (avstm));
        }
    }
    private function handleAVStreamClose (a:AVStreamClose, isLocal:Boolean):void
    {
        var avstm:AVStream = a.stream;
        if (isLocal)
        {
            --_updateNow;
            avstm.pc.close ();
            queueAPC (function ():void { avstm.pc = null; });
        }
        else
        {
            var i:int = _play_streams.indexOf (avstm);
            if (i >= 0)
                _play_streams.splice (i, 1);
            avstm.mp.close ();
            queueAPC (function ():void { avstm.mp = null; });
        }
    }
    private function handleAVStreamChangeState (a:AVStreamChangeState, isLocal:Boolean):void
    {
        var avstm:AVStream = a.stream;
        if (isLocal)
        {
            var pc:IMediaPubClient = avstm.pc;
            switch (a.state)
            {
            case AVStream.STARTED:
                pc.audioOn = avstm.audioOn;
                pc.videoOn = avstm.videoOn;
                break;
            case AVStream.BROKEN:
                var acap:IAudioCapture = pc.attachAudio (null, false);
                var vcap:IVideoCapture = pc.attachVideo (null, false);
                pc.close ();
                pc.attachAudio (acap);
                pc.attachVideo (vcap);
                pc.connect ();
                break;
            case AVStream.FAILED:
                pc.close ();
            }
        }
        else
        {
            switch (a.state)
            {
            case AVStream.STARTED:
                avstm.mp.connect ();
                if (_play_streams.indexOf (avstm) < 0)
                    _play_streams.push (avstm);
                break;
            case AVStream.FAILED:
            case AVStream.BROKEN:
                var i:int = _play_streams.indexOf (avstm);
                if (i >= 0)
                    _play_streams.splice (i, 1);
                avstm.mp.close ();
                break;
            }
        }
    }
    private function handleAVStreamToggleAudio (a:AVStreamToggleAudio, isLocal:Boolean):void
    {
        var avstm:AVStream = a.stream;
        if (isLocal && avstm.user == _user)
        {
            var pc:IMediaPubClient = avstm.pc;
            pc.audioOn = avstm.audioOn;
        }
    }
    private function handleAVStreamToggleVideo (a:AVStreamToggleVideo, isLocal:Boolean):void
    {
        var avstm:AVStream = a.stream;
        if (isLocal && avstm.user == _user)
        {
            var pc:IMediaPubClient = avstm.pc;
            pc.videoOn = avstm.videoOn;
        }
    }
    private final function parseUser (raw:ByteArray):User
    {
        var id:uint = raw.readUnsignedInt ();
        var user:User = _users.getUser (id);
        if (user == null)
            throw new Error ("bad user id");
        if (!user.isNewBorn ())
            return user;
        else
            return user.unpack (raw);
    }
}
}

import com.e2et.datalogic.MetaAction;
import com.e2et.datalogic.Room;
import com.e2et.datalogic.User;
import com.e2et.datalogic.utils.writeObject;
import com.e2et.net.signal.SignalProtocol;
import com.e2et.utils.LEByteArray;

import flash.utils.ByteArray;

[Inline]
function dummyPacket (type:uint):ByteArray
{
    var o:ByteArray = new LEByteArray;
    o.writeByte (type);
    o.writeInt (0);
    return o;
}

[Inline]
function loginPacket (user:User):ByteArray
{
    var o:ByteArray = new LEByteArray;

    o.writeByte (11);
    o.writeByte (0);
    o.writeUnsignedInt(0);

    o.writeUTF(user.userid);
    o.writeUTF(user.name);

    o.position = 2;
    o.writeUnsignedInt (o.length - 6);
    return o;
}

[Inline]
function joinRoomPacket (room:Room, user:User):ByteArray
{
    var o:ByteArray = new LEByteArray;

    o.writeByte (SignalProtocol.JOIN_ROOM);
    o.writeUnsignedInt(0);

    o.writeUTF (room.id);
    user.pack (o);

    o.position = 1;
    o.writeUnsignedInt (o.length - 5);
    return o;
}

[Inline]
function actionPacket (type:uint, act:MetaAction, record:Boolean):ByteArray
{
    var bytes:ByteArray = new LEByteArray;
    bytes.writeByte (type);
    bytes.writeUnsignedInt (0);
    bytes.writeBoolean (record);
    act.packHead (bytes);
    act.packBody (bytes);
    bytes.position = 1;
    bytes.writeUnsignedInt (bytes.length - 5);
    return bytes;
}

[Inline]
function updateRoomPacket (room:Room):ByteArray
{
    var bytes:ByteArray = new LEByteArray;
    bytes.writeByte (SignalProtocol.UPDATE_ROOM);
    bytes.writeUnsignedInt (0);
    room.pack (bytes);
    bytes.position = 1;
    bytes.writeUnsignedInt (bytes.length - 5);
    return bytes;
}

[Inline]
function updateUserPacket (user:User, record:Boolean):ByteArray
{
    var bytes:ByteArray = new LEByteArray;
    bytes.writeByte (SignalProtocol.UPDATE_USER);
    bytes.writeUnsignedInt (0);
    bytes.writeBoolean (record);
    user.pack (bytes);
    bytes.position = 1;
    bytes.writeUnsignedInt (bytes.length - 5);
    return bytes;
}

[Inline]
function chatPacket (to:uint, msg:String):ByteArray
{
    var bytes:ByteArray = new LEByteArray;
    bytes.writeByte (SignalProtocol.CHAT);
    bytes.writeUnsignedInt (0);
    bytes.writeUnsignedInt (to);
    bytes.writeUTF (msg);

    bytes.position = 1;
    bytes.writeUnsignedInt (bytes.length - 5);
    return bytes;
}

[Inline]
function RPCPacket (to:uint, func:String, args:Array):ByteArray
{
    var bytes:ByteArray = new LEByteArray;
    bytes.writeByte (SignalProtocol.RPC);
    bytes.writeUnsignedInt (0);

    bytes.writeUnsignedInt (to);

    bytes.writeUTF(func);
    var i:int, c:int = args.length;
    bytes.writeShort (c);
    for (i=0; i<c; ++i)
        writeObject (bytes, args[i]);

    bytes.position = 1;
    bytes.writeUnsignedInt (bytes.length - 5);
    return bytes;
}

[Inline]
function RecordPacket (record:Boolean, videoId:String = ''):ByteArray
{
    var pkt:ByteArray = new LEByteArray;

    pkt.writeByte (SignalProtocol.RECORD);
    pkt.writeUnsignedInt (0);
    pkt.writeBoolean (record);
    pkt.writeUTF (videoId);
    pkt.position = 1;
    pkt.writeUnsignedInt (pkt.length - 5);
    return pkt;
}
