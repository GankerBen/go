package com.e2et.datalogic
{
import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public class MetaAction extends MetaObject
{
    [Inline]
    static internal function packBody (o:MetaAction, raw:IDataOutput):void
    {
        raw.writeUnsignedInt (o.$ts);
    }
    [Inline]
    static internal function unpackBody (o:MetaAction, raw:IDataInput):void
    {
        o.$ts = raw.readUnsignedInt ();
    }

    internal var $ts:uint;

    public final function get ts ():uint
    {
        return $ts;
    }

    [Inline]
    static public function unpack (root:RootObject, raw:IDataInput):*
    {
        var id:uint = raw.readUnsignedInt ();
        var type:uint = raw.readUnsignedInt ();
        if (id != root.$nextActionId)
        {
            throw new Error ('nextActionId 状态不一致');
        }
        root.$nextActionId++;
        if (!(type in _classes))
        {
            throw new Error('未知 UserAction 类型');
        }
        var a:MetaAction = new _classes[type];
        a.$root = root;
        a.$id = id;
        a.unpackBody (raw);
        return a;
    }
    internal function onApply (isLocal:Boolean):void
    {
    }
    internal function onHandled (isLocal:Boolean):void
    {
    }
}
}
