package
{
import flash.net.NetConnection;

public function fakeNC():NetConnection
{
    if (_fake_nc === null)
    {
        _fake_nc = new NetConnection;
        _fake_nc.connect (null);
    }
    return _fake_nc;
}
}
import flash.net.NetConnection;

var _fake_nc:NetConnection = null;
