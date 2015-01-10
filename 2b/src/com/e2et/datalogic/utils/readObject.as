package com.e2et.datalogic.utils {
import flash.utils.ByteArray;
import flash.utils.Endian;
import flash.utils.IDataInput;

public function readObject (raw:IDataInput):* {
    switch (raw.readByte ()) {
    case 0:
        return null;
    case 1:
        return raw.readUTF ();
    case 2:
        return raw.readByte ();
    case 3:
        return raw.readShort ();
    case 4:
        return raw.readInt ();
    case 5:
        return raw.readDouble ();
    case 6:
        return raw.readBoolean ();
    case 7:
        var i:uint, c:uint = readU29 (raw);
        var ar:Array = [];
        for (i=0; i<c; ++i)
            ar.push (readObject (raw));
        return ar;
    case 8:
        c = readU29 (raw);
        var o:Object = { };
        for (i=0; i<c; ++i)
        {
            var k:String = raw.readUTF ();
            o[k] = readObject (raw);
        }
        return o;
    case 9:
        var bytes:ByteArray = new ByteArray;
        bytes.endian = Endian.LITTLE_ENDIAN;
        c = readU29 (raw);
        raw.readBytes (bytes, 0, c);
        bytes.position = 0;
        return bytes;
    default:
        throw new Error ("bad input");
    }
}
}
