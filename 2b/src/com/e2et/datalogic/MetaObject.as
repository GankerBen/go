package com.e2et.datalogic
{
import flash.utils.Dictionary;
import flash.utils.IDataInput;
import flash.utils.IDataOutput;
import flash.utils.getQualifiedClassName;
import flash.utils.getQualifiedSuperclassName;

public class MetaObject
{
    static internal const FLAG_OPEN:uint = 1;
    static internal const FLAG_PURGE:uint = 2;
    static internal const FLAG_PURGE_ON_CLOSE:uint = 4;

    static public const typeKey:String = 'com.e2et.datalogic.MetaObject';
    static internal const _classes:Dictionary = new Dictionary;
    static private var _nextType:uint = 1;

    static internal function register (cls:Class):uint
    {
        if (cls in _classes)
        {
            return _classes[cls];
        }
        var obj:Object = new cls;
        if (!(obj is MetaObject))
        {
            throw new Error (getQualifiedClassName (obj) + ' 未继承 MetaObject 类');
        }

        var type:uint = _nextType++;
        _classes[cls] = type;
        _classes[type] = cls;

        var proto:* = cls.prototype;
        var key:String = MetaObject.typeKey;
        proto[key] = type;
        proto.setPropertyIsEnumerable (key, false);
        return type;
    }

    /**
     * 注册所有对象及动作
     * <p>注册顺序的改变将会导致保存结果的变化</p>
     */
    static public function registerAll ():void
    {
        MetaObject.register (RoomObjectCreate);
        MetaObject.register (RoomObjectPurge);
        MetaObject.register (RoomObjectSetPOC);

        MetaObject.register (UserObjectCreate);
        MetaObject.register (UserObjectPurge);
        MetaObject.register (UserObjectSetPOC);

        MetaObject.register (AVStream);
        MetaObject.register (AVStreamOpen);
        MetaObject.register (AVStreamClose);
        MetaObject.register (AVStreamChangeState);
        MetaObject.register (AVStreamToggleAudio);
        MetaObject.register (AVStreamToggleVideo);

        MetaObject.register (DocDummyTool);
        MetaObject.register (DocSelectionTool);
        MetaObject.register (DocEraserTool);
        MetaObject.register (DocPencilTool);
        MetaObject.register (DocTextTool);

        MetaObject.register (DocLine);
        MetaObject.register (DocLineStart);
        MetaObject.register (DocLineEnd);
        MetaObject.register (DocLineAddPoint);
        MetaObject.register (DocLineUpdate);

        MetaObject.register (DocText);
        MetaObject.register (DocTextChangeText);
        MetaObject.register (DocTextChangePosition);

        MetaObject.register (DocPageObjectToggleSelection);

        MetaObject.register (DocPage);
        MetaObject.register (DocPageGoto);
        MetaObject.register (DocPageSetStepCount);

        MetaObject.register (Document);
        MetaObject.register (DocOpen);
        MetaObject.register (DocClose);
        MetaObject.register (DocSetPageCount);
        MetaObject.register (DocToolChanged);

        MetaObject.register (MediaPlayer);
        MetaObject.register (MediaPlayOpen);
        MetaObject.register (MediaPlayClose);
        MetaObject.register (MediaPlaySeek);
        MetaObject.register (MediaPlayTogglePause);
        MetaObject.register (MediaPlayChangeVolume);

        MetaObject.register (RoomAddDelAVItem);
        MetaObject.register (RoomAddDelAVReq);
        MetaObject.register (RoomChangeConfig);
        MetaObject.register (RoomDeleteConfig);

        MetaObject.register (UserUpdateAvatar);
        MetaObject.register (UserUpdateHasCam);
        MetaObject.register (UserUpdateHasMic);
        MetaObject.register (UserChangeLevel);
    }

    internal var $id:uint;
    internal var $root:*; // RootObject
    internal var $stat:uint;

    public final function get id ():uint
    {
        return $id;
    }
    public final function get type ():uint
    {
        return this[typeKey];
    }
    internal final function get root ():RootObject
    {
        return $root;
    }
    public final function get isOpened ():Boolean
    {
        return ($stat & FLAG_OPEN) != 0;
    }
    public final function get isPurged ():Boolean
    {
        return ($stat & FLAG_PURGE) != 0;
    }
    public final function get isValid ():Boolean
    {
        return ($stat & (FLAG_OPEN|FLAG_PURGE)) == FLAG_OPEN;
    }

    [Inline]
    static internal function createObject (type:uint):*
    {
        return new _classes[type];
    }
    [Inline]
    public final function packHead (raw:IDataOutput):void
    {
        raw.writeUnsignedInt ($id);
        raw.writeUnsignedInt (type);
    }
    [Inline]
    public final function packBody (raw:IDataOutput):void
    {
        this['constructor'].packBody (this, raw);
    }
    [Inline]
    public final function unpackBody (raw:IDataInput):void
    {
        this['constructor'].unpackBody (this, raw);
    }
    [Inline]
    static internal function refObject (o:MetaObject, raw:IDataOutput):void
    {
        raw.writeUnsignedInt (o ? o.$id : 0);
    }
    [Inline]
    static internal function derefObject (root:RootObject, raw:IDataInput):*
    {
        var id:uint = raw.readUnsignedInt ();
        return id ? root.$metaObjects[id] : null;
    }
}
}