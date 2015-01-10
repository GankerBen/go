package com.e2et.datalogic
{
import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public final dynamic class DocSelectionTool extends DocTool
{
    [Inline]
    static public function packBody (o:DocSelectionTool, raw:IDataOutput):void
    {
        DocTool.packBody (o, raw);
    }
    [Inline]
    static public function unpackBody (o:DocSelectionTool, raw:IDataInput):void
    {
        DocTool.unpackBody (o, raw);
    }
}
}
