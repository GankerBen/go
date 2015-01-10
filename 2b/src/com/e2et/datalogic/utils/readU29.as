package com.e2et.datalogic.utils
{
import flash.utils.IDataInput;

/**
 * 读取 29 位无符号整数，取值范围 [0, 2^29)
 *
 * @author Bin Tian
 */
public function readU29 (raw:IDataInput):uint
{
    var v:uint, a:uint;
    v = raw.readUnsignedByte ();
    if (v >= 0x80)
    {
        a = raw.readUnsignedByte ();
        v += (a<<7) - 0x80;
        if (a >= 0x80)
        {
            a = raw.readUnsignedByte ();
            v += (a<<14) - 0x4000;
            if (a >= 0x80)
            {
                a = raw.readUnsignedByte ();
                v += (a << 21) - 0x200000;
            }
        }
    }
    return v;
}
}
