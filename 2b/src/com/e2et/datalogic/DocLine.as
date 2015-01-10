package com.e2et.datalogic
{
import com.e2et.datalogic.utils.readU29;
import com.e2et.datalogic.utils.writeU29;

import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public final dynamic class DocLine extends DocPageObject
{
    public function DocLine (page:DocPage = null, pencil:DocPencilTool = null)
    {
        $docPage = page;
        $pencil = pencil;
    }

    [Inline]
    static public function packBody (o:DocLine, raw:IDataOutput):void
    {
        var pts:Vector.<Point> = o.$points;
        var i:uint, c:uint, pt:Point;
        DocPageObject.packBody (o, raw);
        refObject (o.$pencil, raw);
        writeU29 (raw, c = pts.length);
        if (c == 0)
            return;
        (pt = pts[0]).pack (raw);
        for (i=1; i<c; ++i)
            pt = pts[i].pack (raw, pt);
    }
    [Inline]
    static public function unpackBody (o:DocLine, raw:IDataInput):void
    {
        var pts:Vector.<Point> = o.$points;
        var i:uint, c:uint, pt:Point;
        DocPageObject.unpackBody (o, raw);
        o.$pencil = derefObject (o.$root, raw);
        pts.length = c = readU29 (raw);
        if (c == 0)
            return;
        pts[0] = pt = Point.unpack (raw);
        for (i=1; i<c; ++i)
            pts[i] = pt = Point.unpack (raw, pt);
    }

    internal var $pencil:DocPencilTool;
    internal var $points:Vector.<Point> = new Vector.<Point>;

    public final function get pencil ():DocPencilTool
    {
        return $pencil;
    }
    internal final function get lastPoint ():Point
    {
        return $points[$points.length-1];
    }

    [Inline]
    public final function start (x:int, y:int):void
    {
        var root:RootObject = $root;
        root.addLocalAction (new DocLineStart (this, new Point (x, y)));
    }
    [Inline]
    public final function end ():void
    {
        var root:RootObject = $root;
        root.addLocalAction (new DocLineEnd (this));
    }
    [Inline]
    public final function addPoint (x:int, y:int):void
    {
        var root:RootObject = $root;
        root.addLocalAction (new DocLineAddPoint (this, new Point (x, y)));
    }
    [Inline]
    public final function update (points:Vector.<Point>):void
    {
        var root:RootObject = $root;
        root.addLocalAction (new DocLineUpdate (this, points));
    }
}
}
