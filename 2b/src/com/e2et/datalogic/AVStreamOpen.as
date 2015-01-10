package com.e2et.datalogic
{
import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public final class AVStreamOpen extends AVStreamAction
{
    public function AVStreamOpen (stm:AVStream = null, audioOn:Boolean = false, videoOn:Boolean = false)
    {
        $subject = stm;
        _audioOn = audioOn;
        _videoOn = videoOn;
    }
    [Inline]
    static internal function packBody (o:AVStreamOpen, raw:IDataOutput):void
    {
        UserActionWithSubject.packBody (o, raw);
        var v:uint = 0;
        if (o._audioOn)
            v |= 1;
        if (o._videoOn)
            v |= 2;
        raw.writeByte (v);
    }
    [Inline]
    static internal function unpackBody (o:AVStreamOpen, raw:IDataInput):void
    {
        UserActionWithSubject.unpackBody (o, raw);
        var v:uint = raw.readByte ();
        o._audioOn = (v & 1) != 0;
        o._videoOn = (v & 2) != 0;
    }

    private var _audioOn:Boolean;
    private var _videoOn:Boolean;

    override internal final function onApply (isLocal:Boolean):void
    {
        var stm:AVStream = $subject;
        stm.$stat |= FLAG_OPEN;
        stm.$audioOn = _audioOn;
        stm.$videoOn = _videoOn;
        var user:User = $root;
        var stms:Vector.<AVStream> = user.$streams;
        if (stms == null)
        {
            user.$streams = stms = new Vector.<AVStream>;
        }
        stms.push (stm);
    }
}
}
