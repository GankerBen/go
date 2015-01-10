package com.e2et.net.connection
{
import com.e2et.Session;
import com.e2et.net.nc_internal;
import com.e2et.net.ncp_internal;

import flash.events.Event;
import flash.utils.ByteArray;

use namespace ncp_internal;
use namespace nc_internal;

[ExcludeClass]
public class NetConnectionHandler extends NetConnectionPoolHandler
{
    protected var _nc:INetConnection;

    public function NetConnectionHandler ($:Session)
    {
    }

    ncp_internal override function onConnectDone(nc:INetConnection, count:uint):void
    {
        _nc = nc;
    }
    nc_internal function onError (nc:INetConnection, e:Event):void
    {
        _nc.dispose();
        _nc = null;
    }
    nc_internal function onClose (nc:INetConnection, e:Event):void
    {
        _nc.dispose();
        _nc = null;
    }
    nc_internal function handleTimer (seq:uint):void
    {
    }
    nc_internal function handlePacket (nc:INetConnection, type:uint, pkt:ByteArray):void
    {
    }
}
}
