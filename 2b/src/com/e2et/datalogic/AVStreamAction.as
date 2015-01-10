package com.e2et.datalogic
{
public class AVStreamAction extends UserActionWithSubject
{
    public final function get stream ():AVStream
    {
        return $subject;
    }
}
}
