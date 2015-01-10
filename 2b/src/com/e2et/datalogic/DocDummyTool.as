package com.e2et.datalogic
{
import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public final dynamic class DocDummyTool extends DocTool
{
    [Inline]
    static public function packBody (o:DocDummyTool, raw:IDataOutput):void
    {
        DocTool.packBody (o, raw);
    }
    [Inline]
    static public function unpackBody (o:DocDummyTool, raw:IDataInput):void
    {
        DocTool.unpackBody (o, raw);
    }
}
}
