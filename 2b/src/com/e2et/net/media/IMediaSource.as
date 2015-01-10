package com.e2et.net.media
{
[ExcludeClass]
public interface IMediaSource
{
    function addSink (sink:IMediaSink):void;
    function delSink (sink:IMediaSink):void;
}
}
