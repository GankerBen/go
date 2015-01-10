package com.e2et.datalogic
{
/**
 * 本地用户 - 从第一人称角度来讲，也就是`我`。
 */
public final class LocalUser extends User
{
    public function LocalUser (userid:String, name:String, level:uint)
    {
        level &= 0xff;
        super (0, 0);
        $userid = userid;
        $name = name;
        $level = level;
        $nextActionId = 2;
    }
    public final function set sid (v:uint):void
    {
        if ($sid == 0)
            $sid = v;
    }
    internal function _init (id:uint):void
    {
        $id = id;
    }
    [Inline]
    public final function changeLevel (level:uint):void
    {
        level &= 0xff;
        if ($level != level)
            addLocalAction (new UserChangeLevel (level));
    }
    public final function set hasCam (v:Boolean):void
    {
        if ($hasCam != v)
            addLocalAction (new UserUpdateHasCam (v));
    }
    public final function set hasMic (v:Boolean):void
    {
        if ($hasMic != v)
            addLocalAction (new UserUpdateHasMic (v));
    }
    public final function set avatar (v:String):void
    {
        if ($avatar != v)
            addLocalAction (new UserUpdateAvatar (v));
    }
}
}
