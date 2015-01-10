package com.e2et
{
import com.e2et.datalogic.AVStream;
import com.e2et.datalogic.LocalUser;
import com.e2et.datalogic.Room;
import com.e2et.datalogic.User;
import com.e2et.datalogic.Users;
import com.e2et.net.media.audio.IAudioCapture;
import com.e2et.net.media.player.IMediaPlayClient;
import com.e2et.net.media.publisher.IMediaPubClient;
import com.e2et.net.media.video.IVideoCapture;

import flash.media.Camera;
import flash.media.Microphone;

public interface ISession
{
    function get user ():LocalUser;
    function get room ():Room;

    function get rpcClient ():Object;
    function set rpcClient (c:Object):void;

    function get userList():Users;

    // 日志操作，(调试，详细，信息，警告，错误) 五个级别
    function logd (...args):void;
    function logv (...args):void;
    function logi (...args):void;
    function logw (...args):void;
    function loge (...args):void;

    /**
     * 本地安装的 IP 摄像头列表，数组元素为字符串，在调用  newIPCamCapture 时，请传入该字符串。
     * <p>字符串中有多项信息，用逗号隔开，其中第二个是摄像头的显示名称</p>
     */
    function get ipcams ():Array;

    function init (handler:ISessionHandler):void;
    function close ():void;

    function newMediaPlayClient (av:AVStream):IMediaPlayClient;
    function newMediaPubClient (av:AVStream):IMediaPubClient;

    function newMicCapture (mic:Microphone):IAudioCapture;
    function newCamCapture (cam:Camera):IVideoCapture;
    /**
     * 共享屏幕, 只能运行一个实例. 如果插件代理未启动,或者启动第二个实例,都会抛异常
     * @param closure 回调函数，原型为 function closure(code:uint):void;
     * <p>
     * code 为下列值之一
     * <ul>
     *   <li>0. ScreenCap.INIT_OK 屏幕共享初始化完成。</li>
     *   <li>1. ScreenCap.INIT_CANCEL 屏幕共享初始化被用户取消了。</li>
     *   <li>2. ScreenCap.STOPPED_BY_USER 屏幕共享过程中被用户手动停止了。</li>
     *   <li>3. ScreenCap.STOPPED_BY_MPC 由于插件连接断开,导致屏幕共享停止了.</li>
     * </ul>
     * </p>
     * <p>屏幕共享只允许有一个实例运行，共享停止后，请调用 IVideoCapture.dispose。</p>
     */
    function newScreenCapture (closure:Function):IVideoCapture;
    /**
     * 从 IP 摄像头获取视频数据， 可以从 Session 对象的 ipcams 属性获取 IP 摄像头列表
     */
    function newIPCamCapture (ipcam:String):IVideoCapture;

    // 令牌相当操作
    /**
     * 当前执有令牌的用户
     */
    function get tokenUser ():User;
    /**
     * 我是否有令牌
     */
    function get hasToken ():Boolean;
    /**
     * 获取令牌
     */
    function acquireToken ():void;

    /**
     * 是否录制中...
     */
    function get recording ():Boolean;

    function startRecord (videoId:String):void;
    function stopRecord ():void;

    /**
     * 发送聊天信息
     * @param msg 聊天内容
     * @param to 接收者，null 表示所有人都可以收到
     */
    function sendChat (msg:String, to:User = null):void;

    /**
     * 发送远程过程调用，让指定用户或所有用户都执行指定操作
     * @param to 接收者，null 表示所有人
     * @param func 调用的函数名
     * @param args 调用函数的参数
     */
    function sendRPC (to:User, func:String, ...args):void;

    /**
     * 发送远程过程调用，让指定用户或所有用户都执行指定操作
     * @param func 调用的函数名
     * @param args 调用函数的参数列表
     * @param to 接收者，null 表示所有人
     */
    function sendRPCv (func:String, args:Array, to:User = null):void;

    function sendAVReq (info:* = null):void;
    function cancelAVReq (info:* = null):void;

    /**
     * 请求指定用户或者所有用户发送 User Update 消息
     */
    function requestUserUpdate (to:User = null, callback:Function = null):void;
}
}
