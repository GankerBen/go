package com.e2et.net.connection
{
import com.e2et.net.ncp_internal;

import flash.events.EventDispatcher;

use namespace ncp_internal;

[ExcludeClass]
public class NetConnectionPoolHandler extends EventDispatcher
{
    ncp_internal function onConnectDone(nc:INetConnection, count:uint):void { }
    ncp_internal function onConnectFail():void { }
}
}
