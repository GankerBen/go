package com.e2et.net
{
import flash.external.ExternalInterface;

public class ULog
{
    static public const level_names:Array = ['', 'error', 'warn', 'info', 'verbose', 'debug'];

    static public const E:uint = 1; // 错误
    static public const W:uint = 2; // 警告
    static public const I:uint = 3; // 信息
    static public const V:uint = 4; // 详细
    static public const D:uint = 5; // 调试

    public var trace_level:uint = 5;
    public var console_level:uint = 5;
    public var log_level:uint = 5;

    public function ULog (sid:String)
    {
        _sid = sid;
    }

    private var _sid:String;

    public final function vlog (level:uint, args:Array):void
    {
        var msg:String= args.join ('');
        if (level <= trace_level)
            trace (level_names[level], msg);
        if (ExternalInterface.available && level <= console_level)
        {
            try { ExternalInterface.call('console.log', level_names[level] + ' ' + msg); }
            catch (e:Error) { }
        }
    }
    public final function log (level:uint, ...args):void
    {
        vlog (level, args);
    }
    public final function logd (...args):void
    {
        vlog (D, args);
    }
    public final function logv (...args):void
    {
        vlog (V, args);
    }
    public final function logi (...args):void
    {
        vlog (I, args);
    }
    public final function logw (...args):void
    {
        vlog (W, args);
    }
    public final function loge (...args):void
    {
        vlog (E, args);
    }
}
}
