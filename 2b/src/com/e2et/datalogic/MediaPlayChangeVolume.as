package com.e2et.datalogic
{
import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public final class MediaPlayChangeVolume extends MediaPlayAction
{
    public function MediaPlayChangeVolume (mp:MediaPlayer = null, volume:Number = 0)
    {
        $subject = mp;
        _volume = volume;
    }

    [Inline]
    static internal function packBody (o:MediaPlayChangeVolume, raw:IDataOutput):void
    {
        RoomActionWithSubject.packBody (o, raw);
        raw.writeDouble (o._volume);
    }
    [Inline]
    static internal function unpackBody (o:MediaPlayChangeVolume, raw:IDataInput):void
    {
        RoomActionWithSubject.unpackBody (o, raw);
        o._volume = raw.readDouble ();
    }

    private var _volume:Number;

    public final function get volume():Number
    {
        return _volume;
    }

    override internal final function onApply (isLocal:Boolean):void
    {
        var mp:MediaPlayer = $subject;
        mp.$volume = _volume;
    }
}
}
