package com.e2et.datalogic
{
import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public class UserChangeLevel extends UserAction
{
    public function UserChangeLevel (level:uint = 0)
    {
        _level = level;
    }

    [Inline]
    static internal function packBody (a:UserChangeLevel, raw:IDataOutput):void
    {
        UserAction.packBody (a, raw);
        raw.writeByte (a._level);
    }
    [Inline]
    static internal function unpackBody (a:UserChangeLevel, raw:IDataInput):void
    {
        UserAction.unpackBody (a, raw);
        a._level = raw.readByte ();
    }

    private var _level:uint;

    override internal function onApply (isLocal:Boolean):void
    {
        user.$level = _level;
    }
}
}
