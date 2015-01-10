package com.e2et.datalogic.utils
{
import flash.utils.IDataOutput;

/**
 * 写入 29 位无符号整数，取值范围 [0, 2^29)
 *
 * @author Bin Tian
 */
public function writeU29 (raw:IDataOutput, v:uint):void
{
    // 写入 7 位
    if (v < 0x80)
        return raw.writeByte (v);
    raw.writeByte (v|0x80);
    v >>= 7;

    // 写入 7 位
    if (v < 0x80)
        return raw.writeByte (v);
    raw.writeByte (v|0x80);
    v >>= 7;

    // 写入 7 位
    if (v < 0x80)
        return raw.writeByte (v);
    raw.writeByte (v|0x80);
    v >>= 7;

    // 写入 8 位
    if (v >= 0x100)
        throw new Error ('bad integer value');
    raw.writeByte (v);
}
}
