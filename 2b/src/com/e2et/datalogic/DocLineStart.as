package com.e2et.datalogic
{
import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public final class DocLineStart extends DocLineAction
{
    public function DocLineStart (line:DocLine = null, pt:Point = null)
    {
        $subject = line;
        _pt = pt;
    }
    [Inline]
    static internal function packBody (o:DocLineStart, raw:IDataOutput):void
    {
        RoomActionWithSubject.packBody (o, raw);
        o._pt.pack (raw);
    }
    [Inline]
    static internal function unpackBody (o:DocLineStart, raw:IDataInput):void
    {
        RoomActionWithSubject.unpackBody (o, raw);
        o._pt = Point.unpack (raw);
    }

    private var _pt:Point;

    public final function get point ():Point
    {
        return _pt;
    }

    override internal final function onApply (isLocal:Boolean):void
    {
        var line:DocLine = $subject;
        line.$docPage.$line = line;
        var pts:Vector.<Point> = line.$points;
        pts.length = 0;
        pts.push (_pt);
    }
}
}
