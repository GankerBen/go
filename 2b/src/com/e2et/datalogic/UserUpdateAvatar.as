package com.e2et.datalogic
{
import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public final class UserUpdateAvatar extends UserAction
{
    public function UserUpdateAvatar (avatar:String = '')
    {
        _avatar = avatar is String ? avatar : '';
    }

    [Inline]
    static internal function packBody (a:UserUpdateAvatar, raw:IDataOutput):void
    {
        UserAction.packBody (a, raw);
        raw.writeUTF (a._avatar);
    }
    [Inline]
    static internal function unpackBody (a:UserUpdateAvatar, raw:IDataInput):void
    {
        UserAction.unpackBody (a, raw);
        a._avatar = raw.readUTF ();
    }

    private var _avatar:String;

    override internal function onApply (isLocal:Boolean):void
    {
        user.$avatar = _avatar;
    }
}
}