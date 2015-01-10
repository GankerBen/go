package com.e2et.datalogic
{
import com.e2et.datalogic.utils.readObject;
import com.e2et.datalogic.utils.readU29;
import com.e2et.datalogic.utils.writeObject;
import com.e2et.datalogic.utils.writeU29;

import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public final dynamic class Document extends RoomObject
{
    public function Document (name:String = null, uri:String = null, docInfo:* = null)
    {
        $name = name is String ? name : '';
        $uri = uri is String ? uri : '';
        $docInfo = docInfo;
        $stat &= ~FLAG_PURGE_ON_CLOSE;
    }
    [Inline]
    static public function packBody (o:Document, raw:IDataOutput):void
    {
        RoomObject.packBody (o, raw);
        raw.writeUTF (o.$name);
        raw.writeUTF (o.$uri);
        writeObject (raw, o.$docInfo);
        refObject (o.$page, raw);
        refObject (o.$tool, raw);
        var pages:Array = o.$pages;
        var i:uint, c:uint = pages.length;
        writeU29 (raw, c);
        for (i=0; i<c; ++i)
        {
            refObject (pages[i], raw);
        }
    }
    [Inline]
    static public function unpackBody (o:Document, raw:IDataInput):void
    {
        var pages:Array = o.$pages, page:DocPage;
        var root:RootObject = o.$root;

        RoomObject.unpackBody (o, raw);
        o.$name = raw.readUTF ();
        o.$uri = raw.readUTF ();
        o.$docInfo = readObject (raw);
        o.$page = derefObject (root, raw);
        o.$tool = derefObject (root, raw);
        var i:uint, c:uint = readU29 (raw);
        pages.length = 0;
        for (i=0; i<c; ++i)
        {
            if ((page = derefObject (root, raw)) != null)
                pages[i] = page;
        }
        pages.length = c;
    }

    internal var $name:String, $uri:String, $docInfo:*;
    internal var $page:DocPage = null;
    internal var $tool:DocTool = null;

    /**
     * 文档页数限制为最多 16383 页
     */
    internal var $pages:Array = [];

    public final function get name ():String
    {
        return $name;
    }
    public final function get uri ():String
    {
        return $uri;
    }
    public final function get docInfo ():*
    {
        return $docInfo;
    }
    public final function get pages ():Array
    {
        return $pages;
    }
    /**
     * 文档页数限制为最多 16383 页
     */
    public final function get pageCount ():uint
    {
        return $pages.length;
    }
    [Inline]
    public final function pageAt (i:uint):DocPage
    {
        return $pages[i];
    }
    public final function get page ():DocPage
    {
        return $page;
    }
    public final function get pageNo ():uint
    {
        return $page.$pageNo;
    }
    public final function get tool ():DocTool
    {
        return $tool;
    }
    public final function set tool (t:DocTool):void
    {
        if (($stat & (FLAG_OPEN | FLAG_PURGE)) == FLAG_OPEN)
        {
            var root:RootObject = $root;
            root.addLocalAction (new DocToolChanged (this, t));
        }
    }

    /**
     * 文档页数限制为最多 16383 页
     */
    public final function set pageCount (pageCount:uint):void
    {
        if (pageCount > 16383)
            throw new Error ('页数不能超过 16383');
        if (($stat & (FLAG_OPEN | FLAG_PURGE)) == FLAG_OPEN)
        {
            if (this.$pages.length)
            {
                throw new Error ('文档页数已设置');
            }
            var root:RootObject = $root;
            root.addLocalAction (new DocSetPageCount (this, pageCount));
        }
    }
    /**
     * 跳转到指定页
     * @param page 文档页码 (索引基数为 0)
     * @param step 若文档页内有动画内容，跳转至第 step 步 (索引基数为 0)
     * @return 文档页对象
     */
    public final function gotoPage (page:uint, step:uint = 0):DocPage
    {
        if (page >= 16383)
            throw new Error ('bad page number');
        if (($stat & (FLAG_OPEN | FLAG_PURGE)) != FLAG_OPEN)
            throw new Error ('document not opened or purged');
        // 是当前页吗?
        if ($page != null && $page.$pageNo == page)
            return $page.gotoStep (step);

        var root:RootObject = $root;
        var p:DocPage = $pages[page];
        if (p == null)
        {
            root.addObject (p = new DocPage (this, page));
            root.addLocalAction (new RoomObjectCreate (p));
        }
        root.addLocalAction (new DocPageGoto (p, step));
        return p;
    }

    [Inline]
    public final function open ():Document
    {
        if (($stat & (FLAG_OPEN | FLAG_PURGE)) == 0)
        {
            var root:RootObject = $root;
            root.addLocalAction (new DocOpen (this));
        }
        return this;
    }
    [Inline]
    public final function close ():Document
    {
        if (($stat & (FLAG_OPEN | FLAG_PURGE)) == FLAG_OPEN)
        {
            var root:RootObject = $root;
            root.addLocalAction (new DocClose (this));
        }
        return this;
    }
    override internal final function onPurge (room:Room):Boolean
    {
        if (!super.onPurge (room))
            return false;
        var v:Array = $pages, page:DocPage;
        var i:uint, c:uint = v.length;
        for (i=0; i<c; ++i)
        {
            if ((page = v[i]) != null)
                page.onPurge (room);
        }
        v.length = 0;
        return true;
    }
}
}
