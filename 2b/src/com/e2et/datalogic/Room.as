package com.e2et.datalogic
{
import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public class Room extends RootObject
{
    static public const version:uint = 0x10000;

    private var _version:uint = Room.version;
    protected var _app:String;
    protected var _org:String;
    protected var _id:String;
    protected var _localUser:LocalUser;
    protected var _tokenUser:User;

    /**
     * 房间内所有的用户，按进入房间的顺序排列
     */
    public const users:Users = new Users;

    /**
     * 用户的视频申请列表，按申请先后顺序排列，最多 127 个
     */
    public const avReqs:Vector.<AVReq> = new Vector.<AVReq>;

    /**
     * 房间内打开的视频列表，按先后顺序排列，最多 127 个
     */
    public const avList:Vector.<AVItem> = new Vector.<AVItem>;

    /**
     * 房间内正在播放的 mp3/mp4 列表，按先后顺序排列，最多 127 个
     */
    public const mediaPlayers:Vector.<MediaPlayer> = new Vector.<MediaPlayer>;

    /**
     * 当前打开的文档，如果没有则为 null
     */
    internal var $doc:Document;

    /**
     * 房间设置信息
     */
    internal var $config:RoomConfig;

    public function Room (roomid:String, org:String, app:String = 'e2et')
    {
        _id = roomid;
        _org = org;
        _app = app;
        $config = new RoomConfig (this);
    }

    public final function get version ():uint
    {
        return _version;
    }
    public final function get app ():String
    {
        return _app;
    }
    public final function get org ():String
    {
        return _org;
    }
    /**
     * 房间ID
     */
    public final function get id ():String
    {
        return _id;
    }
    /**
     * 本地用户 - 从第一人称角度来讲，就是`我`
     */
    public final function get user ():LocalUser
    {
        return _localUser;
    }
    /**
     * 持有令牌的用户，如果没有人执有令牌，则为 null
     */
    public final function get tokenUser ():User
    {
        return _tokenUser;
    }
    /**
     * 房间内当前打开的文档，如果没有则为 null
     */
    public final function get doc ():Document
    {
        return $doc;
    }
    /**
     * 房间设置信息
     */
    public final function get config ():RoomConfig
    {
        return $config;
    }

    override public final function pack (raw:IDataOutput):void
    {
        raw.writeUnsignedInt (Room.version);

        super.pack (raw);

        raw.writeUTF (_app);
        raw.writeUTF (_org);
        raw.writeUTF (_id);

        $config.pack (raw);

        var i:uint, c:uint;

        var reqs:Vector.<AVReq> = avReqs;
        raw.writeByte (c = reqs.length);
        for (i=0; i<c; ++i)
            reqs[i].pack (raw);

        var items:Vector.<AVItem> = avList;
        raw.writeByte (c = items.length);
        for (i=0; i<c; ++i)
            items[i].pack (raw);

        var mps:Vector.<MediaPlayer> = mediaPlayers;
        raw.writeByte (c = mps.length);
        for (i=0; i<c; ++i)
            raw.writeUnsignedInt (mps[i].$id);

        raw.writeUnsignedInt ($doc is Document ? $doc.$id : 0);
    }
    override public final function unpack (raw:IDataInput):*
    {
        var i:uint, c:uint, user:User;

        _version = raw.readUnsignedInt ();

        super.unpack (raw);

        _app = raw.readUTF ();
        _org = raw.readUTF ();
        _id = raw.readUTF ();

        $config.unpack (raw);

        var reqs:Vector.<AVReq> = avReqs;
        reqs.length = 0;
        c = raw.readByte ();
        for (i=0; i<c; ++i)
        {
            var req:AVReq = AVReq.unpack (raw, users);
            if (req != null)
                reqs.push (req);
        }

        var items:Vector.<AVItem> = avList;
        items.length = 0;
        c = raw.readByte ();
        for (i=0; i<c; ++i)
        {
            var item:AVItem = AVItem.unpack (raw, users);
            if (item != null)
                items.push (item);
        }

        var mps:Vector.<MediaPlayer> = mediaPlayers;
        mps.length = 0;
        c = raw.readByte ();
        for (i=0; i<c; ++i)
            mps.push ($metaObjects[raw.readUnsignedInt ()]);

        $doc = $metaObjects[raw.readUnsignedInt ()];
        return this;
    }

    /**
     * 添加用户视频申请
     */
    [Inline]
    public final function addAVReq (user:User, info:*):void
    {
        var reqs:Vector.<AVReq> = avReqs;
        var i:uint, c:uint = reqs.length;
        if (c >= 127)
            return;
        for (i=0; i<c; ++i)
        {
            if (reqs[i].equals (user, info))
                return;
        }
        addLocalAction (new RoomAddDelAVReq (new AVReq (user, info), true));
    }
    /**
     * 删除用户视频申请。删除者为 actor
     * @param req
     * @param actor 动作执行者，如果为 null 则为当前用户
     */
    [Inline]
    public final function delAVReq (req:AVReq, actor:User = null):void
    {
        if (actor == null)
            actor = _localUser;
        var reqs:Vector.<AVReq> = avReqs;
        var i:uint, c:uint = reqs.length;
        for (i=0; i<c; ++i)
        {
            if (reqs[i] == req)
            {
                addLocalAction (new RoomAddDelAVReq (req, false, actor));
                return;
            }
        }
    }
    [Inline]
    public final function delAVReqByUser (user:User):void
    {
        var reqs:Vector.<AVReq> = avReqs;
        var c:uint = reqs.length, cnt:uint = 0;
        while (c--)
        {
            var req:AVReq = reqs[c];
            if (req.user === user)
                reqs.splice (c, 1), ++cnt;
        }
        if (cnt > 0)
            handleAction (new RoomAVReqsChanged (this), false);
    }
    /**
     * 添加用户视频。动作执行者为 actor
     * @param user
     * @param info
     * @param actor 动作执行者，如果为 null 则为当前用户
     */
    [Inline]
    public final function addAVItem (user:User, info:*, actor:User = null):void
    {
        if (avList.length >= 127)
            return;
        if (actor == null)
            actor = _localUser;
        addLocalAction (new RoomAddDelAVItem (new AVItem (user, 0, info), true, actor));
    }
    /**
     * 删除用户视频。动作执行者为 actor
     * @param item
     * @param actor 动作执行者，如果为 null 则为当前用户
     */
    [Inline]
    internal final function delAVItem (item:AVItem, actor:User = null):void
    {
        var items:Vector.<AVItem> = avList;
        var i:uint, c:uint = items.length;
        for (i=0; i<c; ++i)
        {
            if (items[i] == item)
            {
                addLocalAction (new RoomAddDelAVItem (item, false, actor));
                return;
            }
        }
    }
    public final function delAVItemByUser (user:User):void
    {
        var items:Vector.<AVItem> = avList;
        var c:uint = items.length, cnt:uint = 0;
        while (c--)
        {
            var item:AVItem = items[c];
            if (item.user === user)
                items.splice (c, 1), ++cnt;
        }
        if (cnt > 0)
            handleAction (new RoomAVListChanged (this), false);
    }
    /**
     * 播放媒体文件 - 最多可同时 127 个媒体文件
     * @param file
     * @param mediaInfo
     * @return MediaPlayer 对象，如果播放的媒体文件过多，则返回 null
     */
    [Inline]
    public final function newMediaPlayer (file:String, mediaInfo:* = null):MediaPlayer
    {
        if (mediaPlayers.length >= 127)
            return null;
        var mp:MediaPlayer = new MediaPlayer (file, mediaInfo);
        addObject (mp);
        addLocalAction (new RoomObjectCreate (mp));
        return mp;
    }
    public final function newDocument (name:String, uri:String, docInfo:* = null):Document
    {
        var doc:Document;
        for each (var o:* in $metaObjects)
        {
            if ((doc = o as Document) != null)
            {
                if (doc.$name == name && doc.$uri == uri)
                    return doc;
            }
        }
        doc = new Document (name, uri, docInfo);
        addObject (doc);
        addLocalAction (new RoomObjectCreate (doc));
        return doc;
    }
    public final function newDocDummyTool ():DocDummyTool
    {
        var tool:DocDummyTool;
        for each (var o:* in $metaObjects)
        {
            if ((tool = o as DocDummyTool) != null)
                return tool;
        }
        addObject (tool = new DocDummyTool);
        addLocalAction (new RoomObjectCreate (tool));
        return tool;
    }
    public final function newDocSelectionTool ():DocSelectionTool
    {
        var tool:DocSelectionTool;
        for each (var o:* in $metaObjects)
        {
            if ((tool = o as DocSelectionTool) != null)
                return tool;
        }
        addObject (tool = new DocSelectionTool);
        addLocalAction (new RoomObjectCreate (tool));
        return tool;
    }
    public final function newDocEraserTool ():DocEraserTool
    {
        var tool:DocEraserTool;
        for each (var o:* in $metaObjects)
        {
            if ((tool = o as DocEraserTool) != null)
                return tool;
        }
        addObject (tool = new DocEraserTool);
        addLocalAction (new RoomObjectCreate (tool));
        return tool;
    }
    /**
     * 新建画笔工具，如果有相同设置的画笔工具存在，则返回已存在的画笔工具
     */
    public final function newDocPencilTool (color:uint, style:uint, alpha:Number, thickness:uint):DocPencilTool
    {
        var pen:DocPencilTool;
        for each (var o:* in $metaObjects)
        {
            if ((pen = o as DocPencilTool) != null)
            {
                if (pen.$color != color || pen.$style != style)
                    continue;
                if (pen.$alpha != alpha || pen.$thickness != thickness)
                    continue;
                return pen;
            }
        }
        addObject (pen = new DocPencilTool (color, style, alpha, thickness));
        addLocalAction (new RoomObjectCreate (pen));
        return pen;
    }
    /**
     * 新建文本工具，如果有相同设置的文本工具存在，则返回已存在的文本工具
     */
    public final function newDocTextTool (color:uint, alpha:Number, font:String):DocTextTool
    {
        var tool:DocTextTool;
        for each (var o:* in $metaObjects)
        {
            if ((tool = o as DocTextTool) != null)
            {
                if (tool.$color != color || tool.$alpha != alpha)
                    continue;
                if (tool.$font != font)
                    continue;
                return tool;
            };
        }
        addObject (tool = new DocTextTool (color, alpha, font));
        addLocalAction (new RoomObjectCreate (tool));
        return tool;
    }

    /**
     * 本地用户 - 从第一人称角度来讲，就是`我`
     */
    public final function get localUser ():LocalUser
    {
        return _localUser;
    }
    /**
     * 本地用户 - 从第一人称角度来讲，就是`我`
     */
    public final function set localUser (u:LocalUser):void
    {
        _localUser = u;
    }

    public final function init (users:Vector.<User>, id:uint):void
    {
        if (_localUser == null)
            throw new Error ('bad sequence');
        this.users.init (users);
        _localUser._init (id);
        this.users.addUser (_localUser);
    }
    public final function set tokenUser (u:User):void
    {
        _tokenUser = u;
    }
    public final function userIn (u:User):void
    {
        users.addUser (u);
    }
    public final function userOut (u:User):User
    {
        var i:uint, c:uint;
        u = users.delUser (u.$id);
        delAVReqByUser (u);
        delAVItemByUser (u);
        return u;
    }
    public final function get hasToken ():Boolean
    {
        return _tokenUser is LocalUser;
    }
}
}
