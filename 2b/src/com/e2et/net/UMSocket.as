package com.e2et.net
{
import flash.events.ProgressEvent;
import flash.net.Socket;
import flash.utils.ByteArray;
import flash.utils.Endian;

public class UMSocket extends Socket
{
    private var _state:int = 0, _type:uint, _size:uint;
    private var _body:ByteArray;
    private var _procData:Function = null;

    public function UMSocket()
    {
        super();
        this.endian = Endian.LITTLE_ENDIAN; // 默认小端
        this.addEventListener(ProgressEvent.SOCKET_DATA, handleData);
    }
    public function reset():void
    {
        _state = 0;
        _body = new ByteArray;
        _body.endian = this.endian;
    }
    public function set dataHandler (func:Function):void
    {
        _procData = func;
    }
    override public function close():void
    {
        super.close();
        _state = 0;
        _body = null;
    }
    private function handleData (event:ProgressEvent):void
    {
        while (this.connected)
        {
            switch (_state)
            {
            case 0:
                if (this.bytesAvailable < 1)
                {
                    if (_procData)
                        _procData (this, 0, null);
                    return;
                }
                _type = this.readUnsignedByte();
                _state = 1; // 不用 break, 进入 case 1

            case 1:
                if (this.bytesAvailable < 4)
                {
                    if (_procData)
                        _procData (this, 0, null);
                    return;
                }
                _size = this.readUnsignedInt();
                _state = 2; // 不用 break, 进入 case 2

            case 2:
                if (this.bytesAvailable < _size)
                {
                    if (_procData)
                        _procData (this, 0, null);
                    return;
                }
                if (_size)
                    this.readBytes(_body, 0, _size);
                if (_procData !== null)
                {
                    _body.position = 0;
                    _body.length = _size;
                    /* 处理该数据包时，有可能将 Socket 关闭，所以要用 while (this.connected) 循环 */
                    _procData(this, _type, _body);
                }
                _state = 0;
                break;
            }
        }
    }
}
}
