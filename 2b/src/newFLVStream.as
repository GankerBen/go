package
{
import com.e2et.utils.LEByteArray;

import flash.net.NetStream;
import flash.net.NetStreamAppendBytesAction;

/**
 * 创建一个 Data Generation Mode 的 NetStream
 * @param type 类型，1表示有视频, 4表示有音频, 5表示音视频都有
 */
public function newFLVStream(type:uint):NetStream
{
    var flv:LEByteArray = new LEByteArray;
    flv.writeUTFBytes("FLV\x01\x05\x00\x00\x00\x09\x00\x00\x00\x00");
    //flv[4] = type;
    var stm:NetStream = new NetStream (fakeNC());
    stm.play(null);
    stm.appendBytes(flv);
    stm.appendBytesAction(NetStreamAppendBytesAction.RESET_SEEK);
    return stm;
}
}
