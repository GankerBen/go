package com.e2et.datalogic
{
import flash.utils.IDataInput;
import flash.utils.IDataOutput;

internal final class RoomObjectSetPOC extends RoomActionWithSubject
{
    public function RoomObjectSetPOC (obj:RoomObject = null, b:Boolean = false)
    {
        $subject = obj;
        _b = b;
    }

    [Inline]
    static internal function packBody (o:RoomObjectSetPOC, raw:IDataOutput):void
    {
        RoomActionWithSubject.packBody (o, raw);
        raw.writeBoolean (o._b);
    }
    [Inline]
    static internal function unpackBody (o:RoomObjectSetPOC, raw:IDataInput):void
    {
        RoomActionWithSubject.unpackBody (o, raw);
        o._b = raw.readBoolean ();
    }

    override internal final function onApply (isLocal:Boolean):void
    {
        var obj:RoomObject = $subject;
        if (_b)
            obj.$stat |= FLAG_PURGE_ON_CLOSE;
        else
            obj.$stat &= ~FLAG_PURGE_ON_CLOSE;
    }

    private var _b:Boolean;
}
}
