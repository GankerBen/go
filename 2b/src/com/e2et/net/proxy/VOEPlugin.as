package com.e2et.net.proxy
{
import com.e2et.net.media.audio.MicCapture;
import com.e2et.utils.LEByteArray;

import flash.utils.ByteArray;
import flash.utils.Endian;

internal class VOEPlugin
{
    static public const pluginId:String = 'mp.voice.0';
    static public const pluginCmd:String = 'voe';

    private var mpc:MediaProxyClient;
    public var audiocap:MicCapture;

    public function VOEPlugin(mpc:MediaProxyClient)
    {
        this.mpc = mpc;
        mpc.client[pluginCmd] = handleVOECommand;
    }
    [Inline]
    public final function startPlayout (id:uint):void
    {
        mpc.call(pluginCmd, null, CMD_START_PLAY, id);
    }
    public function playAudio (id:uint, time:uint, pkt:ByteArray, offset:uint, length:uint):void
    {
        if (length == 0)
            length = pkt.length - offset;
        var o:ByteArray = new LEByteArray;
        o.writeUnsignedInt(id);
        o.writeUnsignedInt(time);
        o.writeBytes(pkt, offset, length);
        mpc.call(pluginCmd, null, CMD_PLAY_AUDIO, o);
    }
    [Inline]
    public final function flushPlayout (id:uint):void
    {
        mpc.call(pluginCmd, null, CMD_FLUSH_PLAY, id);
    }
    [Inline]
    public final function stopPlayout (id:uint):void
    {
        mpc.call(pluginCmd, null, CMD_STOP_PLAY, id);
    }
    [Inline]
    public final function startAudioCap(name:String):void
    {
        mpc.startPlugin(pluginId);
        mpc.call(pluginCmd, null, CMD_START_CAP, name);
    }
    [Inline]
    public final function stopAudioCap():void
    {
        mpc.call(pluginCmd, null, CMD_STOP_CAP);
        mpc.stopPlugin(pluginId);
    }
    private function handleVOECommand (data:ByteArray):void
    {
        data.endian = Endian.LITTLE_ENDIAN;
        if (audiocap != null)
            audiocap.handleMediaData(data);
    }
}
}

const CMD_START_PLAY:String = 'A';
const CMD_PLAY_AUDIO:String = 'B';
const CMD_FLUSH_PLAY:String = 'C';
const CMD_STOP_PLAY:String = 'D';
const CMD_START_CAP:String = 'E';
const CMD_STOP_CAP:String = 'F';
