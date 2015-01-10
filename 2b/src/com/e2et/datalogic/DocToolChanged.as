package com.e2et.datalogic
{
import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public final class DocToolChanged extends DocAction
{
    public function DocToolChanged (doc:Document = null, tool:DocTool = null)
    {
        $subject = doc;
        _tool = tool;
    }

    [Inline]
    static internal function packBody (o:DocToolChanged, raw:IDataOutput):void
    {
        RoomActionWithSubject.packBody (o, raw);
        refObject (o._tool, raw);
    }
    [Inline]
    static internal function unpackBody (o:DocToolChanged, raw:IDataInput):void
    {
        RoomActionWithSubject.unpackBody (o, raw);
        o._tool = derefObject (o.$root, raw);
    }

    private var _tool:DocTool;

    public final function get tool():DocTool
    {
        return _tool;
    }
    override internal final function onApply (isLocal:Boolean):void
    {
        var doc:Document = $subject;
        doc.$tool = _tool;
    }
}
}
