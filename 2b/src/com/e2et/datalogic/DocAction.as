package com.e2et.datalogic
{
public class DocAction extends RoomActionWithSubject
{
    public final function get doc ():Document
    {
        return $subject;
    }
}
}
