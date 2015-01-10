package com.e2et.replay
{
import com.e2et.datalogic.AVStream;
import com.e2et.datalogic.AVStreamChangeState;
import com.e2et.datalogic.LocalUser;
import com.e2et.datalogic.Room;
import com.e2et.datalogic.RoomAction;
import com.e2et.datalogic.User;
import com.e2et.net.signal.SignalProtocol;

import flash.events.TimerEvent;
import flash.utils.ByteArray;
import flash.utils.Timer;
import flash.utils.getTimer;

public class ReplaySegment
{
    private var _videoId:String;
    private var _streams:Object = { };

    internal var $room:Room;

    // 开始时间
    internal var $startTime:Number;
    // 持续时长 (ms)
    internal var $duration:uint;
    // 动作列表
    internal var $actions:Vector.<ReplayAction> = new Vector.<ReplayAction>;

    internal var $users:Vector.<User> = new Vector.<User>;

    internal var $handler:IReplayHandler;

    internal var $:ReplaySession;

    // 回放计时器
    internal var $playStartTime:int;
    internal var $playTimer:Timer = new Timer (100);
    internal var $currAct:uint;

    internal var pmap:Object = { };

    public function ReplaySegment (videoId:String, handler:IReplayHandler, $:ReplaySession)
    {
        _videoId = videoId;
        $handler = handler;
        this.$ = $;
        $playTimer.addEventListener (TimerEvent.TIMER, onPlayTimer);
        pmap[SignalProtocol.RECORD] = replayRecord;
        pmap[SignalProtocol.UPDATE_ROOM] = replayUpdateRoom;
        pmap[SignalProtocol.UPDATE_USER] = replayUpdateUser;
        pmap[SignalProtocol.SEND_USER_ACTION] = replayUserAction;
        pmap[SignalProtocol.SEND_ROOM_ACTION] = replayRoomAction;
        pmap[SignalProtocol.USER_IN] = replayUserIn;
        pmap[SignalProtocol.USER_OUT] = replayUserOut;
    }

    protected function onPlayTimer (event:TimerEvent):void
    {
        var now:int = (getTimer () - $playStartTime);
        var cnt:uint = $actions.length;
        $handler.timeTick ($, this, now);
        for (; $currAct < cnt; ++$currAct)
        {
            var act:ReplayAction = $actions[$currAct];
            if (now < act.$timestamp)
            {   // 下一个动作的时间还没有到
                return;
            }
            var func:Function = pmap[act.$type];
            func (act);
        }
    }
    private function replayRecord (a:ReplayAction):void
    {
        var pkt:ByteArray = a.$data;
        pkt.position = 0;
        if (pkt[0] == 0)
        {   // 录制开始
            pkt.position = 1;
            var id:uint, info:String = pkt.readUTF ();
            var cnt:uint = pkt.readUnsignedInt();
            $users.length = 0;
            while (cnt--)
            {
                id = pkt.readUnsignedInt ();
                $users.push (new User (id, 0));
            }
        }
        else
        {   // 录制结束
            $playTimer.stop ();
            $handler.playEnded ($, this);
        }
    }
    private function replayUpdateRoom (a:ReplayAction):void
    {
        var pkt:ByteArray = a.$data;
        pkt.position = 0;
        $room = new Room ('', 'bukav');
        var $user:LocalUser = new LocalUser ('', '', 0x81);
        $room.localUser = $user;
        $room.init ($users, 0);
        $room.unpack (pkt);
        $handler.roomUpdate ($, this, $room);
    }
    private function replayUpdateUser (a:ReplayAction):void
    {
        var pkt:ByteArray = a.$data;
        pkt.position = 0;
        var id:uint = pkt.readUnsignedInt ();
        var user:User = $room.users.getUser (id);
        user.unpack (pkt);
        var i:uint, c:uint = user.streamCount;
        var stms:Vector.<AVStream> = user.streams;
        for (i=0; i<c; ++i)
        {
            var stm:AVStream = stms[i];
            var flvstm:FLVStream = _streams[stm.name];
            if (stm.state == AVStream.STARTED)
            {
                // TODO: 播放
            }
        }
    }
    private function replayRoomAction (a:ReplayAction):void
    {
        var pkt:ByteArray = a.$data;
        pkt.position = 0;
        var roomAct:RoomAction = $room.addRawAction (pkt);
        // TODO: 处理需要处理的 roomaction
    }
    private function replayUserAction (a:ReplayAction):void
    {
        var pkt:ByteArray = a.$data;
        pkt.position = 0;
        var id:uint = pkt.readUnsignedInt ();
        var user:User = $room.users.getUser (id);
        var act:AVStreamChangeState = user.addRawAction (pkt) as AVStreamChangeState;
        if (act != null && act.state == AVStream.STARTED)
        {
            var stm:AVStream = act.stream;
            var flvstm:FLVStream = _streams[stm.name];
            // TODO: 播放 flv stream
        }
    }
    private function replayUserIn (a:ReplayAction):void
    {
        var pkt:ByteArray = a.$data;
        pkt.position = 0;
        pkt.readUTF (); // userid
        var id:uint = pkt.readUnsignedInt ();
        var user:User = $room.users.getUser (id);
        if (user == null)
        {
            user = new User (id, 0);
            user.unpack (pkt);
            $room.userIn (user);
            $handler.userIn ($, this, user);
        }
    }
    private function replayUserOut (a:ReplayAction):void
    {
        var pkt:ByteArray = a.$data;
        pkt.position = 0;
        pkt.readUTF (); // userid
        var id:uint = pkt.readUnsignedInt ();
        var user:User = $room.users.getUser (id);
        if (user != null)
        {
            $room.userIn (user);
            $handler.userIn ($, this, user);
        }
    }

    /**
     * 开始时间
     */
    public final function get startTime ():Number
    {
        return $startTime;
    }
    /**
     * 持续时长 (ms)
     */
    public final function get duration ():uint
    {
        return $duration;
    }
    public final function get streams ():Vector.<FLVStream>
    {
        var v:Vector.<FLVStream> = new Vector.<FLVStream>;
        for each (var o:Object in _streams)
        {
            v.push (o);
        }
        return v;
    }
    public final function getStreams (vec:Vector.<FLVStream>):void
    {
        for each (var o:Object in _streams)
        {
            vec.push (o);
        }
    }

    public final function play ():void
    {
        $playStartTime = getTimer ();
        $handler.playStarting ($, this, 0);
        $handler.playStarted ($, this, 0);
        $playTimer.reset ();
        $playTimer.start ();
        $users.length = 0;
        $room = null;
        $currAct = 0;
    }
    public final function seek (time:uint):void
    {
        var now:uint = getTimer () - $playStartTime;
        $handler.beforeSeek ($, this, now);
        // 二分法找到下一个动作
        var f:int, m:int, l:int = $actions.length;
        for (f=0;;)
        {
            var a:ReplayAction = $actions[m = (f + l)>>1];
            if (a.$timestamp < time)
                f = m+1;
            else
                l = m;
        }
        $currAct = f;
        $playStartTime = $playStartTime + time - now;
        $handler.afterSeek ($, this, time);
    }
    /**
     * 增加录制下来的动作 - ReplaySession 在加载录制文件时会调用该函数，以便让每个 ReplaySegment 加载动作列表
     * @param ts
     * @param ms
     * @param type
     * @param pkt
     */
    internal final function add (ts:uint, ms:uint, type:uint, pkt:ByteArray):void
    {
        var act:ReplayAction = new ReplayAction;
        var timestamp:Number = ts*1000.0 + ms;
        var user:User, id:uint;
        switch (type)
        {
        case SignalProtocol.RECORD:
            if (pkt[0] == 0)
            {   // 开始录制包
                $startTime = timestamp;
                pkt.position = 1;
                var info:String = pkt.readUTF ();
                var cnt:uint = pkt.readUnsignedInt();
                $users.length = 0;
                while (cnt--)
                {
                    id = pkt.readUnsignedInt ();
                    $users.push (new User (id, 0));
                }
            }
            else if (pkt[0] == 1)
            {   // 结束录制包, 可以算出总长度了
                $duration = timestamp - $startTime;
                $users.length = 0;
                $room = null;
            }
            break;
        case SignalProtocol.UPDATE_ROOM:
            if ($room == null)
            {
                $room = new Room ('', 'bukav');
                var $user:LocalUser = new LocalUser ('', '', 0x81);
                $room.localUser = $user;
                $room.init ($users, 0);
                $room.unpack (pkt);
                // TODO:
            }
            else
            {
                var ver:uint = pkt.readUnsignedInt ();
                var nextActId:uint = pkt.readUnsignedInt ();
                if ($room.nextActionId == nextActId)
                    return;
                pkt.position = 0;
                $room.unpack (pkt);
            }
            break;
        case SignalProtocol.SEND_ROOM_ACTION:
            $room.addRawAction (pkt);
            break;
        case SignalProtocol.UPDATE_USER:
            id = pkt.readUnsignedInt ();
            user = $room.users.getUser (id);
            if (user == null)
                return;
            user.unpack (pkt);
            var i:uint, c:uint = user.streamCount;
            var stms:Vector.<AVStream> = user.streams;
            for (i=0; i<c; ++i)
            {
                var stm:AVStream = stms[i];
                if (stm.state == AVStream.STARTED)
                    addStream (stm);
            }
            break;
        case SignalProtocol.SEND_USER_ACTION:
            id = pkt.readUnsignedInt ();
            user = $room.users.getUser (id);
            if (user == null || user.isNewBorn ())
                return;
            var a:AVStreamChangeState = user.addRawAction (pkt) as AVStreamChangeState;
            if (a != null && a.state == AVStream.STARTED)
                addStream (a.stream);
            break;
        case SignalProtocol.USER_IN:
            pkt.readUTF (); // userid
            id = pkt.readUnsignedInt ();
            user = $room.users.getUser (id);
            if (user == null)
            {
                user = new User (id, 0);
                user.unpack (pkt);
                $room.userIn (user);
            }
            break;
        case SignalProtocol.USER_OUT:
            pkt.readUTF (); // userid
            id = pkt.readUnsignedInt ();
            user = $room.users.getUser (id);
            if (user != null)
            {
                $room.userOut (user);
            }
            break;
        }

        act.$timestamp = timestamp - $startTime;
        act.$type = type;
        act.$data = pkt;
        $actions.push (act);
    }
    private function addStream (stm:AVStream):void
    {
        var name:String = stm.name;
        if (name in _streams)
            return;
        var flvstm:FLVStream = new FLVStream (_videoId + '.' + name + '.flv');
        _streams[name] = flvstm;
        // TODO:
    }
}
}
