package com.e2et.net
{
/**
 * 按优先级管理服务器列表。影响优先级的因素包含地域、网速、网络稳定性、房间等等。
 * @author Bin Tian
 */
public class ServerList
{
    private var _servers:Array = [];

    public function addServer (server:String, priority:int):void
    {
        var i:int, c:int = _servers.length;
        for (i=0; i<c; ++i)
        {
            if (_servers[i].server == server)
            {
                _servers[i].priority = priority;
                break;
            }
        }
        _servers.push ({ server: server, priority: priority });
    }
    public function delServer (server:String):void
    {
        var i:int, c:int = _servers.length;
        for (i=0; i<c; ++i)
        {
            if (_servers[i].server == server)
            {
                _servers.splice(i, 1);
                break;
            }
        }
    }
    /**
     * 提高服务器优先级
     * @param server
     */
    public function incPriority (server:String):void
    {
        var i:int, c:int = _servers.length;
        for (i=0; i<c; ++i)
        {
            if (_servers[i].server == server)
            {
                _servers[i].priority--;
                break;
            }
        }
    }
    /**
     * 降低服务器优先级
     * @param server
     */
    public function decPriority (server:String):void
    {
        var i:int, c:int = _servers.length;
        for (i=0; i<c; ++i)
        {
            if (_servers[i].server == server)
            {
                _servers[i].priority++;
                break;
            }
        }
    }
    /**
     * 按优先级返回服务器列表
     * @param protos
     * @return 返回一个数组，数组中每个元素是一个服务器数组
     */
    public function serversByPriority (protos:Array = null):Array
    {
        var o:Object = {}, keys:Array = [], ar:Array = [], svr:String, pri:int;
        var i:int, c:int = _servers.length;
        for (i=0; i<c; ++i)
        {
            svr = _servers[i].server;
            pri = _servers[i].priority;
            if (protos != null && protos.length)
            {
                var ok:Boolean = false;
                for each (var proto:String in protos)
                {
                    if (svr.indexOf(proto) == 0)
                    {
                        ok = true;
                        break;
                    }
                }
                if (!ok) continue;
            }
            if (o.hasOwnProperty(pri))
            {
                o[pri].push (svr);
            }
            else
            {
                o[pri] = [svr];
                keys.push (pri);
            }
        }
        keys.sort (function (a:int, b:int):int {
            return a - b;
        });
        for each (pri in keys)
        {
            ar.push (o[pri]);
        }
        return ar;
    }
    public function updateWithSpeedTestResult (result:Object):void
    {
        var pri:int = int.MIN_VALUE;
        var i:int, c:int = _servers.length;
        var keys:Object = {};
        for (i=0; i<c; ++i)
        {
            var svr:String = _servers[i].server;
            if (svr.substr(0, 6) == "tcp://")
            {
                pri = Math.max(pri, _servers[i].priority);
                keys[svr] = true;
            }
        }
        var list:Array = [];
        for (svr in keys)
        {
            if (result[svr])
                list.push (result[svr]);
            delServer (svr);
        }
        if (list.length == 0)
            return;
        list.sort (function (a:Array, b:Array):int {
            var d:Number = a[4] - b[4];
            if (d == 0)
                d = b[1] - a[1];
            if (d < 0)
                return -1;
            else if (d > 0)
                return 1;
            else
                return 0;
        });
        list.reverse();
        var last:int = list[0][4];
        c = list.length;
        for (i=0; i<c; ++i)
        {
            var ar:Array = list[i];
            if (ar[4] != last)
            {
                last = ar[4];
                --pri;
            }
            _servers.push ({server:ar[5], priority: pri});
        }
    }
}
}
