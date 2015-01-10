package com.e2et.datalogic
{
import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public final class AVStreamToggleVideo extends AVStreamAction
{
    public function AVStreamToggleVideo (stm:AVStream = null)
    {
        $subject = stm;
    }
    [Inline]
    static internal function packBody (o:AVStreamToggleVideo, raw:IDataOutput):void
    {
        UserActionWithSubject.packBody (o, raw);
    }
    [Inline]
    static internal function unpackBody (o:AVStreamToggleVideo, raw:IDataInput):void
    {
        UserActionWithSubject.unpackBody (o, raw);
    }

    override internal final function onApply (isLocal:Boolean):void
    {
        var stm:AVStream = $subject;
        stm.$videoOn = !stm.$videoOn;
    }
}
}
