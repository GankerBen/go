package com.e2et
{
import com.e2et.datalogic.User;
import com.e2et.net.signal.ISignalHandler;
import com.e2et.net.signal.SignalClient;

internal final class SignalHandler implements ISignalHandler
{
    private var $:Session;

    public function SignalHandler ($:Session)
    {
        this.$ = $;
    }

    public function signalConnectDone (sc:SignalClient):void
    {
        $.signalConnectDone ();
    }

    public function signalConnectFail (sc:SignalClient, reason:String):void
    {
        $.signalConnectFail (reason);
    }

    public function signalInterrupted (sc:SignalClient, reason:String):void
    {
        $.signalInterrupted (reason);
    }

    public function handleLoginResult (sc:SignalClient, res:uint, code:uint):void
    {
        $.handleLoginResult (res, code);
    }
    public function handleJoinResult (sc:SignalClient, userCount:uint, id:uint):void
    {
        $.handleJoinResult (userCount, id);
    }
    public function handleAcquireToken (sc:SignalClient, code:uint):void
    {
        $.handleAcquireToken (code);
    }
    public function handleTokenChanged (sc:SignalClient, token:User, prevToken:User):void
    {
        $.handleTokenChanged (token, prevToken);
    }
    public function handleUserIn (sc:SignalClient, user:User):void
    {
        $.handleUserIn (user);
    }

    public function handleUserOut (sc:SignalClient, user:User, type:uint):void
    {
        $.handlerUserOut (user, type);
    }

    public function handleUserUpdate (sc:SignalClient, user:User):void
    {
        $.handleUserUpdate (user);
    }

    public function handleChat (sc:SignalClient, sender:User, receiver:User, time:uint, msg:String):void
    {
        $.handleChat (sender, receiver, time, msg);
    }

    public function handleRPC (sc:SignalClient, sender:User, receiver:User, func:String, args:Array):void
    {
        $.handleRPC (sender, receiver, func, args);
    }

    public function handleRemoteLogin (sc:SignalClient):void
    {
        $.handleRemoteLogin ();
    }

    public function handleRecordStartFailed (sc:SignalClient, code:uint):void
    {
        $.handleRecordStartFailed (code);
    }
    public function handleRecordStarted (sc:SignalClient, videoId:String):void
    {
        $.handleRecordStarted (videoId);
    }
    public function handleRecordStopped (sc:SignalClient):void
    {
        $.handleRecordStopped ();
    }
}
}
