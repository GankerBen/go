package com.e2et.utils
{
import flash.utils.ByteArray;

public class FLVPacket extends ByteArray
{
    /**
     * 不要修改返回的 ByteArray 对象
     */
    [Inline]
    static public function zeroAudioPacket(time:uint):ByteArray
    {
        _zeroAudio.position = 4;
        _zeroAudio.writeUnsignedInt((time<<8) | ((time>>24)&0xff));
        return _zeroAudio;
    }
    /**
     * 不要修改返回的 ByteArray 对象
     */
    [Inline]
    static public function makeFLVPacket (tag:uint, time:uint, pkt:ByteArray, hlen:uint = 4):ByteArray
    {
        var len:uint = pkt.length - hlen;
        _flvPacket.position = 0;
        _flvPacket.writeUnsignedInt((tag<<24) | len);
        _flvPacket.writeUnsignedInt((time<<8) | ((time>>24)&0xff));
        _flvPacket.position = 11;
        _flvPacket.writeBytes(pkt, hlen, len);
        _flvPacket.writeUnsignedInt(len+11);
        _flvPacket.length = len+15;
        return _flvPacket;
    }
}
}
import flash.utils.ByteArray;

var _zeroAudio:ByteArray = zeroFLV(8);
var _flvPacket:ByteArray = zeroFLV(0);

[Inline]
function zeroFLV(tag:uint):ByteArray
{
    var pkt:ByteArray = new ByteArray;
    pkt[0] = tag;
    pkt.position = 11;
    pkt.writeUnsignedInt(11);
    return pkt;
}
