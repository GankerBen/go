package com.e2et.datalogic
{
import com.e2et.datalogic.utils.readI29;
import com.e2et.datalogic.utils.writeI29;

import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public final class Point
{
    internal var $x:int;
    internal var $y:int;

    public function Point (x:int, y:int)
    {
        $x = x;
        $y = y;
    }
    public final function get x ():int
    {
        return $x;
    }
    public final function get y ():int
    {
        return $y;
    }

    [Inline]
    public final function pack (raw:IDataOutput, ptref:Point = null):Point
    {
        if (ptref == null)
        {
            writeI29 (raw, $x);
            writeI29 (raw, $y);
        }
        else
        {
            writeI29 (raw, $x - ptref.$x);
            writeI29 (raw, $y - ptref.$y);
        }
        return this;
    }
    [Inline]
    static public function unpack (raw:IDataInput, ptref:Point = null):Point
    {
        var x:int = readI29 (raw);
        var y:int = readI29 (raw);
        if (ptref != null)
            return new Point (ptref.$x + x, ptref.$y + y);
        else
            return new Point (x, y);
    }

    [Inline]
    public final function equals (pt:Point):Boolean
    {
        return $x == pt.$x && $y == pt.$y;
    }
}
}
