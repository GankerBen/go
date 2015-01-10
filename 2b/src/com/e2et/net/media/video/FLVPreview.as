package com.e2et.net.media.video
{
import com.e2et.net.media.MediaSource;
import com.e2et.utils.FLVPacket;

import flash.media.Video;
import flash.net.NetStream;
import flash.net.NetStreamAppendBytesAction;
import flash.utils.ByteArray;

internal class FLVPreview extends MediaSource implements IPreview
{
    private var _videos:Vector.<Video> = new Vector.<Video>;
    private var _preview_stm:NetStream;
    private var _running:uint = 0;

    public function FLVPreview()
    {
    }

    public function start(stm:NetStream):void
    {
        ++_running;
    }
    public function stop():void
    {
        --_running;
    }
    public override function dispose():void
    {
        while (_videos.length)
            stopPreview (_videos[0]);
        while (_running > 0)
            stop ();
        super.dispose();
    }
    public final function get running():Boolean
    {
        return _running != 0;
    }
    public final function get previewing():Boolean
    {
        return _preview_stm != null;
    }
    public final function startPreview (v:Video):void
    {
        if (_videos.indexOf (v) >= 0)
            return;
        if (_videos.push (v) == 1)
        {
            _preview_stm = newFLVStream (5);
            _preview_stm.seek(0);
            _preview_stm.appendBytesAction(NetStreamAppendBytesAction.RESET_SEEK);
        }
        v.attachNetStream (_preview_stm);
        start (null);
    }

    public function stopPreview (v:Video):void
    {
        var i:int = _videos.indexOf (v);
        if (i < 0)
            return;
        stop ();
        if (_videos.splice (i, 1).length == 0)
        {
            _preview_stm.close ();
            _preview_stm = null;
        }
    }
    public override function handleMediaData(pkt:ByteArray):void
    {
        super.handleMediaData(pkt);
        if (_preview_stm)
        {
            pkt.position  = 0;
            var tag:int = pkt.readByte();
            var time:uint = pkt.readUnsignedInt();
            if (tag == 9)
            {
                pkt = FLVPacket.makeFLVPacket(tag, time, pkt, 5);
                _preview_stm.appendBytes(pkt);
            }
        }
    }
}
}
