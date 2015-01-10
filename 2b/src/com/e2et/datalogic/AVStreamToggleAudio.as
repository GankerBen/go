package com.e2et.datalogic
{
import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public final class AVStreamToggleAudio extends AVStreamAction
{
    public function AVStreamToggleAudio (stm:AVStream = null)
    {
        $subject = stm;
    }
    [Inline]
    static internal function packBody (o:AVStreamToggleAudio, raw:IDataOutput):void
    {
        UserActionWithSubject.packBody (o, raw);
    }
    [Inline]
    static internal function unpackBody (o:AVStreamToggleAudio, raw:IDataInput):void
    {
        UserActionWithSubject.unpackBody (o, raw);
    }

    override internal final function onApply (isLocal:Boolean):void
    {
        var stm:AVStream = $subject;
        stm.$audioOn = !stm.$audioOn;
    }
}
}
