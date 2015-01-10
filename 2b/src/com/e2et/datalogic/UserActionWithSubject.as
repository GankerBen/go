package com.e2et.datalogic
{
import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public class UserActionWithSubject extends UserAction
{
    [Inline]
    static internal function packBody (o:UserActionWithSubject, raw:IDataOutput):void
    {
        UserAction.packBody (o, raw);
        refObject (o.$subject, raw);
    }
    [Inline]
    static internal function unpackBody (o:UserActionWithSubject, raw:IDataInput):void
    {
        UserAction.unpackBody (o, raw);
        o.$subject = derefObject (o.$root, raw);
    }

    internal var $subject:*;

    public final function get subject ():UserObject
    {
        return $subject;
    }
}
}
