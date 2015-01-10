package com.e2et.datalogic
{
import com.e2et.datalogic.utils.readU29;
import com.e2et.datalogic.utils.writeU29;

import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public final class DocPageGoto extends DocPageAction
{
    public function DocPageGoto (page:DocPage = null, step:uint = 0)
    {
        $subject = page;
        _step = step;
    }

    [Inline]
    static internal function packBody (o:DocPageGoto, raw:IDataOutput):void
    {
        RoomActionWithSubject.packBody (o, raw);
        writeU29 (raw, o._step);
    }
    [Inline]
    static internal function unpackBody (o:DocPageGoto, raw:IDataInput):void
    {
        RoomActionWithSubject.unpackBody (o, raw);
        o._step = readU29 (raw);
    }

    private var _step:uint;

    public final function get page ():DocPage
    {
        return $subject;
    }
    public final function get pageNo ():uint
    {
        return page.$pageNo;
    }
    public final function get step ():uint
    {
        return _step;
    }
    override internal final function onApply (isLocal:Boolean):void
    {
        var page:DocPage = $subject;
        var doc:Document = page.$document;
        var pages:Array = doc.$pages;
        var pageNo:uint = page.$pageNo;
        if (pages[pageNo] == null)
            pages[pageNo] = page;
        doc.$page = page;
        page.$step = _step;
    }
}
}
