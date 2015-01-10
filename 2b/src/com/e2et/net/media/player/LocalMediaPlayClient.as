package com.e2et.net.media.player
{
import com.e2et.Session;
import com.e2et.net.media.IMediaSink;
import com.e2et.net.media.IMediaSource;
import com.e2et.net.media.audio.IAudioCapture;
import com.e2et.net.media.video.IVideoCapture;
import com.e2et.utils.FLVPacket;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.net.NetStream;
import flash.net.NetStreamAppendBytesAction;
import flash.utils.ByteArray;

public class LocalMediaPlayClient implements IMediaPlayClient, IMediaSink
{
    private var acap:IAudioCapture;
    private var vcap:IVideoCapture;
    private var stm:NetStream;
    private var _handler:IMediaPlayHandler;
    private var $:Session;
    private var _name:String;
    private var _audioOn:Boolean = true;
    private var _videoOn:Boolean = true;
    private var _pubc:EventDispatcher;
    private var _audio_detected:Boolean = false;
    private var _video_detected:Boolean = false;
    private var _last_audio_time:uint;

    public function LocalMediaPlayClient ($:Session, name:String, handler:IMediaPlayHandler, pubc:EventDispatcher)
    {
        this.$ = $;
        _name = name;
        _handler = handler;
        _pubc = pubc;
    }

    public function get audioOn():Boolean
    {
        return _audioOn;
    }
    public function set audioOn(on:Boolean):void
    {
        if (_audioOn && !on)
        {
            if (_audio_detected)
            {
                stm.appendBytes(FLVPacket.zeroAudioPacket(_last_audio_time));
                _audio_detected = false;
            }
        }
        _audioOn = on;
    }
    public function get videoOn():Boolean
    {
        return _videoOn;
    }
    public function set videoOn(on:Boolean):void
    {
        if (_videoOn && !on)
            _video_detected = false;
        _videoOn = on;
    }
    public function get hasAudio():Boolean
    {
        return acap != null;
    }
    public function get hasVideo():Boolean
    {
        return vcap != null;
    }

    public function close():void
    {
        if ($ == null) return;
        if (_pubc)
        {
            _pubc.removeEventListener(Event.CLOSE, onPublishClosed);
            _pubc.removeEventListener('avStatus', AVStatusChanged);
            _pubc = null;
        }
        _handler = null;
        acap = null;
        vcap = null;
        $ = null;
    }

    public function connect():void
    {
        _handler.mediaPlayStarting(this);
        stm = newFLVStream(5);
        _handler.mediaPlayStarted(this, stm);
        _pubc.addEventListener(Event.CLOSE, onPublishClosed);
        _pubc.addEventListener('avStatus', AVStatusChanged);
        acap = _pubc['audioCap'];
        if (acap) acap.addSink(this);
        vcap = _pubc['videoCap'];
        if (vcap) vcap.addSink(this);
    }
    public function get name():String
    {
        return _name;
    }
    public function get uri():String
    {
        return 'local://' + _name;
    }

    public function handleMediaData(source:IMediaSource, flv:ByteArray):void
    {
        var tag:uint = flv[0], time:uint;
        if (tag == 8)
        {
            if (!_audioOn)
                return;
            flv.position = 1;
            time = flv.readUnsignedInt();
            if (!_audio_detected && !_video_detected)
            {
                stm.seek(0);
                stm.appendBytesAction(NetStreamAppendBytesAction.RESET_SEEK);
            }
            _audio_detected = true;
            _last_audio_time = time;
        }
        else if (tag == 9)
        {
            if (!_videoOn)
                return;
            flv.position = 1;
            time = flv.readUnsignedInt();
            if (!_audio_detected && !_video_detected)
            {
                stm.seek(0);
                stm.appendBytesAction(NetStreamAppendBytesAction.RESET_SEEK);
            }
            _video_detected = true;
        }
        else
            return;
        stm.appendBytes(FLVPacket.makeFLVPacket(tag, time, flv, 5));
    }

    private function onPublishClosed (e:Event):void
    {
        _handler.mediaPlayInterrupted(this, 'pubClosed');
    }
    private function AVStatusChanged (e:Event):void
    {
        if (acap) acap.delSink(this);
        if (vcap) vcap.delSink(this);
        acap = _pubc['audioCap'];
        if (acap) acap.addSink(this);
        if (_audio_detected && acap == null)
        {
            stm.appendBytes(FLVPacket.zeroAudioPacket(_last_audio_time));
            _audio_detected = false;
        }
        vcap = _pubc['videoCap'];
        if (vcap) vcap.addSink(this);
    }
}
}
