package com.e2et.datalogic
{
import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public class DocTool extends RoomObject
{
    [Inline]
    static public function packBody (o:DocTool, raw:IDataOutput):void
    {
        RoomObject.packBody (o, raw);
    }
    [Inline]
    static public function unpackBody (o:DocTool, raw:IDataInput):void
    {
        RoomObject.unpackBody (o, raw);
    }
}
}
