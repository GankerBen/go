package 
{
import flash.net.ObjectEncoding;
import flash.utils.ByteArray;
import flash.utils.Endian;

/**
 * 小端 ByteArray
 * @author Bin Tian
 */
public class LEByteArray extends ByteArray
{
    public function LEByteArray()
    {
        super();
        this.endian = Endian.LITTLE_ENDIAN;
        this.objectEncoding = ObjectEncoding.AMF3;
    }
}
}
