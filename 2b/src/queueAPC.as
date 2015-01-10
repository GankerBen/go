package
{
import flash.utils.setTimeout;

public function queueAPC(closure:Function, args:Array = null, _this:* = null, id:String = null):void
{
    if (id)
    {
        if (id in apcIndex)
            return;
    }
    else
    {
        if (closure in apcIndex)
            return;
    }

    if (apc.length == 0)
        setTimeout (execAPC, 1);

    var item:Array = [closure, args, _this, id];
    apc.push (item);
    if (id)
        apcIndex[id] = true;
    else
        apcIndex[closure] = true;
}
}

import flash.utils.Dictionary;

var apc:Array  = [];
var apcIndex:Dictionary = new flash.utils.Dictionary;

function execAPC ():void
{
    var i:int, c:int = apc.length;
    var a:Array = apc;
    apc = [];
    apcIndex = new Dictionary;
    for (i=0; i<c; ++i)
    {
        var item:Array = a[i];
        var func:Function = item[0];
        func.apply (item[2], item[1]);
    }
}
