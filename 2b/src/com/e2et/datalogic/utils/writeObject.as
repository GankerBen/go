package com.e2et.datalogic.utils {
import flash.utils.ByteArray;
import flash.utils.IDataOutput;

public function writeObject (raw:IDataOutput, obj:*):void {
    if (obj == null)
        return raw.writeByte (0);
    switch (obj['constructor']) {
    case String:
        raw.writeByte (1);
        raw.writeUTF (obj);
        break;
    case int:
    case uint:
        raw.writeByte (4);
        raw.writeInt (obj);
        break;
    case Number:
        raw.writeByte (5);
        raw.writeDouble (obj);
        break;
    case Boolean:
        raw.writeByte (6);
        raw.writeBoolean (obj);
        break;
    case Array:
        var ar:Array = obj;
        raw.writeByte (7);
        writeU29 (raw, ar.length);
        var i:uint, c:uint = ar.length;
        for (i=0; i<c; ++i) {
            writeObject (raw, ar[i]);
        }
        break;
    case Object:
        ar = [];
        for (var k:String in obj) {
            ar.push (k);
        }
        raw.writeByte (8);
        writeU29 (raw, c = ar.length);
        for (i=0; i<c; ++i) {
            raw.writeUTF (ar[i]);
            writeObject (raw, obj[ar[i]]);
        }
        break;
    default:
        if (obj is ByteArray) {
            var bytes:ByteArray = obj;
            raw.writeByte (9);
            var len:uint = bytes.length - bytes.position;
            writeU29 (raw, len);
            raw.writeBytes (bytes, bytes.position, len);
            break;
        }
        throw new Error ("unsupported data type");
    }
    return;
}
}
