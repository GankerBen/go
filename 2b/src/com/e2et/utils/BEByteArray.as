package com.e2et.utils
{
import flash.net.ObjectEncoding;
import flash.utils.ByteArray;
import flash.utils.Endian;

/**
 * 大端 ByteArray
 * @author Bin Tian
 */
public class BEByteArray extends ByteArray
{
    public function BEByteArray()
    {
        super();
        this.endian = Endian.BIG_ENDIAN;
        this.objectEncoding = ObjectEncoding.AMF3;
    }
}
}
