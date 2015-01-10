package com.e2et.net.media.video
{
import com.e2et.net.media.IMediaSource;

import flash.media.VideoStreamSettings;
import flash.net.NetStream;

public interface IVideoCapture extends IMediaSource
{
    function checkProtoSupport (protos:Array):void;
    function start(stm:NetStream):void;
    function stop():void;
    function dispose():void;
    function get running():Boolean;
    function get videoStreamSettings():VideoStreamSettings;
    function set videoStreamSettings(v:VideoStreamSettings):void;
}
}
