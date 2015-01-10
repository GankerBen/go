package com.e2et.net.media.video
{
import com.e2et.Session;
import com.e2et.net.media.MediaSource;

import flash.media.Camera;
import flash.media.H264Level;
import flash.media.H264Profile;
import flash.media.H264VideoStreamSettings;
import flash.media.Video;
import flash.media.VideoStreamSettings;
import flash.net.NetStream;
import flash.utils.ByteArray;
import flash.utils.Endian;

[ExcludeClass]
public final class CamCapture extends MediaSource implements IVideoCapture, IPreview
{
    static private var _protos:Object = { 'tcp://': true, 'rtmp://': true, 'rtmfp://': true, 'udp://': true };

    private var $:Session;
    private var _cam:Camera = null;
    private var _stm:NetStream = null;
    private var _mp_stm:MPStream;
    private var _videos:Vector.<Video> = new Vector.<Video>;
    private var _vss:VideoStreamSettings = new H264VideoStreamSettings;

    public function CamCapture ($:Session, cam:Camera)
    {
        _cam = cam;
        this.$ = $;
        _vss.setKeyFrameInterval(15);
        (_vss as H264VideoStreamSettings).setProfileLevel(H264Profile.MAIN, H264Level.LEVEL_2_1);
    }

    /* ---------------------------- IVideoCapture ----------------------------*/
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

        if (_stm == null)
        {
            if (_mp_stm == null)
                _mp_stm = new MPStream ($, handleMPCommand);
            _stm = _mp_stm;
        }
        _stm.videoStreamSettings = _vss;
        _stm.attachCamera(_cam);
    }

    public final function stop():void
    {
        if (_stm != null)
        {
            _stm.attachCamera(null);
            _stm = null;
        }
    }

    public override function dispose():void
    {
        stop();
        var vec:Vector.<Video> = _videos;
        while (vec.length)
        {
            var v:Video = vec.pop ();
            v.attachCamera (null);
        }
        if (_mp_stm != null)
        {
            _mp_stm.close ();
            _mp_stm.dispose();
            _mp_stm = null;
        }
        _cam = null;
        super.dispose();
    }
    public function get videoStreamSettings():VideoStreamSettings
    {
        return _vss;
    }
    public function set videoStreamSettings(v:VideoStreamSettings):void
    {
        _vss = v;
        if (_stm != null)
            _stm.videoStreamSettings = v;
    }

    public final function get running():Boolean
    {
        return _stm != null;
    }

    public final function get previewing():Boolean
    {
        return _videos.length > 0;
    }
    public final function startPreview (v:Video):void
    {
        if (_videos.indexOf (v) < 0)
        {
            _videos.push (v);
            v.attachCamera (_cam);
        }
    }
    public final function stopPreview (v:Video):void
    {
        var i:int = _videos.indexOf (v);
        if (i >= 0)
        {
            v.attachCamera (null);
            _videos.splice (i, 1);
        }
    }
    private function handleMPCommand (pkt:ByteArray):void
    {
        pkt.endian = Endian.LITTLE_ENDIAN;
        if (pkt[0] == 9)
            handleMediaData (pkt);
    }
}
}
import com.e2et.Session;

import flash.net.NetStream;

class MPStream extends NetStream
{
    static private var seq:uint = 1;
    public function MPStream ($:Session, func:Function)
    {
        super ($.mpc);
        if ($.mpc == null)
            throw new Error ('插件未启动');
        this.client = { mp: func };
        this.publish ('kk' + seq.toString()); ++seq;
    }
}
