package com.e2et.datalogic
{
import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public class RoomAction extends MetaAction
{
    [Inline]
    static internal function packBody (o:RoomAction, raw:IDataOutput):void
    {
        MetaAction.packBody (o, raw);
    }
    [Inline]
    static internal function unpackBody (o:RoomAction, raw:IDataInput):void
    {
        MetaAction.unpackBody (o, raw);
    }

    public final function get room ():Room
    {
        return $root;
    }
    [inline]
    static internal function refObject (obj:RoomObject, raw:IDataOutput):void
    {
        raw.writeUnsignedInt (obj ? obj.$id : 0);
    }
}
}
