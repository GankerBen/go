package com.e2et.datalogic {
public function equal (a:*, b:*):Boolean
{
    var ac:Class = a['constructor'];
    var bc:Class = b['constructor'];
    if (ac == Object)
    {
        if (bc != Object)
            return false;
        var ak:Array = [], bk:Array = [], k:String;
        for (k in a) ak.push (k);
        for (k in b) bk.push (k);
        ak.sort ();
        bk.sort ();
        var i:uint, c:uint = ak.length;
        if (bk.length != c)
            return false;
        for (i=0; i<c; ++i)
        {
            k = ak[i];
            if (bk[i] != k)
                return false;
            if (!equal (a[k], b[k]))
                return false;
        }
        return true;
    }
    if (ac == Array)
    {
        if (bc != Array)
            return false;
        c = a.length;
        if (c != b.length)
            return false;
        for (i=0; i<c; ++i)
        {
            if (!equal (a[i], b[i]))
                return false;
        }
        return true;
    }
    return a == b;
}
}
