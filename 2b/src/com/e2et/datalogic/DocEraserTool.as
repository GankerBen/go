package com.e2et.datalogic
{
import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public final dynamic class DocEraserTool extends DocTool
{
    [Inline]
    static public function packBody (o:DocEraserTool, raw:IDataOutput):void
    {
        DocTool.packBody (o, raw);
    }
    [Inline]
    static public function unpackBody (o:DocEraserTool, raw:IDataInput):void
    {
        DocTool.unpackBody (o, raw);
    }
}
}
