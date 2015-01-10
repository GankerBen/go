package com.e2et.datalogic
{
import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public final class DocClose extends DocAction
{
    public function DocClose (doc:Document = null)
    {
        $subject = doc;
    }

    [Inline]
    static internal function packBody (o:DocClose, raw:IDataOutput):void
    {
        RoomActionWithSubject.packBody (o, raw);
    }
    [Inline]
    static internal function unpackBody (o:DocClose, raw:IDataInput):void
    {
        RoomActionWithSubject.unpackBody (o, raw);
    }

    override internal final function onApply (isLocal:Boolean):void
    {
        var doc:Document = $subject;
        doc.$stat &= ~FLAG_OPEN;
        var room:Room = $root;
        if (room.$doc == doc)
            room.$doc = null;
    }
    override internal final function onHandled (isLocal:Boolean):void
    {
        var doc:Document = $subject;
        if (doc.purgeOnClose)
            doc.onPurge ($root);
    }
}
}
