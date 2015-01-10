package com.e2et.net.connection
{
import com.e2et.net.nc_internal;
import com.e2et.utils.LEByteArray;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.TimerEvent;
import flash.utils.ByteArray;
import flash.utils.Timer;

use namespace nc_internal;

public class HttpConnection extends EventDispatcher implements INetConnection
{
    private var _host:String;
    private var _port:int;
    private var _path:String;

    private var _hc0:HttpSocket, _hc1:HttpSocket;
    private var _uri:String;
    private var _sid:uint, _seq:uint;
    private var _handler:NetConnectionHandler = null;

    private var _bytes:ByteArray = new LEByteArray;
    private var _timer:Timer = new Timer (100, 100);

    public function HttpConnection (server:String)
    {
        _uri = server;
        var ar:Array = /^http:\/\/([0-9\.]+):(\d+)(\/.*)/.exec (server);
        if (!ar) ar = /^http:\/\/([0-9\.]+)(\/.*)/.exec (server);
        if (!ar) throw new Error ('bad http address');
        if (ar[3])
            _port = parseInt (ar[2]), _path = ar[3];
        else
            _port = 80, _path = ar[2];
        _host = ar[1];

        _hc0 = new HttpSocket (_host, _port, _path, procData);
        var bytes:ByteArray = new ByteArray;
        bytes.length = 5;
        _hc0.setData (_sid = 0, _seq = 1, bytes);
        _hc0.addEventListener (IOErrorEvent.IO_ERROR, onIOError);
        _timer.addEventListener (TimerEvent.TIMER, onTimer);
    }

    /* ~~~~~~~~~~~~~~~~~~~~~~~~~~~ INetConnection ~~~~~~~~~~~~~~~~~~~~~~~~~~~ */
    public function dispose():void
    {
        if (_hc0 != null)
        {
            _hc0.close ();
            _hc0.removeEventListener (IOErrorEvent.IO_ERROR, onIOError);
            _hc0 = null;
        }
        if (_timer != null)
        {
            _timer.removeEventListener (TimerEvent.TIMER, onTimer);
            _timer = null;
        }
    }

    public function get endian ():String
    {
        return null;
    }

    public final function set endian(e:String):void
    {
    }

    public function flush ():void
    {
    }

    public final function set netHandler(handler:NetConnectionHandler):void
    {
        _handler = handler;
    }

    public function sendPing(ts:int):void
    {
    }

    public function sendPingResponse(ts:int):void
    {
    }

    public final function get uri():String
    {
        return _uri;
    }

    public function writeBytes(bytes:ByteArray, offset:uint=0, length:uint=0):void
    {
        if (bytes[offset] == 62)
        { // HTTP 连接上不支持测速包，需要简单处理下
            var pkt:ByteArray = new ByteArray;
            bytes.position = offset + 1;
            var len:uint = bytes.readUnsignedInt();
            pkt.writeBytes(bytes, offset + 5, len);
            if (_handler != null)
                _handler.handlePacket(this, 62, pkt);
            if (len == bytes.length - 5 - offset)
                return;
            offset += 5 + len;
            if (length != 0)
                length -= 5 + len;
        }
        if (_hc1 == null && _bytes.length == 0)
        {
            _timer.reset ();
            _timer.start ();
        }
        _bytes.writeBytes (bytes, offset, length);
    }
    private function onTimer (e:Event):void
    {
        if (_hc1 == null)
        {
            _hc1 = new HttpSocket (_host, _port, _path);
            _hc1.setData (_sid, ++_seq, _bytes);
            _hc1.addEventListener (Event.OPEN, onOpen);
            _hc1.addEventListener (IOErrorEvent.IO_ERROR, onHC1Error);
            _bytes = new LEByteArray;
        }
        else
        {
            if (_timer.currentCount == _timer.repeatCount)
            {
                var ev:IOErrorEvent = new IOErrorEvent (IOErrorEvent.IO_ERROR, false, false, 'send-timeout', 3);
                if (this.hasEventListener (IOErrorEvent.IO_ERROR))
                    this.dispatchEvent (ev);
                if (_handler != null)
                    _handler.nc_internal::onError (this, ev);
            }
        }
    }

    private function onOpen (e:Event):void
    {
        _timer.reset ();
        if (_bytes.length == 0)
        {
            queueAPC (function (hc:HttpSocket):void {
                hc.close ();
            }, [_hc1]);
            _hc1.removeEventListener (Event.OPEN, onOpen);
            _hc1.removeEventListener (IOErrorEvent.IO_ERROR, onHC1Error);
            _hc1 = null;
        }
        else
        {
            _hc1.setData(_sid, ++_seq, _bytes);
            _hc1.retry ();
            _timer.start ();
        }
    }
    private function onHC1Error (e:Event):void
    {
        _hc1.retry ();
    }

    public function close ():void
    {
    }

    private function onIOError (e:Event):void
    {
        if (this.hasEventListener (IOErrorEvent.IO_ERROR))
            this.dispatchEvent (e.clone ());
        if (_handler != null)
            _handler.nc_internal::onError (this, e);
    }
    private function procData (o:*, type:uint, body:ByteArray):void
    {
        if (type == 0)
        {
            _sid = body.readUnsignedInt ();
            if (this.hasEventListener (Event.CONNECT))
                this.dispatchEvent (new Event (Event.CONNECT));
        }
        else if (_handler != null)
            _handler.nc_internal::handlePacket (this, type, body);
    }
}
}
