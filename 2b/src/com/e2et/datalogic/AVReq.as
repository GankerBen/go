package com.e2et.datalogic
{
import flash.utils.IDataInput;
import flash.utils.IDataOutput;
import com.e2et.datalogic.utils.readObject;
import com.e2et.datalogic.utils.writeObject;

public final class AVReq
{
    internal var $user:User;
    internal var $info:*;

    public function AVReq (user:User, info:* = null)
    {
        $user = user;
        $info = info;
    }
    public final function get user ():User
    {
        return $user;
    }
    public final function get info ():*
    {
        return $info;
    }
    [Inline]
    public final function equals (user:User, info:*):Boolean
    {
        return $user === user && equal ($info, info);
    }
    [Inline]
    public final function pack (raw:IDataOutput):void
    {
        raw.writeUnsignedInt ($user.id);
        writeObject (raw, info);
    }
    [Inline]
    static public function unpack (raw:IDataInput, users:Users):AVReq
    {
        var id:uint = raw.readUnsignedInt (), user:User;
        user = users.getUser (id);
        var info:* = readObject (raw);
        return user ? new AVReq (user, info) : null;
    }
}
}
