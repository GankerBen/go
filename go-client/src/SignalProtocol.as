package 
{
public class SignalProtocol
{
    static public const LOGIN:uint = 0;
    static public const LOGIN_RESULT:uint = 0;

    static public const JOIN_ROOM:uint = 1;
    static public const JOIN_ROOM_RESULT:uint = 1;

    static public const USER_IN:uint = 2;
    static public const USER_OUT:uint = 3;

    static public const UPDATE_ROOM:uint = 4;
    static public const SEND_ROOM_ACTION:uint = 5;

    static public const UPDATE_USER:uint = 6;
    static public const SEND_USER_ACTION:uint = 7;

    static public const CHAT:uint = 8;
    static public const RPC:uint = 9;

    static public const LOGOUT:uint = 10;
    static public const LOGOUT_RESULT:uint = 10;

    static public const ACQUIRE_TOKEN:uint = 11;
    static public const TOKEN_CHANGED:uint = 12;

    static public const RECORD:uint = 13;
    static public const RECORD_RESULT:uint = 13;

    static public const RECORD_INFO:uint = 14;

    static public const PING:uint = 0xfb;
    static public const PONG:uint = 0xfc;
    static public const REPEAT:uint = 0xfd; // 重复登录
}
}
