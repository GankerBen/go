package com.e2et.datalogic
{
import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public final class RoomObjectPurge extends RoomActionWithSubject
{
    public function RoomObjectPurge (obj:RoomObject = null)
    {
        $subject = obj;
    }
    [Inline]
    static internal function packBody (o:RoomObjectPurge, raw:IDataOutput):void
    {
        RoomActionWithSubject.packBody (o, raw);
    }
    [Inline]
    static internal function unpackBody (o:RoomObjectPurge, raw:IDataInput):void
    {
        RoomActionWithSubject.unpackBody (o, raw);
    }
    override internal final function onApply (isLocal:Boolean):void
    {
        var obj:RoomObject = $subject;
        obj.onPurge ($root);
    }
}
}
