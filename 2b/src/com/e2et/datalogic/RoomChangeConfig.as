package com.e2et.datalogic
{
import flash.utils.IDataInput;
import flash.utils.IDataOutput;
import com.e2et.datalogic.utils.readObject;
import com.e2et.datalogic.utils.writeObject;

public final class RoomChangeConfig extends RoomAction
{
    public function RoomChangeConfig (name:String = null, value:* = null)
    {
        _name = name;
        _value = value;
    }

    [Inline]
    static internal function packBody (o:RoomChangeConfig, raw:IDataOutput):void
    {
        RoomAction.packBody (o, raw);
        raw.writeUTF (o._name);
        writeObject (raw, o._value);
    }
    [Inline]
    static internal function unpackBody (o:RoomChangeConfig, raw:IDataInput):void
    {
        RoomAction.unpackBody (o, raw);
        o._name = raw.readUTF ();
        o._value = readObject (raw);
    }

    private var _name:String;
    private var _value:*;

    public final function get name ():String
    {
        return _name;
    }
    public final function get value ():*
    {
        return _value;
    }
    override internal function onApply (isLocal:Boolean):void
    {
        var room:Room = $root;
        room.$config.changeConfig (_name, _value);
    }
}
}
