package com.e2et.datalogic
{
import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public final class AVStreamClose extends AVStreamAction
{
    public function AVStreamClose (stm:AVStream = null)
    {
        $subject = stm;
    }
    [Inline]
    static internal function packBody (o:AVStreamClose, raw:IDataOutput):void
    {
        UserActionWithSubject.packBody (o, raw);
    }
    [Inline]
    static internal function unpackBody (o:AVStreamClose, raw:IDataInput):void
    {
        UserActionWithSubject.unpackBody (o, raw);
    }

    override internal final function onApply (isLocal:Boolean):void
    {
        var stm:AVStream = $subject;
        stm.$stat &= ~FLAG_OPEN;
    }
    override internal final function onHandled (isLocal:Boolean):void
    {
        var stm:AVStream = $subject;
        if (stm.purgeOnClose)
            stm.onPurge ($root);
    }
}
}
