package com.e2et.datalogic
{
import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public class UserObject extends MetaObject
{
    [Inline]
    static public function packBody (o:UserObject, raw:IDataOutput):void
    {
        raw.writeByte (o.$stat);
    }
    [Inline]
    static public function unpackBody (o:UserObject, raw:IDataInput):void
    {
        o.$stat = raw.readByte ();
    }

    public final function get user ():User
    {
        return $root;
    }
    public final function get purgeOnClose ():Boolean
    {
        return ($stat & FLAG_PURGE_ON_CLOSE) != 0;
    }
    public final function set purgeOnClose (b:Boolean):void
    {
        var root:RootObject = $root;
        if ($id in $root.$metaObjects)
        {
            root.addLocalAction (new UserObjectSetPOC (this, b));
        }
    }
    [Inline]
    public final function purge ():void
    {
        var user:User = $root;
        if ($id in user.$metaObjects)
            user.addLocalAction (new UserObjectPurge (this));
    }
    internal function onPurge (user:User):Boolean
    {
        if ($id in user.$metaObjects)
            return user.delObject (this), true;
        else
            return false;
    }
}
}
