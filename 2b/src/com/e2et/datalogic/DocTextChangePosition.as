package com.e2et.datalogic
{
import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public final class DocTextChangePosition extends DocTextAction
{
    public function DocTextChangePosition (docText:DocText = null, rect:Rect = null)
    {
        $subject = docText;
        _rect = rect;
    }

    [Inline]
    static internal function packBody (a:DocTextChangePosition, raw:IDataOutput):void
    {
        RoomActionWithSubject.packBody (a, raw);
        a._rect.pack (raw);
    }
    [Inline]
    static internal function unpackBody (a:DocTextChangePosition, raw:IDataInput):void
    {
        RoomActionWithSubject.unpackBody (a, raw);
        a._rect = Rect.unpack (raw);
    }

    private var _rect:Rect;

    public final function get rect ():Rect
    {
        return _rect;
    }
    override internal final function onApply (isLocal:Boolean):void
    {
        var o:DocText = $subject;
        o.$rect = _rect;
    }
}
}
