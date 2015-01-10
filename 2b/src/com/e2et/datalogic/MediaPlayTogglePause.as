package com.e2et.datalogic
{
import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public final class MediaPlayTogglePause extends MediaPlayAction
{
    public function MediaPlayTogglePause (mp:MediaPlayer = null)
    {
        $subject = mp;
    }
    [Inline]
    static internal function packBody (o:MediaPlayTogglePause, raw:IDataOutput):void
    {
        RoomActionWithSubject.packBody (o, raw);
    }
    [Inline]
    static internal function unpackBody (o:MediaPlayTogglePause, raw:IDataInput):void
    {
        RoomActionWithSubject.unpackBody (o, raw);
    }

    override internal final function onApply (isLocal:Boolean):void
    {
        var mp:MediaPlayer = $subject;
        mp.$paused = !mp.$paused;
    }
}
}
