package com.e2et.net
{
import com.e2et.utils.LEByteArray;
import com.e2et.utils.Misc;

import flash.crypto.generateRandomBytes;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.TimerEvent;
import flash.system.Security;
import flash.utils.ByteArray;
import flash.utils.Timer;
import flash.utils.getTimer;

public class SpeedTest extends EventDispatcher
{
    private var _servers:Object = { };
    private var _sock:UMSocket, _server:String;
    private var _timer:Timer = new Timer (100, 0);
    private var _t1:Array, _t2:Array, _t3:Array;
    public function SpeedTest ()
    {
        _timer.addEventListener(TimerEvent.TIMER, onTimer);
    }
    public function get result():Object
    {
        return _servers;
    }
    public function add(server:String):void
    {
        if (server in _servers)
            return;
        _servers[server] = null;
        if (_sock == null)
            start (server);
    }
    private function start (server:String):void
    {
        var ar:Array = /^tcp:\/\/\[([0-9a-fA-F:])+\]:(\d+)$/.exec(server);
        if (!ar) ar = /^tcp:\/\/(.*):(\d+)$/.exec(server);
        if (!ar) throw new Error('bad tcp address');
        var host:String = ar[1], port:int = ar[2];
        Security.loadPolicyFile('xmlsocket://' + host + ':' + port);
        _sock = new UMSocket;
        _sock.reset ();
        _server = server;
        _t1 = [];
        _t2 = [];
        _t3 = [];
        setup (_sock.addEventListener);
        _sock.connect (host, port);
    }
    private function finish ():void
    {
        if (_t1.length >= 20)
        {
            var ar:Array = Misc.average_sd(_t3);
            ar[0] = Number(ar[0].toFixed(2));
            ar[1] = Number(ar[1].toFixed(2));
            ar.push (Number(Misc.sd(_t2).toFixed(2)));
            ar.push (Number(Misc.sd(_t1).toFixed(2)));
            var v:int;
            if (ar[0] < 50.0)
                v = 1;
            else if (ar[0] < 100.0)
                v = 2;
            else if (ar[0] < 150.0)
                v = 3;
            else if (ar[0] < 200.0)
                v = 4;
            else
                v = 5;
            ar.push (v);
            ar.push (_server);
            // [rtt, t3, t2, t1, L, server]
            _servers[_server] = ar;
        }
        else
            delete _servers[_server];
        setup (_sock.removeEventListener);
        _timer.reset();
        _server = null;
        _t1 = _t2 = _t3 = null;
        try { _sock.close(); } catch (e:Error) { }
        _sock = null;
        for (var server:String in _servers)
        {
            if (_servers[server])
                continue;
            start (server);
            return;
        }
        dispatchEvent (new Event(Event.COMPLETE));
    }
    private function onConnect (e:Event):void
    {
        _sock.dataHandler = handleData;
        var bytes:ByteArray = new LEByteArray, len:int = 1600;
        bytes.length = len;
        bytes.writeByte (62);
        bytes.writeUnsignedInt(len-5);
        bytes.writeBoolean(false);
        bytes.writeBytes (flash.crypto.generateRandomBytes(1024));
        _sock.writeBytes (bytes);
        _sock.flush();
    }
    private function onCloseORError (e:Event):void
    {
        finish ();
    }
    private function setup(func:Function):void
    {
        func(Event.CONNECT, onConnect);
        func(Event.CLOSE, onCloseORError);
        func(IOErrorEvent.IO_ERROR, onCloseORError);
    }
    private function handleData(sock:UMSocket, type:uint, data:ByteArray):void
    {
        if (type != 62)
            return;
        var ar:Array = _servers[_server];
        if (ar)
        {
            if (data.length == 1995)
                data.position = 1;
            var ta:int = data.readUnsignedInt()&0xffffff;
            var tb:int = data.readUnsignedInt()&0xffffff;
            var tc:int = getTimer()&0xffffff;
            _t1.push (tb - ta);
            _t2.push (tc - tb);
            _t3.push (tc - ta);
        }
        else
        {   // 第一个数据包，是用来做 PMTU 探测的
            _servers[_server] = [];
            _timer.start();
        }
    }
    // 每 100 毫秒发送 2 个 2000字节的数据包
    private function onTimer (e:Event):void
    {
        var len:int = 2000, bytes:ByteArray = new LEByteArray;
        bytes.length = len;
        bytes.writeByte (62);
        bytes.writeUnsignedInt(len-5);
        bytes.writeBoolean(false);
        bytes.writeUnsignedInt(getTimer());
        bytes.writeBytes (flash.crypto.generateRandomBytes(1024));
        _sock.writeBytes (bytes);
        _sock.flush();

        bytes = new LEByteArray;
        bytes.length = len;
        bytes.writeByte (62);
        bytes.writeUnsignedInt(len-5);
        bytes.writeBoolean(false);
        bytes.writeUnsignedInt(getTimer());
        bytes.writeBytes (flash.crypto.generateRandomBytes(1024));
        _sock.writeBytes (bytes);
        _sock.flush();
    }
}
}
