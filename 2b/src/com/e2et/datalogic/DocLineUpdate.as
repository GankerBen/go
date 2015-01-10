package com.e2et.datalogic
{
import com.e2et.datalogic.utils.readU29;
import com.e2et.datalogic.utils.writeU29;

import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public final class DocLineUpdate extends DocLineAction
{
    public function DocLineUpdate (line:DocLine = null, points:Vector.<Point> = null)
    {
        $subject = line;
        _points = points == null ? new Vector.<Point> : points;
    }

    [Inline]
    static internal function packBody (a:DocLineUpdate, raw:IDataOutput):void
    {
        var pts:Vector.<Point> = a._points;
        var i:uint, c:uint, pt:Point;
        RoomActionWithSubject.packBody (a, raw);
        writeU29 (raw, c = pts.length);
        if (c == 0)
            return;
        (pt = pts[0]).pack (raw);
        for (i=1; i<c; ++i)
            pt = pts[i].pack (raw, pt);
    }
    [Inline]
    static internal function unpackBody (a:DocLineUpdate, raw:IDataInput):void
    {
        var pts:Vector.<Point> = a._points;
        var i:uint, c:uint, pt:Point;
        RoomActionWithSubject.unpackBody (a, raw);
        pts.length = c = readU29 (raw);
        if (c == 0)
            return;
        pts[0] = pt = Point.unpack (raw);
        for (i=1; i<c; ++i)
            pts[i] = pt = Point.unpack (raw, pt);
    }

    private var _points:Vector.<Point>

    override internal final function onApply (isLocal:Boolean):void
    {
        var line:DocLine = $subject;
        line.$points = _points;
    }
}
}
