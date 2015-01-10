package com.e2et.datalogic
{
import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public final class RoomDeleteConfig extends RoomAction
{
    public function RoomDeleteConfig (name:String = null)
    {
        _name = name;
    }

    [Inline]
    static internal function packBody (o:RoomDeleteConfig, raw:IDataOutput):void
    {
        RoomAction.packBody (o, raw);
        raw.writeUTF (o._name);
    }
    [Inline]
    static internal function unpackBody (o:RoomDeleteConfig, raw:IDataInput):void
    {
        RoomAction.unpackBody (o, raw);
        o._name = raw.readUTF ();
    }

    private var _name:String;

    public final function get name ():String
    {
        return _name;
    }
    override internal function onApply (isLocal:Boolean):void
    {
        var room:Room = $root;
        room.$config.deleteConfig (_name);
    }
}
}
