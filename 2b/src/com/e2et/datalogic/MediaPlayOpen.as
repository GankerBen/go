package com.e2et.datalogic
{
import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public final class MediaPlayOpen extends MediaPlayAction
{
    public function MediaPlayOpen (mp:MediaPlayer = null)
    {
        $subject = mp;
    }
    [Inline]
    static internal function packBody (o:MediaPlayOpen, raw:IDataOutput):void
    {
        RoomActionWithSubject.packBody (o, raw);
    }
    [Inline]
    static internal function unpackBody (o:MediaPlayOpen, raw:IDataInput):void
    {
        RoomActionWithSubject.unpackBody (o, raw);
    }

    override internal final function onApply (isLocal:Boolean):void
    {
        var mp:MediaPlayer = $subject;
        mp.$stat |= FLAG_OPEN;
        var room:Room = $root;
        room.mediaPlayers.push (mp);
    }
}
}
