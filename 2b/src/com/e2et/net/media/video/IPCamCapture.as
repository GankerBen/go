package com.e2et.net.media.video
{
import com.e2et.Session;
import com.e2et.net.proxy.IPCamPlugin;

import flash.media.VideoStreamSettings;
import flash.net.NetStream;

[ExcludeClass]
public final class IPCamCapture extends FLVPreview implements IVideoCapture
{
    static private var camdb:Object = {
        "hik-00": { id: "mp.hik.0", cmd: "hik0" }
    };
    private var $:Session;
    private var _ipcam:IPCamPlugin;
    private var _param:String;

    public function IPCamCapture($:Session, ipcam:String)
    {
        this.$ = $;
        // [id, name, params]
        var info:Array = ipcam.split(',');
        var id:String = info.shift();
        var name:String = info.shift();
        if (id in camdb)
        {
            var cam:Object = camdb[id];
            _ipcam = new IPCamPlugin ($.mpc, cam.id, cam.cmd, this);
            _param = info.join(',');
        }
        else
            throw new Error ('未知 IP 摄像头');
    }

    public function checkProtoSupport(protos:Array):void
    {
        var args:Array = [0, protos.length];
        for each (var proto:String in protos)
        {
            if (proto == "tcp://" || proto == 'udp://')
            {
                args.push (proto);
                break;
            }
        }
        protos.splice.apply(protos, args);
    }

    public override function start(stm:NetStream):void
    {
        if (stm != null)
            throw new Error ('在 RTMP/RTMPFP 流上发布是不行的！');
        if (!running)
            _ipcam.startCap(_param);
        super.start(stm);
    }

    public override function stop():void
    {
        if (!running)
            return;
        super.stop ();
        if (!running)
            _ipcam.stopCap();
    }

    public override function dispose():void
    {
        super.dispose();
        _ipcam = null;
        $ = null;
    }
    public function get videoStreamSettings():VideoStreamSettings
    {
        return null;
    }
    public function set videoStreamSettings(v:VideoStreamSettings):void
    {
    }
}
}
