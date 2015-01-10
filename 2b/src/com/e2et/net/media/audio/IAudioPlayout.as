package com.e2et.net.media.audio
{
import flash.utils.ByteArray;

[ExcludeClass]
public interface IAudioPlayout
{
    function get bufferLength():Number;

    function get bufferTime():Number;
    function set bufferTime(time:Number):void;

    function get bufferTimeMax():Number;
    function set bufferTimeMax(time:Number):void;

    function flush():void;
    function handleAudioPacket (time:uint, pkt:ByteArray, offset:uint = 0, length:uint = 0):void;

    function close():void;
    function dispose():void;
}
}
