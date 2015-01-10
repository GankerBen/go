package com.e2et.datalogic
{
import com.e2et.datalogic.utils.readU29;
import com.e2et.datalogic.utils.writeU29;

import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public final dynamic class DocPage extends RoomObject
{
    public function DocPage (doc:Document = null, pageNo:uint = 0)
    {
        $document = doc;
        $pageNo = pageNo;
        $stat = FLAG_OPEN;
    }

    [Inline]
    static public function packBody (o:DocPage, raw:IDataOutput):void
    {
        RoomObject.packBody (o, raw);
        refObject (o.$document, raw);
        writeU29 (raw, o.$pageNo);
        writeU29 (raw, o.$stepCount);
        writeU29 (raw, o.$step);
        var objs:Vector.<DocPageObject> = o.$objs;
        var i:uint, c:uint = objs.length;
        writeU29 (raw, c);
        for (i=0; i<c; ++i)
        {
            refObject (objs[i], raw);
        }
        refObject (o.$line, raw);
    }
    [Inline]
    static public function unpackBody (o:DocPage, raw:IDataInput):void
    {
        var root:RootObject = o.$root;
        var objs:Vector.<DocPageObject> = o.$objs;

        RoomObject.unpackBody (o, raw);
        o.$document = derefObject (root, raw);
        o.$pageNo = readU29 (raw);
        o.$stepCount = readU29 (raw);
        o.$step = readU29 (raw);
        var i:uint, c:uint = readU29 (raw);
        objs.length = 0;
        for (i=0; i<c; ++i)
        {
            objs.push (derefObject (root, raw));
        }
        o.$line = derefObject (root, raw);
    }

    internal var $document:Document;
    internal var $pageNo:uint;
    internal var $stepCount:uint = 0;
    internal var $step:uint = 0;
    internal var $line:DocLine = null;

    /**
     * 一个文档页上最多支持 16383 个 DocPageObject
     */
    internal const $objs:Vector.<DocPageObject> = new Vector.<DocPageObject>;

    public final function get document ():Document
    {
        return $document;
    }
    public final function get pageNo ():uint
    {
        return $pageNo;
    }
    public final function get step ():uint
    {
        return $step;
    }
    public final function get stepCount ():uint
    {
        return $stepCount;
    }
    public final function get objs ():Vector.<DocPageObject>
    {
        return $objs;
    }
    public final function get line ():DocLine
    {
        return $line;
    }
    public final function set stepCount (stepCount:uint):void
    {
        var root:RootObject = $root;
        root.addLocalAction (new DocPageSetStepCount (this, stepCount));
    }

    [Inline]
    public final function newDocLine (pencil:DocPencilTool):DocLine
    {
        if ($objs.length >= 16383)
            return null;
        var root:RootObject = $root;
        var o:DocLine = new DocLine (this, pencil);
        root.addObject (o);
        root.addLocalAction (new RoomObjectCreate (o));
        return o;
    }
    [Inline]
    public final function newDocText (text:String, tool:DocTextTool, rect:Rect):DocText
    {
        if ($objs.length >= 16383)
            return null;
        var root:RootObject = $root;
        var o:DocText = new DocText (this, text, tool, rect);
        root.addObject (o);
        root.addLocalAction (new RoomObjectCreate (o));
        return o;
    }
    [Inline]
    public final function gotoStep (step:uint):DocPage
    {
        if (step != $step)
        {
            var room:Room = $root;
            room.addLocalAction (new DocPageGoto (this, step));
        }
        return this;
    }
    override internal final function onPurge (room:Room):Boolean
    {
        if (!super.onPurge (room))
            return false;
        var v:Vector.<DocPageObject> = $objs;
        var i:uint, c:uint = v.length;
        for (i=0; i<c; ++i)
        {
            var o:DocPageObject = v[i];
            o.onPurge (room);
        }
        v.length = 0;
        return true;
    }
    internal function removePageObject (obj:DocPageObject):void
    {
        var objs:Vector.<DocPageObject> = $objs;
        var i:uint, c:uint = objs.length;
        for (i=0; i<c; ++i)
        {
            if (objs[i] === obj)
            {
                objs.splice (i, 1);
                return;
            }
        }
    }
}
}
