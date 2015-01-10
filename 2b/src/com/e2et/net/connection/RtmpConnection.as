package com.e2et.net.connection
{
import com.e2et.net.nc_internal;

import flash.events.IOErrorEvent;
import flash.events.NetStatusEvent;
import flash.net.NetConnection;
import flash.net.ObjectEncoding;
import flash.utils.ByteArray;
import flash.utils.Endian;

internal class RtmpConnection extends NetConnection implements INetConnection
{
    private var _handler:NetConnectionHandler = null;
    public var remoteAddr:String = null;

    private function setupEventListener (func:Function):void
    {
        func(IOErrorEvent.IO_ERROR, onIOError);
        func(NetStatusEvent.NET_STATUS, onStatus);
    }
    public function RtmpConnection()
    {
        super();
        this.objectEncoding = ObjectEncoding.AMF0;
        this.client = { };
    }
    public function set netHandler (handler:NetConnectionHandler):void
    {
        _handler = handler;
    }
    public function get endian():String
    {
        return Endian.BIG_ENDIAN;
    }
    public function set endian(e:String):void
    {
    }

    public function writeBytes (bytes:ByteArray, offset:uint = 0, length:uint = 0):void
    {
        if (bytes[0] == 5)
        {
            bytes.position = 5;
            call ('Ping', null, bytes.readInt());
        }
        else if (bytes[0] == 10)
        {
            bytes.position = 5;
            call ('PingResponse', null, bytes.readInt());
        }
    }
    public function flush ():void
    {
    }
    public function dispose ():void
    {
        this.close();
        this.client = {};
    }
    public function sendPing (ts:int):void
    {
        call('Ping', null, ts);
    }
    public function sendPingResponse (ts:int):void
    {
        call('PingResponse', null, ts);
    }
    private function onStatus (e:NetStatusEvent):void
    {
        if (e.info.code == 'NetConneciton.Connection.Closed')
        {
            setupEventListener(this.removeEventListener);
            if (_handler !== null) _handler.nc_internal::onClose(this, e);
            dispose();
        }
    }
    private function onIOError (e:IOErrorEvent):void
    {
        setupEventListener(this.removeEventListener);
        if (_handler !== null) _handler.nc_internal::onError(this, e);
        dispose ();
    }
}
}
