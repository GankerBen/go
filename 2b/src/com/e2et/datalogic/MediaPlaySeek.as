package com.e2et.datalogic
{
import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public final class MediaPlaySeek extends MediaPlayAction
{
    public function MediaPlaySeek (mp:MediaPlayer = null, time:Number = 0)
    {
        $subject = mp;
        _time = time;
    }

    [Inline]
    static internal function packBody (o:MediaPlaySeek, raw:IDataOutput):void
    {
        RoomActionWithSubject.packBody (o, raw);
        raw.writeDouble (o._time);
    }
    [Inline]
    static internal function unpackBody (o:MediaPlaySeek, raw:IDataInput):void
    {
        RoomActionWithSubject.unpackBody (o, raw);
        o._time = raw.readDouble ();
    }

    private var _time:Number;

    public final function get time ():Number
    {
        return _time;
    }

    override internal final function onApply (isLocal:Boolean):void
    {
        var mp:MediaPlayer = $subject;
        mp.$time = _time;
    }
}
}
