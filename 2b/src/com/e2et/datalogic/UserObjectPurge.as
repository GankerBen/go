package com.e2et.datalogic
{
import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public final class UserObjectPurge extends UserActionWithSubject
{
    public function UserObjectPurge (obj:UserObject = null)
    {
        $subject = obj;
    }
    [Inline]
    static internal function packBody (o:UserObjectPurge, raw:IDataOutput):void
    {
        UserActionWithSubject.packBody (o, raw);
    }
    [Inline]
    static internal function unpackBody (o:UserObjectPurge, raw:IDataInput):void
    {
        UserActionWithSubject.unpackBody (o, raw);
    }
    override internal final function onApply (isLocal:Boolean):void
    {
        var obj:UserObject = $subject;
        obj.onPurge ($root);
    }
}
}
