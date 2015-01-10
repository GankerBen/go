package com.e2et.datalogic
{
import com.e2et.datalogic.utils.readU29;
import com.e2et.datalogic.utils.writeU29;

import flash.utils.IDataInput;
import flash.utils.IDataOutput;
import flash.utils.getQualifiedClassName;
import flash.utils.getTimer;

public class RootObject
{
    internal var $nextActionId:uint = 1;
    internal var $nextObjectId:uint = 1;
    internal var $metaObjects:Object = { };
    internal var $dirty:uint = 0;

    private const handlers:Vector.<IMetaActionHandler> = new Vector.<IMetaActionHandler>;

    private var _handlerOn:Boolean = true;

    [Inline]
    public final function get dirty ():Boolean
    {
        return $dirty > 0;
    }
    [Inline]
    public final function undirty ():void
    {
        $dirty = 0;
    }
    [Inline]
    public final function get nextActionId ():uint
    {
        return $nextActionId;
    }
    [Inline]
    public final function get nextObjectId ():uint
    {
        return $nextObjectId;
    }
    [Inline]
    public final function isNewBorn ():Boolean
    {
        return $nextActionId == 1;
    }
    [Inline]
    public final function addHandler (handler:IMetaActionHandler):void
    {
        var v:Vector.<IMetaActionHandler> = handlers;
        if (v.indexOf (handler) < 0)
            v.push (handler);
    }
    [Inline]
    public final function delHandler (handler:IMetaActionHandler):void
    {
        var i:int, v:Vector.<IMetaActionHandler> = handlers;
        if ((i = v.indexOf (handler)) >= 0)
            v.splice (i, 1);
    }
    [Inline]
    public final function addRawAction (raw:IDataInput):*
    {
        var a:*;
        handleAction (a = MetaAction.unpack (this, raw), false);
        return a;
    }
    [Inline]
    internal final function addLocalAction (a:MetaAction):void
    {
        a.$id = $nextActionId++;
        a.$ts = getTimer ();
        a.$root = this;
        ++$dirty;
        handleAction (a, true);
    }
    [Inline]
    public final function handlerOff ():void
    {
        _handlerOn = false;
    }
    [Inline]
    public final function handlerOn ():void
    {
        _handlerOn = true;
    }
    [Inline]
    internal final function handleAction (a:MetaAction, isLocal:Boolean):void
    {
        var v:Vector.<IMetaActionHandler> = handlers;
        var i:uint, c:uint = v.length;

        a.onApply (isLocal);
        if (_handlerOn)
        {
            for (i=0; i<c; ++i)
                v[i].handleMetaAction (a, isLocal);
        }
        a.onHandled (isLocal);
    }

    [Inline]
    internal final function addObject (o:MetaObject):void
    {
        if (!o.type)
        {
            throw new Error ('未注册对象类别 ' + getQualifiedClassName(o));
        }
        var id:uint = $nextObjectId++;
        o.$root = this;
        $metaObjects[o.$id = id] = o;
    }
    [Inline]
    internal final function delObject (o:MetaObject):void
    {
        var id:uint = o.$id;
        if (id in $metaObjects)
            delete $metaObjects[id];
    }

    public function pack (raw:IDataOutput):void
    {
        raw.writeUnsignedInt ($nextActionId);
        raw.writeUnsignedInt ($nextObjectId);

        // 先写入 n 个 <id, type>
        var objs:Vector.<MetaObject> = new Vector.<MetaObject>;
        for each (var o:* in $metaObjects)
        {
            objs.push (o);
        }
        objs.sort (function (a:MetaObject, b:MetaObject):int {
            return a.$id - b.$id;
        });
        var i:uint, c:uint = objs.length;
        writeU29 (raw, c);
        for (i=0; i<c; ++i)
        {
            var mo:MetaObject = objs[i];
            writeU29 (raw, mo.$id);
            writeU29 (raw, mo.type);
        }

        // 写入 n 个 UserObject
        for (i=0; i<c; ++i)
        {
            mo = objs[i];
            mo.packBody (raw);
        }
    }
    public function unpack (raw:IDataInput):*
    {
        $nextActionId = raw.readUnsignedInt();
        $nextObjectId = raw.readUnsignedInt ();

        var objs:Vector.<MetaObject> = new Vector.<MetaObject>, newObjs:Object = { };
        // 读取 n 个 <id, type> 直到读到结束符
        var i:uint, c:uint = readU29 (raw);
        var id:uint, type:uint;
        for (i=0; i<c; ++i)
        {
            id = readU29 (raw);
            type = readU29 (raw);
            var uo:MetaObject = $metaObjects[id];
            if (uo == null || uo.type != type)
            {
                uo = MetaObject.createObject (type);
                uo.$id = id;
                uo.$root = this;
            }
            objs.push (newObjs[id] = uo);
        }

        // 读取 n 个 UserObject
        $metaObjects = newObjs;
        for (i=0; i<c; ++i)
        {
            uo = objs[i];
            uo.unpackBody (raw);
        }
        return this;
    }
}
}
