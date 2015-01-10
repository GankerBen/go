package com.e2et.net.media
{
import flash.utils.ByteArray;

public class MediaSource implements IMediaSource
{
    private var _sinks:Vector.<IMediaSink> = new Vector.<IMediaSink>;

    public function dispose ():void
    {
        _sinks = null;
    }
    public function addSink (sink:IMediaSink):void
    {
        var v:Vector.<IMediaSink> = _sinks;
        if (v.indexOf (sink) < 0)
            v.push (sink);
    }
    public function delSink (sink:IMediaSink):void
    {
        var i:int, v:Vector.<IMediaSink> = _sinks;
        if ((i = v.indexOf (sink)) >= 0)
            v.splice (i, 1);
    }
    public function handleMediaData (pkt:ByteArray):void
    {
        var v:Vector.<IMediaSink> = _sinks, i:uint, c:uint = v.length;
        for (i=0; i<c; ++i)
            v[i].handleMediaData (this, pkt);
    }
}
}
