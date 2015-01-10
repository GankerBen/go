package com.e2et.net
{
import com.e2et.Session;
import com.e2et.net.connection.INetConnection;
import com.e2et.net.connection.NetConnectionHandler;
import com.e2et.net.connection.NetConnectionPool;
import com.e2et.utils.LEByteArray;
import com.e2et.utils.Misc;

import flash.net.NetConnection;
import flash.utils.ByteArray;
import flash.utils.Dictionary;
import flash.utils.clearInterval;
import flash.utils.clearTimeout;
import flash.utils.getTimer;
import flash.utils.setInterval;
import flash.utils.setTimeout;

use namespace nc_internal;
use namespace ncp_internal;

/**
 * NetClient - 客户端, 处理 Ping
 * @author Bin Tian
 */
[ExcludeClass]
public class NetClient extends NetConnectionHandler
{
    static private var clients:Dictionary = new Dictionary (true);
    static private var client_count:uint = 0;
    static private var timerId:uint = 0, timerSeq:uint = 0;

    protected var $:Session;
    protected var _tsi:Vector.<int>;
    protected var _tso:Vector.<int>;
    protected var _ts_epoch:int;
    protected var _last_ping_in:int;
    protected var _ping_timer_interval:int = 20;

    private var _last_connect:int = 0;
    private var _connect_timer:uint = 0;
    private var _ncpool:NetConnectionPool;

    public function NetClient($:Session)
    {
        super($);
        this.$ = $;
    }
    public function connect ():void
    {
        if (_nc != null)
            return; // connected
        if (_ncpool != null || _connect_timer != 0)
            return; // connecting
        var now:int = getTimer ();
        if (_last_connect == 0 || now - _last_connect >= 2000)
            return _connect (now);
        $.logi(logTag, '距离上次播放连接太近, 2秒后开始连接');
        _connect_timer = setTimeout (function ():void {
            if (_connect_timer != 0)
                _connect (getTimer ());
        }, 2000);
    }
    private final function _connect (now:int):void
    {
        if (_connect_timer != 0)
        {
            clearTimeout (_connect_timer);
            _connect_timer = 0;
        }
        $.logi(logTag, '连接服务器中...');
        _ncpool = new NetConnectionPool ($, this);
        _ncpool.key = key;
        _ncpool.connect (servers, protos);
        _last_connect = now;
    }
    public function close ():void
    {
        if (_connect_timer != 0)
        {
            clearTimeout (_connect_timer);
            _connect_timer = 0;
        }
        if (_ncpool != null)
        {
            _ncpool.close ();
            _ncpool = null;
        }
        if (_nc != null)
        {
            _nc.dispose ();
            _nc = null;
            $.logi (logTag, "关闭连接");
        }
        stopClientTimer ();
    }
    public function get uri ():String
    {
        return _nc ? _nc.uri : 'N/A';
    }
    public function get key ():String
    {
        return "N/A";
    }
    protected function get servers ():ServerList
    {
        return null;
    }
    protected function get protos ():Array
    {
        return null;
    }
    protected function get logTag ():String
    {
        return "NetClient: ";
    }
    protected function handlePingPacket (pkt:ByteArray):void
    {
        handlePing (pkt.readInt ());
    }
    protected function handlePingResponsePacket (pkt:ByteArray):void
    {
        handlePingResponse (pkt.readInt ());
    }
    protected function pingPacket ():ByteArray
    {
        var pkt:ByteArray = new LEByteArray;
        pkt.writeByte(5);
        pkt.writeInt(4);
        pkt.writeInt(getTimer() - _ts_epoch);
        return pkt;
    }
    protected function startClientTimer ():void
    {
        addClientTimer (this);
        _tsi = new Vector.<int>;
        _tso = new Vector.<int>;
        _ts_epoch = _last_ping_in = getTimer();
    }
    [Inline]
    protected final function stopClientTimer ():void
    {
        delClientTimer (this);
        _tsi = null;
        _tso = null;
    }

    protected final function get timerStarted():Boolean
    {
        return _tsi != null;
    }

    nc_internal override function handleTimer (seq:uint):void
    {
        if (seq % _ping_timer_interval == 1)
            _nc.sendPing(getTimer() - _ts_epoch);
    }
    ncp_internal override function onConnectDone (nc:INetConnection, count:uint):void
    {
        super.ncp_internal::onConnectDone (nc, count);
        var rtmp:NetConnection = nc as NetConnection;
        if (rtmp != null)
        {
            rtmp.client.Ping = handlePing;
            rtmp.client.PingResponse = handlePingResponse;
        }
        _ncpool.close ();
        _ncpool = null;
    }
    ncp_internal override function onConnectFail ():void
    {
        _ncpool.close ();
        _ncpool = null;
    }

    protected function updateJitterValue (value:Array, time:int, direction:int):void
    {
    }
    private function calcJitterValue (items:Vector.<int>):Array
    {
        var jv1:uint, jv2:uint, jv3:uint;
        jv3 = Misc.sd (items, 0);
        if (items.length <= 3)
            return [jv3];
        jv1 = Misc.sd (items, 3);
        if (items.length <= 6)
            return [jv1, jv3];
        jv2 = Misc.sd (items, 6);
        return [jv1, jv2, jv3];
    }
    private function handlePing (time:int):void
    {
        // 20 秒一个 ping 包,保留最多15个数据,也就是5分钟的数据
        _last_ping_in = getTimer ();
        _tsi.push (_last_ping_in - _ts_epoch - time);
        if (_tsi.length > 15) _tsi.shift();
        updateJitterValue (calcJitterValue (_tsi), _last_ping_in, 0);
    }
    private function handlePingResponse (diff:int):void
    {
        // 20 秒一个 ping 包,保留最多15个数据,也就是5分钟的数据
        _tso.push (diff);
        if (_tso.length > 15) _tso.shift();
        updateJitterValue (calcJitterValue (_tso), getTimer (), 1);
    }
    static private function onTimer ():void
    {
        ++timerSeq;
        for (var o:Object in clients)
        {
            var c:uint = clients[o];
            var nc:NetConnectionHandler = o as NetConnectionHandler;
            nc.nc_internal::handleTimer (timerSeq - c);
        }
    }
    static private function addClientTimer (client:Object):void
    {
        if (client in clients)
            return;
        if (client_count == 0)
        {
            timerSeq = 0;
            timerId = setInterval (onTimer, 1000);
        }
        ++client_count;
        clients[client] = timerSeq;
    }
    static private function delClientTimer (client:Object):void
    {
        if (!(client in clients))
            return;
        delete clients[client];
        --client_count;
        if (client_count == 0)
            clearInterval (timerId);
    }
}
}
