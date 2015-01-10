package com.e2et.net.media.audio
{
import com.e2et.Session;
import com.e2et.net.media.MediaSource;
import com.e2et.net.proxy.MediaProxyClient;

import flash.media.Microphone;
import flash.media.SoundTransform;
import flash.net.NetStream;

[ExcludeClass]
public class MicCapture extends MediaSource implements IAudioCapture
{
    static private var _protos:Object = { 'tcp://': true, 'rtmp://': true, 'rtmfp://':true, 'udp://': true };

    private var $:Session;
    private var _mic:Microphone;

    private var _stm:NetStream = null;
    private var _mp:MediaProxyClient = null;
    private var _st:SoundTransform = new SoundTransform;

    public function MicCapture($:Session, mic:Microphone)
    {
        _mic = mic;
        this.$ = $;
    }

    /* ---------------------------- IAudioCapture ----------------------------*/
    public final function checkProtoSupport (protos:Array):void
    {
        var args:Array = [0, protos.length];
        for each (var proto:String in protos)
        {
            if (_protos[proto])
                args.push (proto);
        }
        protos.splice.apply(protos, args);
    }

    public final function start(stm:NetStream):void
    {
        _stm = stm;
        if (stm != null)
        {
            stm.soundTransform = _st;
            stm.attachAudio(_mic);
        }
        else
        {
            _mp = $.mpc;
            if (_mp == null)
                throw new Error('媒体代理未启动');
            if (_mp.audiocap != null)
                return;
            _mp.startAudioCap('#default');
            _mp.audiocap = this;
        }
    }

    public final function stop():void
    {
        if (_stm != null)
        {
            _stm.attachAudio(null);
            _stm = null;
        }
        else if (_mp != null && _mp.audiocap == this)
        {
            _mp.stopAudioCap();
            _mp.audiocap = null;
            _mp = null;
        }
    }

    override public final function dispose():void
    {
        stop();
        _mic = null;
        super.dispose ();
    }

    public final function get running():Boolean
    {
        return _stm != null || _mp != null;
    }

    public final function get soundTransform ():SoundTransform
    {
        return _st;
    }
    public final function set soundTransform (v:SoundTransform):void
    {
        _st = v;
        if (_stm != null)
            _stm.soundTransform = v;
    }
}
}
