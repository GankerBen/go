package com.e2et.datalogic
{
import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public final dynamic class DocTextTool extends DocTool
{
    public function DocTextTool (color:uint = 0, alpha:Number = 1.0, font:String = null)
    {
        $color = color;
        $alpha = alpha;
        $font = font;
    }

    [Inline]
    static public function packBody (o:DocTextTool, raw:IDataOutput):void
    {
        DocTool.packBody (o, raw);
        raw.writeUnsignedInt (o.$color);
        raw.writeDouble (o.$alpha);
        raw.writeUTF (o.$font);
    }
    [Inline]
    static public function unpackBody (o:DocTextTool, raw:IDataInput):void
    {
        DocTool.unpackBody (o, raw);
        o.$color = raw.readUnsignedInt ();
        o.$alpha = raw.readDouble ();
        o.$font = raw.readUTF ();
    }

    internal var $color:uint;
    internal var $alpha:Number;
    internal var $font:String;

    public final function get color ():uint
    {
        return $color;
    }
    public final function get alpha ():Number
    {
        return $alpha;
    }
    public final function get font ():String
    {
        return $font;
    }
}
}
