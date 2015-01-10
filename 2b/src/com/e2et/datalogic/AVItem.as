package com.e2et.datalogic
{
import flash.utils.IDataInput;
import flash.utils.IDataOutput;
import com.e2et.datalogic.utils.readObject;
import com.e2et.datalogic.utils.writeObject;

public final class AVItem
{
    internal var $user:User;
    internal var $avid:uint;
    internal var $info:*;

    public function AVItem (user:User, avid:uint, info:* = null)
    {
        $user = user;
        $avid = avid;
        $info = info;
    }
    public final function get user ():User
    {
        return $user;
    }
    public final function get avid ():uint
    {
        return $avid;
    }
    public final function get info ():*
    {
        return $info;
    }

    public final function pack (raw:IDataOutput):void
    {
        raw.writeUnsignedInt ($user.id);
        raw.writeUnsignedInt ($avid);
        writeObject (raw, $info);
    }
    [Inline]
    static public function unpack (raw:IDataInput, users:Users):AVItem
    {
        var id:uint, user:User, avid:uint, info:*;
        id = raw.readUnsignedInt ();
        user = users.getUser (id);
        avid = raw.readUnsignedInt ();
        info = readObject (raw);
        return user ? new AVItem (user, avid, info) : null;
    }
}
}
