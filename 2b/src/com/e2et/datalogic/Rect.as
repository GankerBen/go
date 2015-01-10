package com.e2et.datalogic
{
import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public final class Rect
{
    internal var $pt:Point;
    internal var $size:Size;

    public function Rect (pt:Point, size:Size)
    {
        $pt = pt;
        $size = size;
    }

    public final function point ():Point
    {
        return $pt;
    }
    public final function size ():Size
    {
        return $size;
    }

    public final function pack (raw:IDataOutput):void
    {
        $pt.pack (raw);
        $size.pack (raw);
    }
    static public function unpack (raw:IDataInput):Rect
    {
        var pt:Point = Point.unpack (raw);
        var size:Size = Size.unpack (raw);
        return new Rect (pt, size);
    }
}
}
