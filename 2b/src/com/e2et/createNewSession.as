package com.e2et
{
import com.e2et.datalogic.Room;

public function createNewSession (room:Room):ISession
{
    return new Session (room);
}
}
