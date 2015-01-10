package com.e2et.net.media.publisher
{
import flash.net.NetStream;

public interface IMediaPubHandler
{
    function publishStarting(mc:IMediaPubClient, stm:NetStream):void;
    function publishStarted (mc:IMediaPubClient, stm:NetStream):void;
    function publishInterrupted(mc:IMediaPubClient, reason:String):void;
    function publishFailed(mc:IMediaPubClient, reason:String):void;
    function recordStatus (mc:IMediaPubClient, record:Boolean, file:String, result:Boolean):void;
    /**
     * 更新网络抖动评估参数
     * @param mc 发布客户端
     * @param value 抖动评估值数组，最多有三个元素，分别是最近1,2,5分钟的抖动评估值，单位: 毫秒
     * @param time 当前时间戳，单位: 毫秒
     * @param direction 方向，0: 接收, 1: 发送
     */
    function publishUpdateJitterValue(mc:IMediaPubClient, value:Array, time:int, direction:int):void;
}
}
