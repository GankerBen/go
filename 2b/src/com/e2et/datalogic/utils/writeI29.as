package com.e2et.datalogic.utils
{
import flash.utils.IDataOutput;

/**
 * 读取 29 位有符号整数, 取值范围是 [-2^28, 2^28)
 *
 * @author Bin Tian
 */
public function writeI29 (raw:IDataOutput, v:int):void
{
    if (v < -268435456 || v >= 268435456)
        throw new Error ('bad integer value');
    if (v < 0)
        v = (-v - 1)*2 + 1;
    else
        v *= 2;

    writeU29 (raw, v);
}
}
