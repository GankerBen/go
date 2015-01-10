package com.e2et.datalogic
{
import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public final class UserUpdateHasMic extends UserAction
{
    public function UserUpdateHasMic (hasMic:Boolean = false)
    {
        _hasMic = hasMic;
    }

    [Inline]
    static internal function packBody (a:UserUpdateHasMic, raw:IDataOutput):void
    {
        UserAction.packBody (a, raw);
        raw.writeBoolean (a._hasMic);
    }
    [Inline]
    static internal function unpackBody (a:UserUpdateHasMic, raw:IDataInput):void
    {
        UserAction.unpackBody (a, raw);
        a._hasMic = raw.readBoolean ();
    }

    private var _hasMic:Boolean;

    override internal function onApply (isLocal:Boolean):void
    {
        user.$hasMic = _hasMic;
    }
}
}
