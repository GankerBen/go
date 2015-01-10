package com.e2et.net
{
import com.e2et.utils.LEByteArray;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.events.TimerEvent;
import flash.system.Security;
import flash.utils.ByteArray;
import flash.utils.Timer;
import flash.utils.getTimer;

public final dynamic class TimeSync extends EventDispatcher
{
    static private var _off:Number = new Date().time - getTimer();
    static private var _off2:Number = NaN;

    static public function get now ():Number
    {
        return getTimer () + _off;
    }
    static public function get synced ():Boolean
    {
        return !isNaN (_off2);
    }

    static public function sync (servers:Array, round:uint, callback:Function):void
    {
        _off2 = NaN;
        var ar:Object = { }, count:uint = 0;
        servers.forEach (function (e:Array, i:int, o:*):void
        {
            var k:String = e[0] + ':' + e[1];
            if (!ar[k])
            {
                var z:TimeSync = new TimeSync (round);
                z.k = k;
                z.start (e[0], e[1]);
                z.addEventListener(Event.COMPLETE, onComplete);
                z.addEventListener(Event.CLOSE, onClose);
                ar[k] = z; ++count;
            }
        });
        function onComplete (e:Event):void
        {
            var z:TimeSync = e.target as TimeSync;
            z.removeEventListener(Event.COMPLETE, onComplete);
            z.removeEventListener(Event.CLOSE, onClose);
            delete ar[z.k];
            _off = _off2;
            callback (true);
            for each (var o:* in ar)
            {
                z = o as TimeSync;
                z.finish ();
            }
        }
        function onClose (e:Event):void
        {
            var z:TimeSync = e.target as TimeSync;
            z.removeEventListener(Event.COMPLETE, onComplete);
            z.removeEventListener(Event.CLOSE, onClose);
            delete ar[z.k];
            if (callback == null)
                return;
            if (_off2 && callback != null)
            {
                callback (true);
                callback = null;
                for each (var o:* in ar)
                {
                    z = o as TimeSync;
                    z.finish ();
                }
                return;
            }
            if (--count == 0)
            {
                callback (false);
            }
        }
    }

    private var _sock:UMSocket, _count:uint;
    private var _offs:Vector.<Number> = new Vector.<Number>;
    private var _timer:Timer = new Timer (3000, 1);

    public function TimeSync (count:uint = 100)
    {
        _count = count;
        _timer.addEventListener (TimerEvent.TIMER, onTimer);
    }

    public function start (host:String, port:int):void
    {
        Security.loadPolicyFile('xmlsocket://' + host + ':' + port);
        _sock = new UMSocket;
        _sock.reset ();
        setup (_sock.addEventListener);
        _sock.connect (host, port);
    }
    private function setup(func:Function):void
    {
        func(Event.CONNECT, onConnect);
        func(Event.CLOSE, onCloseORError);
        func(IOErrorEvent.IO_ERROR, onCloseORError);
        func(SecurityErrorEvent.SECURITY_ERROR, onCloseORError);
    }
    private function onConnect (e:Event):void
    {
        _sock.dataHandler = handleData;
        send ();
    }
    private function onCloseORError (e:Event):void
    {
       finish ();
    }
    private function onTimer (e:Event):void
    {
        finish ();
    }
    public function finish ():void
    {
        if (_sock)
        {
            try { _sock.close (); } catch (e:Error) { };
            setup (_sock.removeEventListener);
            _sock = null;
            _offs = null;
            _timer.removeEventListener (TimerEvent.TIMER, onTimer);
            _timer.stop ();
            _timer = null;
            if (hasEventListener (Event.CLOSE))
                dispatchEvent (new Event (Event.CLOSE));
        }
    }
    private function handleData(sock:UMSocket, type:uint, data:ByteArray):void
    {
        _timer.reset ();
        if (type != 62 || !isNaN (_off2))
            return finish ();

        _timer.start ();
        var ta:int = data.readUnsignedInt();
        var tb:int = data.readUnsignedInt()&0xffffff;
        var sec:uint = data.readUnsignedInt ();
        var ms:uint = data.readUnsignedShort ();
        var tc:int = getTimer ();
        var off:Number = sec*1000 + ms - (ta + tc)/2;
        if (_offs.push (off) >= _count)
        {
            var i:uint, c:uint = _offs.length;
            var sum:Number = 0;
            for (i=0; i<c; ++i)
                sum += _offs[i];
            _off2 = Math.round(sum/c);
            dispatchEvent (new Event (Event.COMPLETE));
            finish ();
        }
        else
            send ();
    }
    private function send ():void
    {
        var len:int = 32, bytes:ByteArray = new LEByteArray;
        bytes.length = len;
        bytes.position = 0;
        bytes.writeByte (62);
        bytes.writeUnsignedInt(len-5);
        bytes.writeBoolean(true);
        bytes.writeUnsignedInt (60000);
        var ts:uint = getTimer ();
        bytes.writeUnsignedInt (ts);
        _sock.writeBytes (bytes);
        _sock.flush();
        _timer.start ();
    }
}
}
