package com.e2et.net.proxy
{
import com.e2et.Session;
import com.e2et.net.nc_internal;
import com.e2et.net.connection.UdpConnection;
import com.e2et.net.media.audio.MicCapture;
import com.e2et.net.media.video.ScreenCapture;

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.NetStatusEvent;
import flash.events.StatusEvent;
import flash.net.NetConnection;
import flash.net.ObjectEncoding;
import flash.net.Responder;
import flash.utils.ByteArray;
import flash.utils.Dictionary;
import flash.utils.Endian;

[ExcludeClass]
public class MediaProxyClient extends NetConnection
{
    private var voe:VOEPlugin;
    public var screencap:ScreenCapture = null;

    private var $:Session;
    private var _majorVer:Number, _minorVer:Number;
    private var _ipcams:Array;
    private var _utp_conns:Object = { };
    private var _nextUtpId:uint = 0;

    public function MediaProxyClient ($:Session)
    {
        this.$ = $;
        this.objectEncoding = ObjectEncoding.AMF3;
        setup (this.addEventListener);

        this.client = {
            mp: handleMPCommand,
            onBWDone: function ():void { }
        };
        voe = new VOEPlugin (this);
    }

    public function get majorVer ():Number
    {
        return _majorVer;
    }
    public function get minorVer ():Number
    {
        return _minorVer;
    }
    public function get version():String
    {
        return _majorVer + '.' + _minorVer;
    }
    public function get audiocap():MicCapture
    {
        return voe ? voe.audiocap : null;
    }
    public function set audiocap(cap:MicCapture):void
    {
        voe.audiocap = cap;
    }
    override public function connect (url:String, ...args):void
    {
        args.unshift(url);
        args.push('_result');
        args.push(1.0);
        args.push({
            fmsVer: 'FMS/4,0,3,4010',
            capabilities: 255,
            mode: 1
        });
        args.push({
            level: 'status',
            code: 'NetConnection.Connect.Success',
            description: 'Connection succeeded',
            objectEncoding: 3.0,
            data: {version: '4,0,3,4010'}
        });
        super.connect.apply(this, args);
    }
    private function setup (func:Function):void
    {
        func (NetStatusEvent.NET_STATUS, onStatus);
        func (IOErrorEvent.IO_ERROR, onIOError);
    }
    public function get ipcams():Array
    {
        return _ipcams;
    }
    private function onStatus (e:NetStatusEvent):void
    {
        switch (e.info.code)
        {
        case 'NetConnection.Connect.Success':
            $.logi('插件连接成功: 编译于 ', e.info.buildDate, ' ', e.info.buildTime,
                ' API版本: ', e.info.majorVer, '.', e.info.minorVer);
            _majorVer = ('majorVer' in e.info) ? e.info.majorVer : 0;
            _minorVer = ('minorVer' in e.info) ? e.info.minorVer : 0;
            _ipcams = ('ipcams' in e.info) ? e.info.ipcams : [];
            this.dispatchEvent(new Event(Event.CONNECT));
            break;
        case 'NetConnection.Connect.Failed':
            this.removeEventListener(IOErrorEvent.IO_ERROR, onIOError);
            this.dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR));
            this.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
            break;
        case 'NetConnection.Connect.Closed':
            if (audiocap)
                $.dispatchEvent(new Event('audioCapStop'));
            this.dispatchEvent(new Event(Event.CLOSE));
            break;
        }
    }
    private function onIOError (e:IOErrorEvent):void
    {
        this.dispatchEvent(e.clone());
    }

    override public function dispatchEvent (e:Event):Boolean
    {
        for each (var o:Object in _utp_conns)
        {
            var nc:UdpConnection = o as UdpConnection;
            nc.dispatchEvent (e.clone());
        }
        return super.dispatchEvent(e);
    }

    [Inline]
    public final function loadPlugin (data:ByteArray):void
    {
        call(CMD_LOAD_PLUGIN, null, data);
    }
    [Inline]
    public final function startPlugin (id:String):void
    {
        function onClose (e:Event):void
        {
            dispatchEvent(new StatusEvent ("startPlugin", false, false, "false"));
            removeEventListener(Event.CLOSE, onClose);
            removeEventListener(IOErrorEvent.IO_ERROR, onClose);
        }
        function result (success:Boolean):void
        {
            removeEventListener(Event.CLOSE, onClose);
            removeEventListener(IOErrorEvent.IO_ERROR, onClose);
            dispatchEvent(new StatusEvent ("startPlugin", false, false, success.toString()));
        }
        call(CMD_START_PLUGIN, new Responder(result), id);
    }
    [Inline]
    public final function stopPlugin (id:String):void
    {
        call(CMD_STOP_PLUGIN, null, id);
    }
    [Inline]
    public final function startPlayout (id:uint):void
    {
        voe.startPlayout(id);
    }
    [Inline]
    public final function playAudio (id:uint, time:uint, pkt:ByteArray, offset:uint, length:uint):void
    {
        voe.playAudio(id, time, pkt, offset, length);
    }
    [Inline]
    public final function flushPlayout (id:uint):void
    {
        voe.flushPlayout(id);
    }
    [Inline]
    public final function stopPlayout (id:uint):void
    {
        voe.stopPlayout(id);
    }
    [Inline]
    public final function initScreenCap ():void
    {
        call('mp', null, ui_packet(CMD_SCREENCAP_INIT, 0));
    }
    [Inline]
    public final function startScreenCap ():void
    {
        call('mp', null, ui_packet(CMD_SCREENCAP_START, 0));
    }
    [Inline]
    public final function stopScreenCap ():void
    {
        call('mp', null, ui_packet(CMD_SCREENCAP_STOP, 0));
    }
    [Inline]
    public final function startAudioCap(name:String):void
    {
        voe.startAudioCap(name);
        $.dispatchEvent(new Event('audioCapStart'));
    }
    [Inline]
    public final function stopAudioCap():void
    {
        voe.stopAudioCap();
        $.dispatchEvent(new Event('audioCapStop'));
    }
    [Inline]
    public final function takeScreenShot():void
    {
        call('mp', null, ui_packet(CMD_SCREENSHOT_TAKE, 0));
    }

    [Inline]
    public final function newUdpConnection(server:String):UdpConnection
    {
        var ar:Array = /^udp:\/\/\[([0-9a-fA-F:])+\]:(\d+)$/.exec(server);
        if (!ar) ar = /^udp:\/\/(.*):(\d+)$/.exec(server);
        if (!ar) throw new Error('bad udp address');
        var nc:UdpConnection = new UdpConnection (_nextUtpId++, server, this);
        call('mp', null, ui_packet(CMD_UTP, nc.id), ar[1], ar[2]);
        _utp_conns[nc.id] = nc;
        return nc;
    }
    [Inline]
    public final function closeUdpConnection(nc:UdpConnection):void
    {
        call('mp', null, ui_packet(CMD_UTP, nc.id), null);
        delete _utp_conns[nc.id];
    }
    [Inline]
    public final function sendUdpData(nc:UdpConnection, data:ByteArray):void
    {
        call('mp', null, ui_packet(CMD_UTP, nc.id), data);
    }
    private function handleMPCommand (data:ByteArray, ...args):void
    {   // 注意: data 是大端
        switch(data[0])
        {
        case CMD_AUDIO_TAG:
            data.endian = Endian.LITTLE_ENDIAN;
            if (audiocap != null)
                audiocap.handleMediaData(data);
            break;
        case CMD_VIDEO_TAG:
            data.endian = Endian.LITTLE_ENDIAN;
            if (screencap != null)
                screencap.handleMediaData(data);
            break;
        case CMD_SCREENCAP_INIT:
            if (screencap != null)
                screencap.capCallback(data[1]);
            break;
        case CMD_AMF0_COMMAND:
        case CMD_AMF3_COMMAND:
            handleRtmpCommand (data);
            break;
        case CMD_UTP:
            handleUTP(data, args);
            break;
        }
    }

    private function handleUTP(data:ByteArray, args:Array):void
    {
        data.endian = Endian.LITTLE_ENDIAN;
        data.position = 2;
        var id:uint = data.readUnsignedInt();
        var nc:UdpConnection = _utp_conns[id];
        if (nc)
        {
            switch (data[1])
            {
            case 0:
                nc.dispatchEvent(new Event(Event.CONNECT));
                break;
            case 1:
                args[0].endian = Endian.LITTLE_ENDIAN;
                nc.nc_internal::handlePacket(data[6], args[0]);
                break;
            case 2:
                nc.dispatchEvent(new Event(Event.CLOSE));
                break;
            }
        }
    }
    private var nextId:uint = 1;
    private var streams:Dictionary = new Dictionary;
    private var names:Object = { };

    private function handleRtmpCommand (b:ByteArray):void
    {
        b.position = 5;
        var stm:uint = b.readUnsignedInt();
        b.objectEncoding = ObjectEncoding.AMF0;
        var name:String = b.readObject();
        var tid:Number = b.readObject();
        var cmd:Object = b.readObject();
        var args:Array = [stm, name, tid, cmd, b];
        while (b.position < b.length)
        {
            if (b[b.position] == 0x11)
            {
                b.objectEncoding = ObjectEncoding.AMF3;
                b.readByte();
                args.push (b.readObject());
                b.objectEncoding = ObjectEncoding.AMF0;
            }
            else
                args.push (b.readObject());
        }
        switch (name)
        {
        case 'createStream':
            if (_createStream.apply(this, args))
                this.call ('mp', null, b);
            break;
        case 'publish':
            if (_publish.apply(this, args))
                this.call ('mp', null, b);
            break;
        }
    }
    private function _createStream (stm:uint, name:String, tid:Number, cmd:Object, b:ByteArray, ...args):Boolean
    {
        b[0] = CMD_AMF0_COMMAND;

        b.position = 9;
        b.writeObject ("_result");
        b.writeObject (tid);
        b.writeObject (null);
        stm = nextId++;
        b.writeObject (stm);
        b.length = b.position;
        streams[stm] = '';
        return true;
    }
    private function _publish (stm:uint, name:String, tid:Number, cmd:Object, b:ByteArray, ...args):Boolean
    {
        b[0] = CMD_AMF0_COMMAND;

        b.position = 9;
        b.writeObject ("onStatus");
        b.writeObject (0);
        b.writeObject (null);
        if (args.length == 0)
        {
            b.writeObject ({
                level:'error',
                code:'NetStream.Publish.Failed',
                description: 'missing stream name'
            });
            b.length = b.position;
            return true;
        }
        if (!streams.hasOwnProperty(stm))
        {
            b.writeObject({
                level: 'error',
                code: 'NetStream.Publish.BadStream'
            });
            b.length = b.position;
            return true;
        }
        if (args[0] === false)
        {
            if (streams[stm])
            {
                delete names[streams[stm]];
                streams[stm] = '';
            }
            b.writeObject ({
                level:'status',
                code:'NetStream.Unpublish.Success'
            });
            b.length = b.position;
            return true;
        }

        if (!(args[0] is String))
        {
            b.writeObject ({
                level:'error',
                code:'NetStream.Publish.BadName'
            });
            b.length = b.position;
            return true;
        }
        name = args[0] as String;
        if (!name || names[name])
        {
            b.writeObject ({
                level:'error',
                code:'NetStream.Publish.BadName'
            });
            b.length = b.position;
            return true;
        }

        names[name] = stm;
        streams[stm] = name;
        b.writeObject ({
            level:'status',
            code:'NetStream.Publish.Start'
        });
        b.length = b.position;
        return true;
    }
}
}
import com.e2et.utils.LEByteArray;

import flash.utils.ByteArray;

const CMD_LOAD_PLUGIN:String = '@';
const CMD_START_PLUGIN:String = 'A';
const CMD_STOP_PLUGIN:String = 'B';

const CMD_AUDIO_TAG:int = 8;
const CMD_VIDEO_TAG:int = 9;

const CMD_AMF0_COMMAND:int = 20;
const CMD_AMF3_COMMAND:int = 17;

const CMD_UTP:int = 0x81;

const CMD_SCREENCAP_INIT:int = 0x85;
const CMD_SCREENCAP_START:int = 0x86;
const CMD_SCREENCAP_STOP:int = 0x87;

const CMD_SCREENSHOT_TAKE:int = 0x8a;

[Inline]
function ui_packet (cmd:int, ui:uint):ByteArray
{
    var o:ByteArray = new LEByteArray;
    o.writeByte(cmd);
    o.writeUnsignedInt(ui);
    return o;
}

[Inline]
function utf_packet (cmd:int, utf:String):ByteArray
{
    var o:ByteArray = new LEByteArray;
    o.writeByte(cmd);
    o.writeUTF(utf == null ? '' : utf);
    return o;
}
