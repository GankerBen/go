package com.e2et.datalogic
{
import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public final class DocOpen extends DocAction
{
    public function DocOpen (doc:Document = null)
    {
        $subject = doc;
    }

    [Inline]
    static internal function packBody (o:DocOpen, raw:IDataOutput):void
    {
        RoomActionWithSubject.packBody (o, raw);
    }
    [Inline]
    static internal function unpackBody (o:DocOpen, raw:IDataInput):void
    {
        RoomActionWithSubject.unpackBody (o, raw);
    }

    override internal final function onApply (isLocal:Boolean):void
    {
        var doc:Document = $subject;
        doc.$stat |= FLAG_OPEN;
        room.$doc = doc;
    }
}
}
