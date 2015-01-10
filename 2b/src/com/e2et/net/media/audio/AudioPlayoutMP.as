package com.e2et.net.media.audio
{
import com.e2et.net.proxy.MediaProxyClient;

import flash.utils.ByteArray;

[ExcludeClass]
public class AudioPlayoutMP implements IAudioPlayout
{
    static private var _nextId:uint = 0;
    private var _mp:MediaProxyClient;
    private var _id:uint;

    static public function create (mp:MediaProxyClient):AudioPlayoutMP
    {
        if (mp == null)
            return null;
        else
            return new AudioPlayoutMP(mp);
    }

    public final function AudioPlayoutMP(mp:MediaProxyClient)
    {
        _mp = mp;
        _id = ++_nextId;

        _mp.startPlayout(_id);
    }

    public final function get bufferLength():Number
    {
        // TODO:
        return 0;
    }

    public final function get bufferTime():Number
    {
        // TODO:
        return 0;
    }

    public final function set bufferTime(time:Number):void
    {
        // TODO:
    }

    public final function get bufferTimeMax():Number
    {
        // TODO:
        return 0;
    }

    public final function set bufferTimeMax(time:Number):void
    {
        // TODO:
    }
    public final function close():void
    {
        if (_mp)
        {
            _mp.stopPlayout(_id);
            _mp = null;
        }
    }

    public final function dispose():void
    {
        close ();
    }

    public final function flush():void
    {
        if (_mp) _mp.flushPlayout (_id);
    }

    public final function handleAudioPacket(time:uint, pkt:ByteArray, offset:uint = 0, length:uint = 0):void
    {
        if (_mp) _mp.playAudio(_id, time, pkt, offset, length);
    }
}
}
