package com.e2et.datalogic
{
import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public class RoomObject extends MetaObject
{
    [Inline]
    static public function packBody (o:RoomObject, raw:IDataOutput):void
    {
        raw.writeByte (o.$stat);
    }
    [Inline]
    static public function unpackBody (o:RoomObject, raw:IDataInput):void
    {
        o.$stat = raw.readByte ();
    }

    public final function get room ():Room
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
            root.addLocalAction (new RoomObjectSetPOC (this, b));
        }
    }
    [Inline]
    public final function purge ():void
    {
        var room:Room = $root;
        if ($id in room.$metaObjects)
            room.addLocalAction (new RoomObjectPurge (this));
    }
    internal function onPurge (room:Room):Boolean
    {
        if ($id in room.$metaObjects)
            return room.delObject (this), true;
        else
            return false;
    }
}
}
