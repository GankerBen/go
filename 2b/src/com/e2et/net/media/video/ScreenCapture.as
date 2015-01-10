package com.e2et.net.media.video
{
import com.e2et.ScreenCap;
import com.e2et.Session;
import com.e2et.net.proxy.MediaProxyClient;

import flash.events.Event;
import flash.media.VideoStreamSettings;
import flash.net.NetStream;

[ExcludeClass]
public final class ScreenCapture extends FLVPreview implements IVideoCapture
{
    static private var _protos:Object = { 'tcp://': true };
    private var $:Session;
    private var mpc:MediaProxyClient;
    private var closure:Function;

    public function ScreenCapture($:Session, mpc:MediaProxyClient, closure:Function)
    {
        this.$ = $;
        this.mpc = mpc;
        this.closure = closure;
        mpc.initScreenCap();
        $.addEventListener(Session.PROXY_CLOSE, onProxyClose);
        $.addEventListener(Session.PROXY_IOERROR, onProxyClose);
    }

    public function capCallback (code:uint):void
    {
        if (closure != null)
            closure (code);
    }
    public function checkProtoSupport(protos:Array):void
    {
        var args:Array = [0, protos.length];
        for each (var proto:String in protos)
        {
            if (_protos[proto])
                args.push (proto);
        }
        protos.splice.apply(protos, args);
    }

    public override function dispose():void
    {
        super.dispose ();
        if (mpc != null)
        {
            $.removeEventListener(Session.PROXY_CLOSE, onProxyClose);
            $.removeEventListener(Session.PROXY_IOERROR, onProxyClose);
            mpc.screencap = null;
            mpc = null;
        }
        closure = null;
        $ = null;
    }
    public override function start(stm:NetStream):void
    {
        if (stm != null)
            throw new Error ('在 RTMP/RTMPFP 流上发布是不行的！');
        if (!running)
            mpc.startScreenCap();
        super.start (stm);
    }
    public override function stop():void
    {
        if (!running)
            return;
        super.stop ();
        if (!running)
            mpc.stopScreenCap();
    }
    public function get videoStreamSettings():VideoStreamSettings
    {
        return null;
    }
    public function set videoStreamSettings(v:VideoStreamSettings):void
    {
    }

    private function onProxyClose(e:Event):void
    {
        if (closure != null)
            closure (ScreenCap.STOPPED_BY_MPC);
        dispose ();
    }
}
}
