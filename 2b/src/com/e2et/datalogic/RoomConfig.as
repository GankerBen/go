package com.e2et.datalogic
{
import com.e2et.datalogic.utils.readObject;
import com.e2et.datalogic.utils.readU29;
import com.e2et.datalogic.utils.writeObject;
import com.e2et.datalogic.utils.writeU29;

import flash.utils.IDataInput;
import flash.utils.IDataOutput;
import flash.utils.Proxy;
import flash.utils.flash_proxy;

dynamic public final class RoomConfig extends Proxy
{
    private var _room:Room;
    private const _names:Array = [], _values:Array = [];

    public function RoomConfig (room:Room)
    {
        _room = room;
    }
    public function pack (raw:IDataOutput):void
    {
        var i:uint, c:uint;
        writeU29 (raw, c = _names.length);
        for (i=0; i<c; ++i)
        {
            raw.writeUTF (_names[i]);
            writeObject (raw, _values[i]);
        }
    }
    public function unpack (raw:IDataInput):void
    {
        _names.length = 0;
        _values.length = 0;
        var i:uint, c:uint = readU29 (raw);
        for (i=0; i<c; ++i)
        {
            _names.push (raw.readUTF ());
            _values.push (readObject (raw));
        }
    }
    internal function changeConfig (name:String, value:*):void
    {
        var i:int = _names.indexOf (name);
        if (i < 0)
        {
            _names.push (name);
            _values.push (value);
        }
        else
            _values[i] = value;
    }
    internal function deleteConfig (name:String):void
    {
        var i:int = _names.indexOf (name);
        if (i >= 0)
        {
            _names.splice (i, 1);
            _values.splice (i, 1);
        }
    }
    override flash_proxy function setProperty (name:*, value:*):void
    {
        var q:QName = name as QName;
        if (q != null)
            name = q.localName;
        _room.addLocalAction (new RoomChangeConfig (name, value));
    }
    override flash_proxy function getProperty (name:*):*
    {
        var q:QName = name as QName;
        if (q != null)
            name = q.localName;
        var i:int = _names.indexOf (name);
        if (i < 0)
            return;
        else
            return _values[i];
    }
    override flash_proxy function hasProperty (name:*):Boolean
    {
        var q:QName = name as QName;
        if (q != null)
            name = q.localName;
        return _names.indexOf (name) >= 0;
    }
    override flash_proxy function deleteProperty (name:*):Boolean
    {
        var q:QName = name as QName;
        if (q != null)
            name = q.localName;
        var i:int = _names.indexOf (name);
        if (i < 0)
            return false;
        _room.addLocalAction (new RoomDeleteConfig (name));
        return true;
    }
    override flash_proxy function nextNameIndex (index:int):int
    {
        if (index < _names.length)
            return index + 1;
        else
            return 0;
    }
    override flash_proxy function nextName (index:int):String
    {
        return _names[index-1];
    }
    override flash_proxy function nextValue (index:int):*
    {
        return _values[index-1];
    }
}
}
