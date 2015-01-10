package com.e2et.datalogic.utils
{
import flash.utils.IDataInput;
/**
 * 读取 29 位有符号整数, 取值范围是 [-2^28, 2^28)
 *
 * @author Bin Tian
 */
public function readI29 (raw:IDataInput):int
{
    var v:int = readU29 (raw);
    if (v & 1)
        return -1 - (v>>1);
    else
        return v>>1;
}
}
