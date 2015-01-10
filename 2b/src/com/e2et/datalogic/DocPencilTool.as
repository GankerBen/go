package com.e2et.datalogic
{
import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public final dynamic class DocPencilTool extends DocTool
{
    public function DocPencilTool (color:uint = 0, style:uint = 0, alpha:Number = 0, thickness:uint = 0)
    {
        $color = color;
        $style = style;
        $alpha = alpha;
        $thickness = thickness;
    }
    [Inline]
    static public function packBody (o:DocPencilTool, raw:IDataOutput):void
    {
        DocTool.packBody (o, raw);
        raw.writeUnsignedInt (o.$color);
        raw.writeUnsignedInt (o.$style);
        raw.writeDouble (o.$alpha);
        raw.writeUnsignedInt (o.$thickness);
    }
    [Inline]
    static public function unpackBody (o:DocPencilTool, raw:IDataInput):void
    {
        DocTool.unpackBody (o, raw);
        o.$color = raw.readUnsignedInt ();
        o.$style = raw.readUnsignedInt ();
        o.$alpha = raw.readDouble ();
        o.$thickness = raw.readUnsignedInt ();
    }

    internal var $color:uint;
    internal var $style:uint;
    internal var $alpha:Number;
    internal var $thickness:uint;


    public final function get color ():uint
    {
        return $color;
    }
    public final function get style ():uint
    {
        return $style;
    }
    public final function get alpha ():Number
    {
        return $alpha;
    }
    public final function get thickness ():uint
    {
        return $thickness;
    }
}
}
