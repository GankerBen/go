package com.e2et.datalogic
{
import com.e2et.datalogic.utils.readU29;
import com.e2et.datalogic.utils.writeU29;

import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public class User extends RootObject
{
    internal var $sid:uint;           // SessionID, 唯一标识用户
    internal var $id:uint;            // 房间为用户分配的递增ID
    internal var $level:uint;         // 用户级别
    internal var $userid:String = ''; // 用户id, 由客户端指定
    internal var $name:String = '';   // 用户名称，显示用，由客户端指定

    internal var $hasCam:Boolean = false;
    internal var $hasMic:Boolean = false;
    internal var $avatar:String = '';

    /**
     * 用户打开的视频流，最多支持 127 个
     */
    internal var $streams:Vector.<AVStream>;

    public function User (id:uint, sid:uint)
    {
        $id = id;
        $sid = sid;
    }
    /**
     * 用户会话ID
     */
    public final function get sid ():uint
    {
        return $sid;
    }
    /**
     * 在房间内为用户分配的唯一ID，根据用户进入房间的先后顺序递增，第一个进来的用户为1
     */
    public final function get id ():uint
    {
        return $id;
    }
    /**
     * 用户级别(8bit)，最高位表示用户是否可以获取令牌
     */
    public final function get level ():uint
    {
        return $level;
    }
    public final function get userid ():String
    {
        return $userid;
    }
    public final function get name ():String
    {
        return $name;
    }
    public final function get streams ():Vector.<AVStream>
    {
        return $streams;
    }
    public final function get streamCount ():uint
    {
        return $streams == null ? 0 : $streams.length;
    }
    public final function get hasStream ():Boolean
    {
        return $streams != null && $streams.length > 0;
    }
    public final function get hasCam ():Boolean
    {
        return $hasCam;
    }
    public final function get hasMic ():Boolean
    {
        return $hasMic;
    }
    public final function get avatar ():String
    {
        return $avatar;
    }

    override public function pack (raw:IDataOutput):void
    {
        raw.writeByte ($level);
        raw.writeUnsignedInt ($sid);

        raw.writeUTF ($userid);
        raw.writeUTF ($name);
        raw.writeBoolean ($hasCam);
        raw.writeBoolean ($hasMic);
        super.pack (raw);
        var stms:Vector.<AVStream> = $streams;
        var i:uint, c:uint = stms ? stms.length : 0;
        raw.writeByte (c);
        for (i=0; i<c; ++i)
            writeU29 (raw, stms[i].$id);
    }
    override public function unpack (raw:IDataInput):*
    {
        $level = raw.readByte ();
        $sid = raw.readUnsignedInt ();

        $userid = raw.readUTF ();
        $name = raw.readUTF ();
        $hasCam = raw.readBoolean ();
        $hasMic = raw.readBoolean ();
        super.unpack (raw);
        var i:uint, c:uint = raw.readByte ();
        if (c != 0)
        {
            var stms:Vector.<AVStream> = new Vector.<AVStream>;
            var objs:Object = $metaObjects;
            for (i=0; i<c; ++i)
                stms.push (objs[readU29 (raw)]);
            $streams = stms;
        }
        else
            $streams = null;
        return this;
    }
    /**
     * 打开视频流 - 视频流最多可以有 127 个
     * @param av
     * @return 视频流对象，如果已打开 127 个视频流，则返回 null
     */
    [Inline]
    public final function newAVStream (av:AVItem):AVStream
    {
        if ($streams && $streams.length >= 127)
            return null;
        var stm:AVStream = new AVStream (av);
        addObject (stm);
        addLocalAction (new UserObjectCreate (stm));
        return stm;
    }

    internal final function removeAVStream (stm:AVStream):void
    {
        var stms:Vector.<AVStream> = $streams;
        if (stms != null)
        {
            var i:uint, c:uint = stms.length;
            for (i=0; i<c; ++i)
            {
                if (stms[i] == stm)
                {
                    if (c == 1)
                        $streams = null;
                    else
                        stms.splice (i, 1);
                    return;
                }
            }
        }
    }
}
}
