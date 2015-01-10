package com.e2et.datalogic
{
import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public final class DocTextChangeText extends DocTextAction
{
    public function DocTextChangeText (docText:DocText = null, text:String = null)
    {
        $subject = docText;
        _text = text is String ? text : '';
    }

    [Inline]
    static internal function packBody (a:DocTextChangeText, raw:IDataOutput):void
    {
        RoomActionWithSubject.packBody (a, raw);
        raw.writeUTF (a._text);
    }
    [Inline]
    static internal function unpackBody (a:DocTextChangeText, raw:IDataInput):void
    {
        RoomActionWithSubject.unpackBody (a, raw);
        a._text = raw.readUTF ();
    }

    private var _text:String;

    public final function get text ():String
    {
        return _text;
    }

    override internal final function onApply (isLocal:Boolean):void
    {
        var o:DocText = $subject;
        o.$text = _text;
    }
}
}
