package com.e2et.datalogic
{
import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public final class DocLineEnd extends DocLineAction
{
    public function DocLineEnd (line:DocLine = null)
    {
        $subject = line;
    }
    [Inline]
    static internal function packBody (o:DocLineEnd, raw:IDataOutput):void
    {
        RoomActionWithSubject.packBody (o, raw);
    }
    [Inline]
    static internal function unpackBody (o:DocLineEnd, raw:IDataInput):void
    {
        RoomActionWithSubject.unpackBody (o, raw);
    }

    override internal function onApply (isLocal:Boolean):void
    {
        var line:DocLine = $subject;
        line.$docPage.$line = null;
    }
}
}
