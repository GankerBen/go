package com.e2et.datalogic
{
import com.e2et.net.media.audio.IAudioCapture;
import com.e2et.net.media.player.IMediaPlayClient;
import com.e2et.net.media.publisher.IMediaPubClient;
import com.e2et.net.media.video.IVideoCapture;

import flash.utils.IDataInput;
import flash.utils.IDataOutput;
import com.e2et.datalogic.utils.readObject;
import com.e2et.datalogic.utils.writeObject;

public final dynamic class AVStream extends UserObject
{
    static public const STARTING:uint = 0;
    static public const STARTED:uint = 1;
    static public const BROKEN:uint = 2;
    static public const FAILED:uint = 3;

    public function AVStream (item:AVItem = null)
    {
        if (item != null)
        {
            $avid = item.$avid;
            $info = item.$info;
        }
        $stat |= FLAG_PURGE_ON_CLOSE;
        $name = null;
    }

    [Inline]
    static public function packBody (o:AVStream, raw:IDataOutput):void
    {
        UserObject.packBody (o, raw);
        raw.writeUnsignedInt (o.$avid);
        raw.writeUnsignedInt (o.$seq);
        writeObject (raw, o.$info);
        var state:uint = o.$state<<2;
        if (o.$audioOn)
            state |= 1;
        if (o.$videoOn)
            state |= 2;
        raw.writeByte (state);
    }
    [Inline]
    static public function unpackBody (o:AVStream, raw:IDataInput):void
    {
        UserObject.unpackBody (o, raw);
        o.$avid = raw.readUnsignedInt ();
        o.$seq = raw.readUnsignedInt (); browserLog('$seq', o.$seq);
        o.$info = readObject (raw);
        var state:uint = raw.readByte ();
        o.$audioOn = (state&1) != 0;
        o.$videoOn = (state&2) != 0;
        o.$state = state>>2;
        o.$name = null;
    }

    internal var $avid:uint, $seq:uint = 0;
    internal var $info:*, $name:String;
    internal var $audioOn:Boolean;
    internal var $videoOn:Boolean;
    internal var $acap:IAudioCapture;
    internal var $vcap:IVideoCapture;
    internal var $state:uint;

    public var pc:IMediaPubClient;
    public var mp:IMediaPlayClient;

    public final function get avid ():uint
    {
        return $avid;
    }
    public final function get seq ():uint
    {
        return $seq;
    }
    public final function get name():String
    {
        if ($name != null)
            return $name;
        else
            return $name = $avid + '-' + $seq;
    }
    public final function get audioOn():Boolean
    {
        return $audioOn;
    }
    public final function get videoOn():Boolean
    {
        return $videoOn;
    }
    public final function get audioCap ():IAudioCapture
    {
        return $acap;
    }
    public final function get videoCap ():IVideoCapture
    {
        return $vcap;
    }
    public final function get state ():uint
    {
        return $state;
    }
    public final function set state (v:uint):void
    {
        if ($root is LocalUser) {
            v &= 0xff;
            if (v == STARTING || $state != v) {
                var root:RootObject = $root;
                root.addLocalAction (new AVStreamChangeState (this, v));
            }
        }
    }
	
	public function get info():* 
	{
		return $info;
	}

    [Inline]
    public final function open (a:IAudioCapture = null, v:IVideoCapture = null):void
    {
        if (!($root is LocalUser))
            return;
        if (!isOpened)
        {
            $acap = a;
            $vcap = v;
            var root:RootObject = $root;
            root.addLocalAction (new AVStreamOpen (this, a!=null, v!=null));
        }
    }
    [Inline]
    public final function close ():void
    {
        if (!($root is LocalUser))
            return;
        if (isOpened)
        {
            var root:RootObject = $root;
            root.addLocalAction (new AVStreamClose (this));
        }
    }
    [Inline]
    public final function toggleAudio ():Boolean
    {
        if (!($root is LocalUser))
            return false;
        if (isOpened)
        {
            var root:RootObject = $root;
            root.addLocalAction (new AVStreamToggleAudio (this));
        }
        return $audioOn;
    }
    [Inline]
    public final function toggleVideo ():Boolean
    {
        if (!($root is LocalUser))
            return false;
        if (isOpened)
        {
            var root:RootObject = $root;
            root.addLocalAction (new AVStreamToggleVideo (this));
        }
        return $videoOn;
    }
    override internal final function onPurge (user:User):Boolean
    {
        if (!super.onPurge (user))
            return false;
        else
            return user.removeAVStream (this), true;
    }
}
}
