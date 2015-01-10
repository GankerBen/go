package com.e2et.net.signal
{
import com.e2et.datalogic.User;

public interface ISignalHandler
{
    /**
     * 信令连接成功
     * @param sc
     */
    function signalConnectDone (sc:SignalClient):void;
    /**
     * 信令连接失败
     * @param sc
     * @param reason 失败原因
     */
    function signalConnectFail (sc:SignalClient, reason:String):void;
    /**
     * 信令连接中断 - 会自动重连
     * @param sc
     * @param reason 中断原因
     */
    function signalInterrupted (sc:SignalClient, reason:String):void;

    function handleLoginResult (sc:SignalClient, res:uint, code:uint):void;
    //function handleReloginResult (sc:SignalClient):void;
    function handleJoinResult (sc:SignalClient, userCount:uint, id:uint):void;
    function handleAcquireToken (sc:SignalClient, code:uint):void;
    function handleTokenChanged (sc:SignalClient, tokenUser:User, prevTokenUser:User):void;

    function handleUserIn (sc:SignalClient, user:User):void;
    function handleUserOut (sc:SignalClient, user:User, type:uint):void;
    function handleUserUpdate (sc:SignalClient, user:User):void;
    function handleChat (sc:SignalClient, sender:User, receiver:User, time:uint, msg:String):void;
    function handleRPC (sc:SignalClient, sender:User, receiver:User, func:String, args:Array):void;
    function handleRemoteLogin (sc:SignalClient):void;

    function handleRecordStartFailed (sc:SignalClient, code:uint):void;
    function handleRecordStarted (sc:SignalClient, videoId:String):void;
    function handleRecordStopped (sc:SignalClient):void;
}
}
