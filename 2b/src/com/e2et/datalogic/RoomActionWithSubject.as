package com.e2et.datalogic
{
import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public class RoomActionWithSubject extends RoomAction
{
    [Inline]
    static internal function packBody (o:RoomActionWithSubject, raw:IDataOutput):void
    {
        RoomAction.packBody (o, raw);
        refObject (o.$subject, raw);
    }
    [Inline]
    static internal function unpackBody (o:RoomActionWithSubject, raw:IDataInput):void
    {
        RoomAction.unpackBody (o, raw);
        o.$subject = derefObject (o.$root, raw);
    }

    internal var $subject:*;

    public final function get subject ():RoomObject
    {
        return $subject;
    }
}
}
