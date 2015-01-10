package com.e2et.datalogic
{
import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public final class DocPageObjectToggleSelection extends RoomActionWithSubject
{
    public function DocPageObjectToggleSelection (obj:DocPageObject = null)
    {
        $subject = obj;
    }

    [Inline]
    static internal function packBody (a:DocPageObjectToggleSelection, raw:IDataOutput):void
    {
        RoomActionWithSubject.packBody (a, raw);
    }
    [Inline]
    static internal function unpackBody (a:DocPageObjectToggleSelection, raw:IDataInput):void
    {
        RoomActionWithSubject.unpackBody (a, raw);
    }

    internal var $obj:DocPageObject;

    public final function get obj ():DocPageObject
    {
        return $obj;
    }

    override internal final function onApply (isLocal:Boolean):void
    {
        var o:DocPageObject = $obj;
        o.$selected = !o.$selected;
    }
}
}
