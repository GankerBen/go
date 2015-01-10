package com.e2et.datalogic
{
import flash.utils.IDataInput;
import flash.utils.IDataOutput;
import com.e2et.datalogic.utils.readObject;
import com.e2et.datalogic.utils.writeObject;

public final dynamic class MediaPlayer extends RoomObject
{
    public function MediaPlayer (file:String = null, mediaInfo:* = null)
    {
        $file = file is String ? file : '';
        $mediaInfo = mediaInfo;
    }
    [Inline]
    static public function packBody (o:MediaPlayer, raw:IDataOutput):void
    {
        RoomObject.packBody (o, raw);
        raw.writeUTF (o.$file);
        writeObject (raw, o.$mediaInfo);
        raw.writeDouble (o.$volume);
        raw.writeDouble (o.$time);
        raw.writeBoolean (o.$paused);
    }
    [Inline]
    static public function unpackBody (o:MediaPlayer, raw:IDataInput):void
    {
        RoomObject.unpackBody (o, raw);
        o.$file = raw.readUTF ();
        o.$mediaInfo = readObject (raw);
        o.$volume = raw.readDouble ();
        o.$time = raw.readDouble ();
        o.$paused = raw.readBoolean ();
    }

    internal var $file:String, $mediaInfo:*;
    internal var $volume:Number = 1.0;
    internal var $time:Number = 0.0;
    internal var $paused:Boolean = false;

    public final function get file():String
    {
        return $file;
    }
    public final function get mediaInfo ():*
    {
        return $mediaInfo;
    }
    public final function get volume():Number
    {
        return $volume;
    }
    public final function get time():Number
    {
        return $time;
    }
    public final function get paused():Boolean
    {
        return $paused;
    }

    [Inline]
    public final function open ():void
    {
        if (!isOpened)
        {
            var root:RootObject = $root;
            root.addLocalAction (new MediaPlayOpen (this));
        }
    }
    [Inline]
    public final function close ():void
    {
        if (isOpened)
        {
            var root:RootObject = $root;
            root.addLocalAction (new MediaPlayClose (this));
        }
    }
    [Inline]
    public final function togglePause ():void
    {
        if (isOpened)
        {
            var root:RootObject = $root;
            root.addLocalAction (new MediaPlayTogglePause (this));
        }
    }
    [Inline]
    public final function seek (time:Number):void
    {
        if (isOpened)
        {
            var root:RootObject = $root;
            root.addLocalAction (new MediaPlaySeek (this, time));
        }
    }
    public final function set volume (v:Number):void
    {
        if (isOpened)
        {
            var root:RootObject = $root;
            root.addLocalAction (new MediaPlayChangeVolume (this, v));
        }
    }
}
}
