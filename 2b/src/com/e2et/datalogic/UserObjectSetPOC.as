package com.e2et.datalogic
{
import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public class UserObjectSetPOC extends UserActionWithSubject
{
    public function UserObjectSetPOC (obj:UserObject = null, b:Boolean = false)
    {
        $subject = obj;
        _b = b;
    }

    [Inline]
    static internal function packBody (o:UserObjectSetPOC, raw:IDataOutput):void
    {
        UserActionWithSubject.packBody (o, raw);
        raw.writeBoolean (o._b);
    }
    [Inline]
    static internal function unpackBody (o:UserObjectSetPOC, raw:IDataInput):void
    {
        UserActionWithSubject.unpackBody (o, raw);
        o._b = raw.readBoolean ();
    }

    override internal final function onApply (isLocal:Boolean):void
    {
        var obj:UserObject = $subject;
        if (_b)
            obj.$stat |= FLAG_PURGE_ON_CLOSE;
        else
            obj.$stat &= ~FLAG_PURGE_ON_CLOSE;
    }

    private var _b:Boolean;
}
}
