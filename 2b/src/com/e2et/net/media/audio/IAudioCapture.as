package com.e2et.net.media.audio
{
import com.e2et.net.media.IMediaSource;

import flash.media.SoundTransform;
import flash.net.NetStream;

public interface IAudioCapture extends IMediaSource
{
    function checkProtoSupport (protos:Array):void;
    function start(stm:NetStream):void;
    function stop():void;
    function dispose():void;
    function get running():Boolean;
    function get soundTransform():SoundTransform;
    function set soundTransform(v:SoundTransform):void;
}
}
