package com.e2et.datalogic
{
import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public class RoomAddDelAVReq extends RoomAction
{
    public function RoomAddDelAVReq (req:AVReq = null, add:Boolean = true, actor:User = null)
    {
        _req = req;
        _add = add;
        _actor = actor;
    }

    [Inline]
    static internal function packBody (o:RoomAddDelAVReq, raw:IDataOutput):void
    {
        RoomAction.packBody (o, raw);
        raw.writeBoolean (o._add);
        o._req.pack (raw);
        var actor:User = o._actor;
        raw.writeUnsignedInt (actor ? actor.id : 0);
    }
    [Inline]
    static internal function unpackBody (o:RoomAddDelAVReq, raw:IDataInput):void
    {
        var users:Users = o.$root.users;
        RoomAction.unpackBody (o, raw);
        o._add = raw.readBoolean ();
        o._req = AVReq.unpack (raw, users);
        var id:uint, user:User;
        id = raw.readUnsignedInt ();
        o._actor = id == 0 ? null : users.getUser (id);
    }

    private var _req:AVReq;
    private var _add:Boolean;
    private var _actor:User;

    /**
    /**
     * 由于令牌用户离开，房间状态未及时更新，avReq 值可能为 null，表示对应的用户不太房间内了
     */
    public final function get avReq ():AVReq
    {
        return _req;
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
        if (_req == null)
            return;
        var reqs:Vector.<AVReq> = room.avReqs;
        var i:uint, c:uint = reqs.length;
        if (_add)
        {
            for (i=0; i<c; ++i)
            {
                if (reqs[i].equals (_req.$user, _req.$info))
                    return;
            }
            reqs.push (_req);
        }
        else
        {
            for (i=0; i<c; ++i)
            {
                if (reqs[i].equals (_req.$user, _req.$info))
                {
                    reqs.splice (i, 1);
                    return;
                }
            }
        }
    }
}
}
