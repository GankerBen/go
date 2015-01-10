package com.e2et.datalogic
{
import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public final dynamic class DocText extends DocPageObject
{
    public function DocText (page:DocPage = null, text:String = null, textTool:DocTextTool = null,
            rect:Rect = null)
    {
        $docPage = page;
        $textTool = textTool;
        $text = text is String ? text : '';
        $rect = rect;
    }

    [Inline]
    static public function packBody (o:DocText, raw:IDataOutput):void
    {
        DocPageObject.packBody (o, raw);
        refObject (o.$textTool, raw);
        raw.writeUTF (o.$text);
        o.$rect.pack (raw);
    }
    [Inline]
    static public function unpackBody (o:DocText, raw:IDataInput):void
    {
        DocPageObject.unpackBody (o, raw);
        o.$textTool = derefObject (o.$root, raw);
        o.$text = raw.readUTF ();
        o.$rect = Rect.unpack (raw);
    }

    internal var $textTool:DocTextTool;
    internal var $text:String = '';
    internal var $rect:Rect;

    public final function get textTool ():DocTextTool
    {
        return $textTool;
    }
    public final function get text ():String
    {
        return $text;
    }
    public final function set text (t:String):void
    {
        var root:RootObject = $root;
        root.addLocalAction (new DocTextChangeText (this, t));
    }

    [Inline]
    public final function changePosition (rect:Rect):void
    {
        var root:RootObject = $root;
        root.addLocalAction (new DocTextChangePosition (this, rect));
    }
}
}
