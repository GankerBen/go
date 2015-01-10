package com.e2et.net.media.player
{
import flash.net.NetStream;

public interface IMediaPlayHandler
{
    function mediaPlayStarting(mc:IMediaPlayClient):void;
    /**
     * 播放开始
     * @param mc
     * @param videoStream
     */
    function mediaPlayStarted(mc:IMediaPlayClient, videoStream:NetStream):void;
    /**
     * 播放中断
     * @param mc
     * @param reason 中断原因，可能值有 close, ioerror, overload 等
     */
    function mediaPlayInterrupted(mc:IMediaPlayClient, reason:String):void;
    /**
     * 播放失败
     * @param mc
     * @param reason 失败原因，可能值有 connect, badkey 等
     */
    function mediaPlayFailed(mc:IMediaPlayClient, reason:String):void;
    /**
     * 发布端停止发布了 
     */
    function publishStopped (mc:IMediaPlayClient):void;
    /**
     * 通知 mc.hasAudio 或者 mc.hasVideo 值有变化
     */
    function mediaAVStatusChanged(mc:IMediaPlayClient):void;
    /**
     * 更新网络抖动评估参数
     * @param mc 播放客户端
     * @param value 抖动评估值数组，最多有三个元素，分别是最近1,2,5分钟的抖动评估值，单位: 毫秒
     * @param time 当前时间戳，单位: 毫秒
     * @param direction 方向，0: 接收, 1: 发送
     */
    function mediaPlayUpdateJitterValue(mc:IMediaPlayClient, value:Array, time:int, direction:int):void;
}
}
