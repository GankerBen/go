package com.e2et.datalogic
{
import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public class AVStreamChangeState extends AVStreamAction
{
    public function AVStreamChangeState (stm:AVStream = null, state:uint = 0)
    {
        $subject = stm;
        _state = state;
    }

    [Inline]
    static internal function packBody (o:AVStreamChangeState, raw:IDataOutput):void
    {
        UserActionWithSubject.packBody (o, raw);
        raw.writeByte (o._state);
    }
    [Inline]
    static internal function unpackBody (o:AVStreamChangeState, raw:IDataInput):void
    {
        UserActionWithSubject.unpackBody (o, raw);
        o._state = raw.readByte ();
    }

    private var _state:uint;

    public final function get state ():uint
    {
        return _state;
    }
    override internal final function onApply (isLocal:Boolean):void
    {
        var stm:AVStream = $subject;
		if (!stm)
			return;
        stm.$state = _state;
        if (_state == AVStream.BROKEN || _state == AVStream.FAILED)
        {
            stm.$seq++;
            stm.$name = null;
        }
    }
}
}
