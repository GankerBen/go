package com.e2et.datalogic
{
import flash.utils.IDataInput;
import flash.utils.IDataOutput;

public class UserAction extends MetaAction
{
    [Inline]
    static internal function packBody (o:UserAction, raw:IDataOutput):void
    {
        MetaAction.packBody (o, raw);
    }
    [Inline]
    static internal function unpackBody (o:UserAction, raw:IDataInput):void
    {
        MetaAction.unpackBody (o, raw);
    }

    public final function get user ():User
    {
        return $root;
    }
}
}
