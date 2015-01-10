package com.e2et.utils
{
public class Misc
{
    /**
     * 计算平均值
     */
    static public function average (ar:*, count:int = 0):Number
    {
        if (count == 0)
            count = ar.length;
        var i:int, sum:Number, avg:Number, n:Number;
        for(i=0,sum=0.0; i<count; ++i)
            sum += ar[i];
        return sum / count;
    }
    /**
     * 计算标准差
     */
    static public function sd (ar:*, count:int = 0):Number
    {
        if (count == 0)
            count = ar.length;
        var i:int, sum:Number, avg:Number, n:Number;
        for(i=0,sum=0.0; i<count; ++i)
            sum += ar[i];
        avg = sum / count;
        for(i=0,sum=0.0; i<count; ++i)
        {
            n = ar[i] - avg;
            sum += n * n;
        }
        return Math.sqrt(sum / count);
    }
    /**
     * 计算平均值和标准差
     */
    static public function average_sd (ar:*, count:int = 0):Array
    {
        if (count == 0)
            count = ar.length;
        var i:int, sum:Number, avg:Number, n:Number;
        for(i=0,sum=0.0; i<count; ++i)
            sum += ar[i];
        avg = sum / count;
        for(i=0,sum=0.0; i<count; ++i)
        {
            n = ar[i] - avg;
            sum += n * n;
        }
        return [avg, Math.sqrt(sum / count)];
    }
}
}
