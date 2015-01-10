package com.e2et.datalogic
{
public class MediaPlayAction extends RoomActionWithSubject
{
    public final function get mediaPlayer ():MediaPlayer
    {
        return $subject;
    }
}
}
