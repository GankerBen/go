package com.e2et.net.media
{
import com.e2et.ISession;
import com.e2et.datalogic.AVStream;

public interface IMediaClient
{
    function get session ():ISession;
    /**
     * 连接服务器
     */
    function connect ():void;
    /**
     * 关闭连接
     */
    function close ():void;

    /**
     * 流名字
     */
    function get name ():String;

    function get avstm ():AVStream;

    /**
     * 服务器地址
     */
    function get uri ():String;

    function get audioOn ():Boolean;
    function get videoOn ():Boolean;

    /**
     * 音频开关
     * <p>对于 IMediaPubClient，默认值为 false, 连接成功后，会根据音频绑定情况自动设置其值。
     * 详细情况请参考 IMediaPubClient.attachAudio</p>
     * <p>对于 IMediaPlayClient，默认值为 true, 连接中断重连成功后，不会改变其值</p>
     */
    function set audioOn (on:Boolean):void;
    /**
     * 视频开关
     * <p>对于 IMediaPubClient，默认值为 false, 连接成功后，会根据视频绑定情况自动设置其值。
     * 详细情况请参考 IMediaPubClient.attachVideo</p>
     * <p>对于 IMediaPlayClient，默认值为 true, 连接中断重连成功后，不会改变其值</p>
     */
    function set videoOn (on:Boolean):void;
}
}
