package com.e2et.datalogic
{
import com.e2et.datalogic.utils.readU29;
import com.e2et.datalogic.utils.writeU29;

import flash.utils.IDataInput;
import flash.utils.IDataOutput;

internal final class UserObjectCreate extends UserAction
{
    public function UserObjectCreate (obj:UserObject = null)
    {
        $subject = obj;
    }

    [Inline]
    static internal function packBody (o:UserObjectCreate, raw:IDataOutput):void
    {
        var obj:UserObject = o.$subject;
        UserAction.packBody (o, raw);

        writeU29 (raw, obj.$id);
        writeU29 (raw, obj.type);
        obj.packBody (raw);
    }
    [Inline]
    static internal function unpackBody (o:UserObjectCreate, raw:IDataInput):void
    {
        var root:RootObject = o.$root, obj:UserObject;
        UserAction.unpackBody (o, raw);

        var id:uint = readU29 (raw);
        if (id != root.$nextObjectId)
        {
            throw new Error ('nextObjectId 状态不一致');
        }
        obj = MetaObject.createObject (readU29 (raw));
        root.addObject (obj);
        obj.unpackBody (raw);
    }

    internal var $subject:*;
}
}
