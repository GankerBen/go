package com.e2et.datalogic
{
import com.e2et.datalogic.utils.readU29;
import com.e2et.datalogic.utils.writeU29;

import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public final class DocPageSetStepCount extends DocPageAction
{
    public function DocPageSetStepCount (page:DocPage = null, count:uint = 0)
    {
        $subject = page;
        _stepCount = count;
    }
    [Inline]
    static internal function packBody (o:DocPageSetStepCount, raw:IDataOutput):void
    {
        RoomActionWithSubject.packBody (o, raw);
        writeU29 (raw, o._stepCount);
    }
    [Inline]
    static internal function unpackBody (o:DocPageSetStepCount, raw:IDataInput):void
    {
        RoomActionWithSubject.unpackBody (o, raw);
        o._stepCount = readU29 (raw);
    }

    private var _stepCount:uint;

    public final function get stepCount():uint
    {
        return _stepCount;
    }
    override internal final function onApply (isLocal:Boolean):void
    {
        var page:DocPage = $subject;
        page.$stepCount = _stepCount;
    }
}
}
