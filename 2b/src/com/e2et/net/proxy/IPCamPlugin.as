package com.e2et.net.proxy
{
import com.e2et.net.media.video.IPCamCapture;

import flash.utils.ByteArray;
import flash.utils.Dictionary;
import flash.utils.Endian;

public class IPCamPlugin
{
    static private var dict:Dictionary = new Dictionary(true);
    static private var caps:Object = { };
    static private var nextId:uint = 1;
    private var mpc:MediaProxyClient;
    private var pluginId:String;
    private var pluginCmd:String;
    private var id:uint;

    public function IPCamPlugin(mpc:MediaProxyClient, pluginId:String, pluginCmd:String, cap:IPCamCapture)
    {
        this.mpc = mpc;
        this.pluginId = pluginId;
        this.pluginCmd = pluginCmd;
        if (!(mpc in dict))
        {
            var info:Object = { };
            info[pluginId] = 0;
            dict[mpc] = info;
        }
        id = nextId++;
        caps[id] = cap;
        mpc.client[pluginCmd] = handleCommand;
    }
    [Inline]
    public final function startCap (name:String):void
    {
        var info:Object = dict[mpc];
        if (info[pluginId] === 0)
            mpc.startPlugin(pluginId);
        info[pluginId]++;
        mpc.call (pluginCmd, null, CMD_START_CAP, id, name);
    }
    [Inline]
    public final function stopCap():void
    {
        var info:Object = dict[mpc];
        mpc.call(pluginCmd, null, CMD_STOP_CAP, id);
        if (info[pluginId]-- == 1)
            mpc.stopPlugin(pluginId);
    }
    static private function handleCommand(id:uint, data:ByteArray):void
    {
        var cap:IPCamCapture = caps[id];
        if (cap)
        {
            data.endian = Endian.LITTLE_ENDIAN;
            cap.handleMediaData (data);
        }
    }
}
}

const CMD_START_CAP:String = 'A';
const CMD_STOP_CAP:String = 'B';
