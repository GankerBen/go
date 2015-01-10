package com.e2et.net.media.player
{
import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public class TSInfo
{
    private const _mts:Vector.<int> = new Vector.<int>;
    private const _lts:Vector.<int> = new Vector.<int>;
    private const _flg:Vector.<int> = new Vector.<int>;

    [Inline]
    public final function clear ():void
    {
        _mts.length = 0;
        _lts.length = 0;
        _flg.length = 0;
    }
    public final function get count ():uint
    {
        return _mts.length;
    }
    [Inline]
    public final function mts (i:uint):int
    {
        return _mts[i];
    }
    [Inline]
    public final function lts (i:uint):int
    {
        return _lts[i];
    }
    [Inline]
    public final function diffAt (i:uint):int
    {
        return (_lts[i]&0xffffff) - (_mts[i]&0xffffff);
    }
    public function push (mediaTS:int, localTS:int, isAudio:Boolean):void
    {
        var cnt:uint = _mts.length;
        _mts.push (mediaTS);
        _lts.push (localTS);
        if ((cnt & 31) == 0)
        {
            _flg.push (isAudio ? 1 : 0);
        }
        else
        {
            if (isAudio)
                _flg[cnt>>5] |= 1<<(cnt&31);
        }
    }
    public function pack (raw:IDataOutput):void
    {
        var i:uint, c:uint = _mts.length;
        raw.writeUnsignedInt (c);
        if (c == 0)
            return;
        raw.writeInt (_mts[i]);
        raw.writeInt (_lts[i]);
        for (i=1; i<c; ++i)
        {
            raw.writeInt (_mts[i] - _mts[i-1]);
            raw.writeInt (_lts[i] - _lts[i-1]);
        }
        c = _flg.length;
        raw.writeUnsignedInt (c);
        for (i=0; i<c; ++i)
            raw.writeUnsignedInt (_flg[i]);
    }
    public function unpack (raw:IDataInput):void
    {
        var i:uint, c:uint;
        _mts.length = 0;
        _lts.length = 0;
        _flg.length = 0;
        c = raw.readUnsignedInt ();
        if (c == 0)
            return;
        _mts.push (raw.readInt ());
        _lts.push (raw.readInt ());
        for (i=1; i<c; ++i)
        {
            _mts.push (_mts[i-1] + raw.readInt ());
            _lts.push (_lts[i-1] + raw.readInt ());
        }
        c = raw.readUnsignedInt ();
        for (i=0; i<c; ++i)
            _flg.push (raw.readUnsignedInt ());
    }
}
}
