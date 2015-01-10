package com.e2et.datalogic
{
import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public class DocPageObject extends RoomObject
{
    [Inline]
    static public function packBody (o:DocPageObject, raw:IDataOutput):void
    {
        RoomObject.packBody (o, raw);
        refObject (o.$docPage, raw);
        raw.writeBoolean (o.$selected);
    }
    [Inline]
    static public function unpackBody (o:DocPageObject, raw:IDataInput):void
    {
        RoomObject.unpackBody (o, raw);
        o.$docPage = derefObject (o.$root, raw);
        o.$selected = raw.readBoolean ();
    }

    internal var $docPage:DocPage;
    internal var $selected:Boolean = false;

    public final function get docPage ():DocPage
    {
        return $docPage;
    }
    public final function get selected ():Boolean
    {
        return $selected;
    }
    public final function get document ():Document
    {
        return $docPage.$document;
    }
    public final function get pageNo ():uint
    {
        return $docPage.$pageNo;
    }

    public final function set selected (b:Boolean):void
    {
        if (b != $selected)
        {
            var room:Room = $root;
            room.addLocalAction (new DocPageObjectToggleSelection (this));
        }
    }
    override internal function onPurge (room:Room):Boolean
    {
        if (!super.onPurge (room))
            return false;
        var page:DocPage = $docPage;
        if (docPage.isPurged)
            return true;
        page.removePageObject (this);
        return true;
    }
}
}
