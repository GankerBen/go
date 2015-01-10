package com.e2et.datalogic
{
import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public final class DocLineAddPoint extends DocLineAction
{
    public function DocLineAddPoint (line:DocLine = null, pt:Point = null)
    {
        $subject = line;
        _pt = pt;
        _last = line == null ? null : line.lastPoint;
    }

    [Inline]
    static internal function packBody (o:DocLineAddPoint, raw:IDataOutput):void
    {
        RoomActionWithSubject.packBody (o, raw);
        o._pt.pack (raw, o._last);
    }
    [Inline]
    static internal function unpackBody (o:DocLineAddPoint, raw:IDataInput):void
    {
        RoomActionWithSubject.unpackBody (o, raw);
        var line:DocLine = o.$subject;
        o._pt = Point.unpack (raw, line.lastPoint);
    }

    private var _pt:Point;
    private var _last:Point;

    public final function get point ():Point
    {
        return _pt;
    }
    override internal final function onApply (isLocal:Boolean):void
    {
        var line:DocLine = $subject;
        line.$points.push (_pt);
    }
}
}
