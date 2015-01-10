package com.e2et.net.connection
{
import com.e2et.Session;
import com.e2et.net.ServerList;
import com.e2et.net.ncp_internal;
import com.e2et.utils.LEByteArray;

import flash.crypto.generateRandomBytes;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.NetStatusEvent;
import flash.events.SecurityErrorEvent;
import flash.events.TimerEvent;
import flash.net.NetConnection;
import flash.system.Security;
import flash.utils.ByteArray;
import flash.utils.Timer;
import flash.utils.clearTimeout;
import flash.utils.setTimeout;

[ExcludeClass]
/**
 * 网络连接池，同时连接多个服务器。
 * @author Bin Tian
 */
public class NetConnectionPool
{
    private var _servers:Array;
    private var _timer:Timer;
    private var _ncs:Object = {};
    private var _count:uint = 0;
    private var _closing:Boolean = false;
    private var _handler:NetConnectionPoolHandler;
    private var $:Session;
    public var key:String;

    public function NetConnectionPool ($:Session, handler:NetConnectionPoolHandler)
    {
        this.$ = $;
        _handler = handler;
    }
    /**
     * 连接网络连接
     * @param servers 服务器列表
     * @param username 可选参数，用户名
     */
    public function connect (servers:ServerList, protos:Array = null):void
    {
        if (_timer == null)
        {
            _timer = new Timer($.ncpDelay, 1);
            _timer.addEventListener(TimerEvent.TIMER, onTimer);
        }
        _servers = servers.serversByPriority(protos);
        if (_servers.length == 0)
        {
            throw new Error('服务器列表空');
            return;
        }
        _connectServers (_servers.shift());
    }
    /**
     * 关闭操作，取消任何正在进行的连接
     */
    public function close():void
    {
        if (_timer != null)
        {
            _timer.reset();
            _timer.removeEventListener(TimerEvent.TIMER, onTimer);
            _timer = null;
        }
        var keys:Array = [];
        for (var key:String in _ncs) keys.push (key);
        _closing = true;
        for each (key in keys)
        {
            var nc:EventDispatcher = _ncs[key];
            if (nc is NetConnection)
                (nc as NetConnection).close();
            else
                nc.dispatchEvent(new Event('dispose'));
            if (_ncs.hasOwnProperty(key))
            {
                delete _ncs[key];
                --_count;
            }
        }
        _closing = false;
    }
    static public function testSpeedPacket ():ByteArray
    {
        var bytes:ByteArray = new LEByteArray;
        var len:int = 1600;
        bytes.length = len;
        bytes.writeByte (62);
        bytes.writeUnsignedInt(len-5);
        bytes.writeBytes (flash.crypto.generateRandomBytes(1024));
        return bytes;
    }
    private function onTimer(e:TimerEvent):void
    {
        _connectServers (_servers.shift ());
    }
    private function _connectServers (servers:Array):void
    {
        var c:int = 0;
        for each (var server:String in servers)
        {
            var s6:String = server.substr(0, 6);
            var s7:String = server.substr(0, 7);
            if (s6 == 'tcp://')
                _tcpConnect (server), ++c;
            else if (s6 == 'udp://' && $.mpc)
                _udpConnect (server), ++c;
            else if (s7 == 'http://')
                _httpConnect (server), ++c;
            else if (s7 == 'rtmp://' || server.substr(0, 8) == 'rtmfp://')
                _rtmpConnect (server), ++c;
        }
        if (c == 0)
            throw new Error('没有有效的服务器');
        if (_servers.length)
        {
            _timer.reset ();
            _timer.start ();
        }
    }
    /**
     * @private 建立 HTTP 连接
     * @param server 服务器地址
     */
    private function _httpConnect (server:String):void
    {
        var nc:HttpConnection = new HttpConnection(server);
        _ncs[server] = nc;
        ++_count;
        function onSessionStarted (e:Event):void
        {
            if (_ncs.hasOwnProperty (server))
            {
                setup (nc.removeEventListener);
                delete _ncs[server];
                --_count;
                _handler.ncp_internal::onConnectDone(nc, _count);
            }
        }
        function onError (e:Event):void
        {
            if (_ncs.hasOwnProperty(server))
            {
                nc.dispose();
                setup (nc.removeEventListener);
                removeConnection (server);
            }
        }
        function setup (func:Function):void
        {
            func(Event.CONNECT, onSessionStarted);
            func(IOErrorEvent.IO_ERROR, onError);
            func('dispose', onError);
        }
        setup (nc.addEventListener);
    }
    /**
     * 建立 TCP 连接。
     * @param server 服务器地址 (tcp://[ipv6]:port 或者 tcp://ipv4:port)
     */
    private function _tcpConnect (server:String):void
    {
        var ar:Array = /^tcp:\/\/\[([0-9a-fA-F:])+\]:(\d+)$/.exec(server);
        if (!ar) ar = /^tcp:\/\/(.*):(\d+)$/.exec(server);
        if (!ar) throw new Error('bad tcp address');
        var nc:TcpConnection = new TcpConnection;
        nc.reset();
        nc.server = server;
        _ncs[server] = nc;

        Security.loadPolicyFile('xmlsocket://' + ar[1] + ':' + ar[2]);

        ++_count;
        function onConnected (e:Event):void
        {
            if (_ncs.hasOwnProperty (server))
            {
                setup (nc.removeEventListener);
                delete _ncs[server]; --_count;
                _handler.ncp_internal::onConnectDone(nc, _count);
            }
        }
        function onError (e:Event):void
        {
            if (_ncs.hasOwnProperty(server))
            {
                nc.dispose();
                setup (nc.removeEventListener);
                removeConnection (server);
            }
        }
        function setup (func:Function):void
        {
            func(Event.CONNECT, onConnected);
            func(IOErrorEvent.IO_ERROR, onError);
            func(SecurityErrorEvent.SECURITY_ERROR, onError);
            func('dispose', onError);
        }
        setup (nc.addEventListener);
        nc.connect(ar[1], ar[2]);
    }
    private function _udpConnect (server:String):void
    {
        var nc:UdpConnection = $.mpc.newUdpConnection (server);
        _ncs[server] = nc;

        ++_count;
        function onConnected (e:Event):void
        {
            if (_ncs.hasOwnProperty (server))
            {
                setup (nc.removeEventListener);
                delete _ncs[server]; --_count;
                _handler.ncp_internal::onConnectDone(nc, _count);
            }
        }
        function onError (e:Event):void
        {
            if (_ncs.hasOwnProperty(server))
            {
                nc.dispose();
                setup (nc.removeEventListener);
                removeConnection (server);
            }
        }
        function setup (func:Function):void
        {
            func(Event.CONNECT, onConnected);
            func(IOErrorEvent.IO_ERROR, onError);
            func('dispose', onError);
        }
        setup (nc.addEventListener);
    }
    /**
     * @private 建立 RTMP 连接。
     * @param server 服务器地址 (rtmp:// 或者 rtmfp://)
     */
    private function _rtmpConnect (server:String):void
    {
        var nc:RtmpConnection = new RtmpConnection;
        ++_count;
        _ncs[server] = nc;
        var timer:uint = setTimeout(function ():void {
            nc.close();
            clearTimeout(timer);
        }, 15000);
        function handleNetStatus (e:NetStatusEvent):void
        {
            switch (e.info.code)
            {
            case 'NetConnection.Connect.Success':
                clearTimeout (timer);
                nc.removeEventListener(NetStatusEvent.NET_STATUS, handleNetStatus);
                delete _ncs[server]; --_count;
                nc.remoteAddr = [e.info.result.address, e.info.result.port].join(':');
                _handler.ncp_internal::onConnectDone(nc, --_count);
                break;
            default:
                clearTimeout (timer);
                nc.removeEventListener(NetStatusEvent.NET_STATUS, handleNetStatus);
                if (_ncs.hasOwnProperty(server))
                    removeConnection (server);
                break;
            }
        }
        nc.addEventListener(NetStatusEvent.NET_STATUS, handleNetStatus);
        var userinfo:String = [$.user.userid, $.user.name].join(',');
        nc.connect (server, userinfo, $.room.id, $.room.org, key); trace('key', key);
    }

    private function removeConnection(server:String):void
    {
        delete _ncs[server]; --_count;
        if (!_closing && _count == 0)
        {
            if (_timer.running)
            {
                _timer.stop();
                _connectServers (_servers.shift());
            }
            else
                _handler.ncp_internal::onConnectFail();
        }
    }
}
}
