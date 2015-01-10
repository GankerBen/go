package com.e2et.datalogic
{
import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public final class MediaPlayClose extends MediaPlayAction
{
    public function MediaPlayClose (mp:MediaPlayer = null)
    {
        $subject = mp;
    }
    [Inline]
    static internal function packBody (o:MediaPlayClose, raw:IDataOutput):void
    {
        RoomActionWithSubject.packBody (o, raw);
    }
    [Inline]
    static internal function unpackBody (o:MediaPlayClose, raw:IDataInput):void
    {
        RoomActionWithSubject.unpackBody (o, raw);
    }

    override internal final function onApply (isLocal:Boolean):void
    {
        var mp:MediaPlayer = $subject;
        mp.$stat &= ~FLAG_OPEN;
        var room:Room = $root;
        var mps:Vector.<MediaPlayer> = room.mediaPlayers;
        var i:int = mps.indexOf (mp);
        if (i >= 0)
            mps.splice (i, 1);
    }
    override internal final function onHandled (isLocal:Boolean):void
    {
        $root.delObject ($subject);
    }
}
}
