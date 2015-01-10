package com.e2et.net.connection
{
import com.e2et.net.UMSocket;
import com.e2et.net.nc_internal;

import flash.events.Event;
import flash.events.IOErrorEvent;

internal class TcpConnection extends UMSocket implements INetConnection
{
    private var _handler:NetConnectionHandler = null;
    private var _server:String;
    private var _flushing:uint = 0;

    public function TcpConnection ()
    {
        super ();
        setupEventListener (this.addEventListener);
    }

    private function setupEventListener (func:Function):void
    {
        func(Event.CLOSE, onClose);
        func(IOErrorEvent.IO_ERROR, onIOError);
    }

    public function set server (server:String):void
    {
        _server = server;
    }
    public function set netHandler (handler:NetConnectionHandler):void
    {
        _handler = handler;
        if (handler != null)
            this.dataHandler = _handler.nc_internal::handlePacket;
        else
            this.dataHandler = null;
    }
    public function get uri():String
    {
        return _server;
    }
    public function dispose ():void
    {
        try { close(); } catch (e:Error) { }
        setupEventListener (this.removeEventListener);
        _handler = null;
        this.dataHandler = null;
    }
    public function sendPing (ts:int):void
    {
        writeByte (5);
        writeInt (4);
        writeInt (ts);
        flush ();
    }
    public function sendPingResponse (ts:int):void
    {
        writeByte (10);
        writeInt (4);
        writeInt (ts);
        flush ();
    }
    override public function flush ():void
    {
        if (_flushing++ == 0)
            queueAPC (realFlush);
    }
    override public function close ():void
    {
        if (this.connected && _flushing)
            super.flush ();
        super.close ();
    }
    private function realFlush ():void
    {
        if (this.connected)
            super.flush ();
        _flushing = 0;
    }
    private function onClose (e:Event):void
    {
        setupEventListener(this.removeEventListener);
        if (_handler !== null) _handler.nc_internal::onClose (this, e);
        dispose ();
    }
    private function onIOError (e:IOErrorEvent):void
    {
        setupEventListener(this.removeEventListener);
        if (_handler !== null) _handler.nc_internal::onError(this, e);
        dispose();
    }
}
}
