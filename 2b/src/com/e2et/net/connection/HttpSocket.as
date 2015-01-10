package com.e2et.net.connection
{
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.Socket;
import flash.system.Security;
import flash.utils.ByteArray;
import flash.utils.Endian;

internal class HttpSocket extends EventDispatcher
{
    private var _sock:Socket;
    private var _header_done:Boolean;
    private var _headers:Vector.<String> = new Vector.<String>;
    private var _state:int, _type:int, _size:uint;
    private var _bytes:ByteArray = new ByteArray;
    private var _procData:Function = null;

    private var _host:String, _port:int, _path:String
    private var _sid:uint = 0;
    private var _seq:uint = 0;
    private var _data:ByteArray;

    public function HttpSocket (host:String, port:int, path:String, procData:Function = null)
    {
        _path = path;
        Security.loadPolicyFile('xmlsocket://' + host + ':' + port);
        _sock = new Socket;
        _sock.endian = Endian.LITTLE_ENDIAN;
        _sock.connect (host, port);
        setupEventListener (_sock.addEventListener);
        _procData = procData;
    }

    public function setData (sid:uint, seq:uint, data:ByteArray):void
    {
        _sid = sid;
        _seq = seq;
        _data = data;
    }
    public function retry ():void
    {
        if (_sock != null)
        {
            setupEventListener (_sock.removeEventListener);
            try { _sock.close (); } catch (e:Error) { };
            _sock = null;
            _headers.length = 0;
            _headers = null;
        }
        _sock = new Socket;
        _sock.endian = Endian.LITTLE_ENDIAN;
        _sock.connect (_host, _port);
    }
    public function close ():void
    {
        if (_sock != null)
        {
            setupEventListener (_sock.removeEventListener);
            try { _sock.close (); } catch (e:Error) { };
            _sock = null;
            _headers.length = 0;
            _headers = null;
            _bytes = null;
            _procData = null;
        }
    }
    public final function get headers ():Vector.<String>
    {
        return _headers;
    }
    private function setupEventListener (func:Function):void
    {
        func (Event.CONNECT, onConnect);
        func (IOErrorEvent.IO_ERROR, onIOError);
        func (ProgressEvent.SOCKET_DATA, handleData);
        func (SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
    }
    private function onConnect (e:Event):void
    {
        if (this.hasEventListener (Event.CONNECT))
            this.dispatchEvent (e.clone ());
        _sock.writeUTFBytes ("POST " + _path + " HTTP/1.1\r\n");
        if (_port == 80)
            _sock.writeUTFBytes ("Host: " + _host + "\r\n");
        else
            _sock.writeUTFBytes ("Host: " + _host + ":" + _port + "\r\n");
        _sock.writeUTFBytes ("Accept: text/raw\r\n");
        _sock.writeUTFBytes ("Accept-Encoding: identity\r\n");
        _sock.writeUTFBytes ("Session: " + _sid + "\r\n");
        _sock.writeUTFBytes ("SequenceNumber: " + _seq + "\r\n");
        _sock.writeUTFBytes ("ContentType: text/raw\r\n");
        _sock.writeUTFBytes ("Content-Length: " + _data.length + "\r\n\r\n");
        _sock.writeBytes (_data);
        _sock.flush ();
    }
    private function onIOError (e:IOErrorEvent):void
    {
        ioError (e.text, e.errorID);
    }
    private function onSecurityError (e:Event):void
    {
        ioError ('security', 2);
    }
    private function onHeaderDone ():void
    {
        _header_done = true;
        _state = 0;
        _bytes.endian = Endian.LITTLE_ENDIAN;
        _bytes.length = 0;
        if (this.hasEventListener (Event.OPEN))
            this.dispatchEvent (new Event (Event.OPEN));
    }
    private function ioError (text:String = '', code:int = 0):void
    {
        if (this.hasEventListener (IOErrorEvent.IO_ERROR))
            this.dispatchEvent (new IOErrorEvent (IOErrorEvent.IO_ERROR, false, false, text, code));
    }
    private function readHeader ():Boolean
    {
        while (_sock.bytesAvailable)
        {
            var c:int = _sock.readByte ();
            if (c == 0x0d)
                _state = 1;
            else if (c == 0x0a && _state == 1)
                _state = 2;
            else
                _state = 0;
            _bytes.writeByte (c);
            if (_state == 2)
            {
                if (_bytes.length == 2)
                {
                    onHeaderDone ();
                    return true;
                }
                _bytes.position = 0;
                var s:String = _bytes.readUTFBytes (_bytes.length - 2);
                _bytes.length = 0;
                _headers.push (s);
                if (_headers.length == 1)
                {
                    if (s != 'HTTP/1.1 200 OK')
                    {
                        ioError ('HTTP status line', 1);
                        return false;
                    }
                }
            }
        }
        return false;
    }
    private function handleData (e:ProgressEvent):void
    {
        while (_sock.connected)
        {
            if (!_header_done)
            {
                if (readHeader ())
                    continue;
            }
            else
            {
                switch (_state)
                {
                case 0:
                    if (_sock.bytesAvailable < 1)
                    {
                        if (_procData)
                            _procData (this, 0, null);
                        return;
                    }
                    _type = _sock.readUnsignedByte();
                    _state = 1; // 不用 break, 进入 case 1

                case 1:
                    if (_sock.bytesAvailable < 4)
                    {
                        if (_procData)
                            _procData (this, 0, null);
                        return;
                    }
                    _size = _sock.readUnsignedInt();
                    _state = 2; // 不用 break, 进入 case 2

                case 2:
                    if (_sock.bytesAvailable < _size)
                    {
                        if (_procData)
                            _procData (this, 0, null);
                        return;
                    }
                    if (_size)
                        _sock.readBytes(_bytes, 0, _size);
                    if (_procData !== null)
                    {
                        _bytes.position = 0;
                        _bytes.length = _size;
                        /* 处理该数据包时，有可能将 Socket 关闭，所以要用 while (this.connected) 循环 */
                        _procData (this, _type, _bytes);
                    }
                    _state = 0;
                    break;
                }
            }
        }
    }
}
}
