package com.e2et.net.connection
{
import flash.utils.ByteArray;

public interface INetConnection
{
    function get uri():String;
    function set netHandler (handler:NetConnectionHandler):void;
    function get endian():String;
    function set endian(e:String):void;

    function writeBytes (bytes:ByteArray, offset:uint = 0, length:uint = 0):void;
    function flush ():void;
    function dispose ():void;
    function sendPing (ts:int):void;
    function sendPingResponse (ts:int):void;
}
}
