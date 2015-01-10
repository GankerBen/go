package com.e2et.net.connection
{
import com.e2et.net.nc_internal;
import com.e2et.net.proxy.MediaProxyClient;
import com.e2et.utils.LEByteArray;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.utils.ByteArray;
import flash.utils.Endian;

use namespace nc_internal;

[ExcludeClass]
public class UdpConnection extends EventDispatcher implements INetConnection
{
    private var _mpc:MediaProxyClient;
    private var _id:uint, _uri:String;
    private var _handler:NetConnectionHandler = null;

    public function UdpConnection (id:uint, uri:String, mpc:MediaProxyClient)
    {
        _id = id;
        _uri = uri;
        _mpc = mpc;
        setupEventListener (this.addEventListener);
    }
    private function setupEventListener (func:Function):void
    {
        func(Event.CLOSE, onClose);
        func(IOErrorEvent.IO_ERROR, onIOError);
    }
    public function get id ():uint
    {
        return _id;
    }
    public function dispose ():void
    {
        if (_mpc)
        {
            _mpc.closeUdpConnection (this);
            _mpc = null;
        }
        _uri = null;
        _handler = null;
    }
    public function get endian ():String
    {
        return Endian.LITTLE_ENDIAN;
    }

    public function set endian(e:String):void
    {
    }

    public function flush():void
    {
    }
    public function set netHandler(handler:NetConnectionHandler):void
    {
        _handler = handler;
    }

    public function sendPing(ts:int):void
    {
        var pkt:ByteArray = new LEByteArray;
        pkt.writeByte (5);
        pkt.writeInt (4);
        pkt.writeInt (ts);
        _mpc.sendUdpData (this, pkt);
    }

    public function sendPingResponse(ts:int):void
    {
        var pkt:ByteArray = new LEByteArray;
        pkt.writeByte (10);
        pkt.writeInt (4);
        pkt.writeInt (ts);
        _mpc.sendUdpData (this, pkt);
    }

    public final function get uri():String
    {
        return _uri;
    }

    public function writeBytes(bytes:ByteArray, offset:uint=0, length:uint=0):void
    {
        var pkt:ByteArray;
        if (bytes[offset] == 62)
        { // UDP 连接上不支持测速包，需要简单处理下
            pkt = new ByteArray;
            bytes.position = offset + 1;
            var len:uint = bytes.readUnsignedInt();
            pkt.writeBytes(bytes, offset + 5, len);
            _handler.handlePacket(this, 62, pkt);
            if (len == bytes.length - 5 - offset)
                return;
            offset += 5 + len;
            if (length != 0)
                length -= 5 + len;
        }
        if (offset == 0 && (length == 0 || length == bytes.length))
        {
            pkt = bytes;
        }
        else
        {
            pkt = new ByteArray;
            pkt.writeBytes (bytes, offset, length);
        }
        _mpc.sendUdpData (this, pkt);
    }

    nc_internal function handlePacket (type:uint, pkt:ByteArray):void
    {
        if (_handler)
            _handler.nc_internal::handlePacket(this, type, pkt);
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
