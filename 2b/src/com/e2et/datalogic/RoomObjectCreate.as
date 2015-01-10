package com.e2et.datalogic
{
import com.e2et.datalogic.utils.readU29;
import com.e2et.datalogic.utils.writeU29;

import flash.utils.IDataInput;
import flash.utils.IDataOutput;

internal final class RoomObjectCreate extends RoomAction
{
    public function RoomObjectCreate (obj:RoomObject = null)
    {
        _obj = obj;
    }

    [Inline]
    static internal function packBody (o:RoomObjectCreate, raw:IDataOutput):void
    {
        var obj:RoomObject = o._obj;
        RoomAction.packBody (o, raw);

        writeU29 (raw, obj.$id);
        writeU29 (raw, obj.type);
        obj.packBody (raw);
    }
    [Inline]
    static internal function unpackBody (o:RoomObjectCreate, raw:IDataInput):void
    {
        var root:RootObject = o.$root, obj:RoomObject;
        RoomAction.unpackBody (o, raw);

        var id:uint = readU29 (raw);
        if (id != root.$nextObjectId)
        {
            throw new Error ('nextObjectId 状态不一致');
        }
        obj = MetaObject.createObject (readU29 (raw));
        root.addObject (obj);
        obj.unpackBody (raw);
    }

    private var _obj:RoomObject;
}
}
