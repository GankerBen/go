package com.e2et.datalogic
{
import flash.utils.Proxy;
import flash.utils.flash_proxy;

public final class Users extends Proxy
{
    internal var $users:Vector.<User>;

    public final function get length ():uint
    {
        return $users.length;
    }

    [Inline]
    public final function get source ():Vector.<User>
    {
        return $users;
    }
    [Inline]
    public final function user (i:uint):User
    {
        return $users[i];
    }

    [Inline]
    public final function getUser (id:uint):User
    {
        var f:uint, l:uint = $users.length, m:uint;
        for (f=0; f<l; )
        {
            var u:User = $users[m=(f+l)>>1];
            var uid:uint = u.$id;
            if (uid == id)
                return u;
            if (uid < id)
                f = m + 1;
            else
                l = m;
        }
        return null;
    }

    [Inline]
    internal final function init (users:Vector.<User>):void
    {
        $users = users;
        users.sort (compare);
    }
    internal final function addUser (u:User):User
    {
        var f:uint, l:uint = $users.length, m:uint, id:uint = u.$id;
        for (f=0; f<l; )
        {
            var o:User = $users[m=(f+l)>>1];
            var kid:uint = o.$id;
            if (kid == id)
                return o;
            if (kid < id)
                f = m+1;
            else
                l = m;
        }
        $users.splice (f, 0, u);
        return u;
    }
    internal final function delUser (id:uint):User
    {
        var f:uint, l:uint = $users.length, m:uint;
        for (f=0; f<l; )
        {
            var o:User = $users[m=(f+l)>>1];
            var kid:uint = o.$id;
            if (kid == id) {
                $users.splice (m, 1);
                return o;
            }
            if (kid < id)
                f = m+1;
            else
                l = m;
        }
        return null;
    }
    override flash_proxy function getProperty (name:*):*
    {
        return (name is QName) ? null : $users[name];
    }
    override flash_proxy function nextNameIndex (index:int):int
    {
        if (index < $users.length)
            return index + 1;
        else
            return 0;
    }
    override flash_proxy function nextName (index:int):String
    {
        return (index-1).toString ();
    }
    override flash_proxy function nextValue (index:int):*
    {
        return $users[index-1];
    }
    static private function compare (u1:User, u2:User):int
    {
        return u1.$id - u2.$id;
    }
}
}
