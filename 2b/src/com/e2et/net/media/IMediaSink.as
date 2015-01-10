package com.e2et.net.media
{
import flash.utils.ByteArray;

[ExcludeClass]
public interface IMediaSink
{
    function handleMediaData (source:IMediaSource, flv:ByteArray):void;
}
}
