package com.e2et.datalogic
{
import com.e2et.datalogic.utils.readU29;
import com.e2et.datalogic.utils.writeU29;

import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public final class Size
{
    internal var $cx:uint;
    internal var $cy:uint;

    public function Size (cx:uint, cy:uint)
    {
        $cx = cx;
        $cy = cy;
    }

    public final function get cx ():uint
    {
        return $cx;
    }
    public final function get cy ():uint
    {
        return $cy;
    }

    public final function pack (raw:IDataOutput):void
    {
        writeU29 (raw, $cx);
        writeU29 (raw, $cy);
    }
    static public function unpack (raw:IDataInput):Size
    {
        var cx:uint = readU29 (raw);
        var cy:uint = readU29 (raw);
        return new Size (cx, cy);
    }
}
}
