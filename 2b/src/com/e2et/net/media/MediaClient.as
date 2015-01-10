package com.e2et.net.media
{
import com.e2et.ISession;
import com.e2et.Session;
import com.e2et.datalogic.AVStream;
import com.e2et.datalogic.Room;
import com.e2et.datalogic.User;
import com.e2et.net.NetClient;
import com.e2et.utils.LEByteArray;

import flash.utils.ByteArray;

[ExcludeClass]
public class MediaClient extends NetClient implements IMediaClient
{
    protected var _avstm:AVStream;

    protected var _audioOn:Boolean = false;
    protected var _videoOn:Boolean = false;

    protected var _logTag:String;
    public var remoteAddr:String;

    public function MediaClient ($:Session, avstm:AVStream)
    {
        super ($);
        _avstm = avstm;
        _logTag = '媒体[' + name + ']: ';
    }
    public function get session ():ISession
    {
        return $;
    }
    public final function get name ():String
    {
        return _avstm.name;
    }
    public final function get avstm ():AVStream
    {
        return _avstm;
    }
    override public final function get key ():String
    {
        var v:uint = _avstm.avid * 0x9e370001 / 1048576;
        return v.toString();
    }
    protected final function get streamName():String
    {
        return [$.room.org, $.room.id, _avstm.name].join('%');
    }
    override protected final function get logTag ():String
    {
        return _logTag;
    }
    public function get audioOn ():Boolean
    {
        return _audioOn;
    }
    public function get videoOn ():Boolean
    {
        return _videoOn;
    }
    public function set audioOn (on:Boolean):void
    {
        throw new Error ('please override me!');
    }
    public function set videoOn (on:Boolean):void
    {
        throw new Error ('please override me!');
    }
    /**
     * @param name 流名字
     * @param type 1 - 发布，2 - 播放
     */
    protected function loginPacket (type:uint):ByteArray
    {
        var pkt:ByteArray = new LEByteArray;

        pkt.writeByte (1);
        pkt.writeInt(0);

        pkt.writeByte (type);

        var user:User = $.user;
        var room:Room = $.room;
        pkt.writeUTF(streamName); browserLog('流的名字是', streamName);
        pkt.writeUTF([user.userid, user.name].join(','));
        pkt.writeUTF(room.org);
        pkt.writeUTF(room.id);
        pkt.writeUTF(key); browserLog('Key', key);

        pkt.position = 1;
        pkt.writeInt(pkt.length-5);
        return pkt;
    }
    static protected function recordPacket (record:Boolean, file:String = '', recordVideo:Boolean = true, videoId:String = ''):ByteArray
    {
        var pkt:ByteArray = new LEByteArray;

        pkt.writeByte(3);
        pkt.writeUnsignedInt(0);
        pkt.writeBoolean(!record);
        pkt.writeUTF(file);
        pkt.writeBoolean(recordVideo);
        pkt.writeUTF(videoId);
        pkt.position = 1;
        pkt.writeUnsignedInt(pkt.length-5);
        return pkt;
    }
    static protected function avStatPacket (tag:uint, on:Boolean):ByteArray
    {
        var pkt:ByteArray = new LEByteArray;

        pkt.writeByte(4);
        pkt.writeUnsignedInt (2);
        pkt.writeByte (tag);
        pkt.writeBoolean(!on);
        return pkt;
    }
}
}
