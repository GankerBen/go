package com.e2et.datalogic
{
import com.e2et.datalogic.utils.readU29;
import com.e2et.datalogic.utils.writeU29;

import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public final class DocSetPageCount extends DocAction
{
    public function DocSetPageCount (doc:Document = null, count:uint = 0)
    {
        $subject = doc;
        _pageCount = count;
    }

    [Inline]
    static internal function packBody (o:DocSetPageCount, raw:IDataOutput):void
    {
        RoomActionWithSubject.packBody (o, raw);
        writeU29 (raw, o._pageCount);
    }
    [Inline]
    static internal function unpackBody (o:DocSetPageCount, raw:IDataInput):void
    {
        RoomActionWithSubject.unpackBody (o, raw);
        o._pageCount = readU29 (raw);
    }

    private var _pageCount:uint;

    public final function pageCount ():uint
    {
        return _pageCount;
    }

    override internal final function onApply (isLocal:Boolean):void
    {
        var doc:Document = $subject;
        doc.$pages.length = _pageCount;
    }
}
}
