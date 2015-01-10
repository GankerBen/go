package com.e2et.datalogic
{
import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public final class RoomAddDelAVItem extends RoomAction
{
    public function RoomAddDelAVItem (item:AVItem = null, add:Boolean = false, actor:User = null)
    {
        _item = item;
        _add = add;
        _actor = actor;
        if (add && item.$avid == 0)
            item.$avid = next ();
    }

    [Inline]
    static internal function packBody (o:RoomAddDelAVItem, raw:IDataOutput):void
    {
        var q:AVItem = o._item, a:User = o._actor;
        RoomAction.packBody (o, raw);
        raw.writeBoolean (o._add);
        o._item.pack (raw);
        raw.writeUnsignedInt (a ? a.id : 0);
    }
    [Inline]
    static internal function unpackBody (o:RoomAddDelAVItem, raw:IDataInput):void
    {
        var users:Users = o.$root.users, user:User, id:uint;
        var q:AVItem = o._item;
        RoomAction.unpackBody (o, raw);
        o._add = raw.readBoolean ();
        o._item = AVItem.unpack (raw, users);
        id = raw.readUnsignedInt ();
        o._actor = id == 0 ? null : users.getUser (id);
    }

    private var _item:AVItem;
    private var _add:Boolean;
    private var _actor:User;

    /**
     * 由于令牌用户离开，房间状态未及时更新，item 值可能为 null，表示对应的用户不太房间内了
     */
    public final function get item ():AVItem
    {
        return _item;
    }
    public final function get add ():Boolean
    {
        return _add;
    }
    public final function get actor ():User
    {
        return _actor;
    }

    override internal function onApply (isLocal:Boolean):void
    {
        if (_item == null)
            return;
        var items:Vector.<AVItem> = room.avList;
        var i:uint, c:uint = items.length;
        var user:User = _item.$user;
        var avid:uint = _item.$avid;
        for (i=0; i<c; ++i)
        {
            var item:AVItem = items[i];
            if (item.$user == user && item.$avid == avid)
            {
                if (!_add)
                    items.splice (i, 1);
                return;
            }
        }
        if (_add)
        {
            idset [avid] = true;
            items.push (new AVItem (user, avid, _item.info));
        }
    }

    static private var idset:Object = { };
    static private function next ():uint
    {
        do
        {
            var id:uint = Math.floor (Math.random () * 900000) + 100000;
        } while (id in idset);
        idset [id] = true;
        return id;
    }
}
}
