package com.e2et.datalogic
{
import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public final class UserUpdateHasCam extends UserAction
{
    public function UserUpdateHasCam (hasCam:Boolean = false)
    {
        _hasCam = hasCam;
    }

    [Inline]
    static internal function packBody (a:UserUpdateHasCam, raw:IDataOutput):void
    {
        UserAction.packBody (a, raw);
        raw.writeBoolean (a._hasCam);
    }
    [Inline]
    static internal function unpackBody (a:UserUpdateHasCam, raw:IDataInput):void
    {
        UserAction.unpackBody (a, raw);
        a._hasCam = raw.readBoolean ();
    }

    private var _hasCam:Boolean;

    override internal function onApply (isLocal:Boolean):void
    {
        user.$hasCam = _hasCam;
    }
}
}
