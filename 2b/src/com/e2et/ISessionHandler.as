package com.e2et
{
import com.e2et.datalogic.User;

public interface ISessionHandler
{
    function sessionStarting ($:ISession):void;
    function sessionStartProgress ($:ISession, progress:Number):void;
    function sessionStarted ($:ISession):void;
    function sessionStartFailed ($:ISession, reason:String):void;
    function sessionInterrupted ($:ISession, reason:String):void;

    /**
     * 新用户进入房间时，房间内其他用户都会收到 UserIn 消息
     */
    function handleUserIn ($:ISession, user:User):void;
    /**
     * 用户离开房间时，房间内其他用户都会收到 UserOut 消息
     * @param type 0 - 用户退出, 1 - 用户掉线, 2 - 用户超时, 3 - 重复登录
     */
    function handleUserOut ($:ISession, user:User, type:uint):void;
    /**
     * 后进来的用户会收到前面用户发过来的 userUpdate，只会收到一次
     */
    function handleUserUpdate ($:ISession, user:User):void;
    function handleChat ($:ISession, sender:User, receiver:User, time:uint, msg:String):void;
    function handleRPC ($:ISession, sender:User, receiver:User, func:String, args:Array):void;
    function handleRemoteLogin ($:ISession):void;

    function tokenChanged ($:ISession, token:User, prevToken:User):void;
    /**
     * 获取令牌失败了
     * @param code 1 - 没有权限，2 - 重复获取
     */
    function acquireTokenFailed ($:ISession, code:uint):void;

    function handleRecordStartFailed ($:ISession, code:uint):void;
    function handleRecordStarted ($:ISession, videoId:String):void;
    function handleRecordStopped ($:ISession):void;
}
}
