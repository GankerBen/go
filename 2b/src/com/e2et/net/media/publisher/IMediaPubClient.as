package com.e2et.net.media.publisher
{
import com.e2et.net.media.IMediaClient;
import com.e2et.net.media.audio.IAudioCapture;
import com.e2et.net.media.video.IVideoCapture;

public interface IMediaPubClient extends IMediaClient
{
    function addHandler (h:IMediaPubHandler):void;
    function delHandler (h:IMediaPubHandler):void;

    /**
     * 是否有绑定音频流
     */
    function get hasAudio():Boolean;
    /**
     * 是否有绑定视频流
     */
    function get hasVideo():Boolean;
    /**
     * 绑定音频或解除音频绑定
     * @param audiocap 音频流, 若为 null 则解除音频绑定
     * @param closeLastAudioCap 是否关闭前一个音频流
     * @return 若 closeLastAudioCap 为 false, 返回前一个音频流; 为 true 则关闭前一个音频流并返回 null。
     * <p>attachAudio 方法会在一定程度上影响 audioOn 属性值</p>
     * <ul>
     * <li>在连接建立之前调用 attachAudio 不会影响 audioOn 的值<li>
     * <li>连接成功后，若已绑定音频流，则 audioOn 自动变为 true，同时在流上发送音频数据</li>
     * <li>连接建立后调用 attachAudio 绑定音频，不会影响 audioOn 的值，如果原 audioOn 为 false，
     * 不会立即在流上发送音频数据，audioOn 设为 true 后，开始发送音频数据</li>
     * <li>连接建立后调用 attachAudio 解除音频绑定后，audioOn 的值为 false</li>
     * </ul>
     */
    function attachAudio (audiocap:IAudioCapture = null, closeLastAudioCap:Boolean = true):IAudioCapture;
    /**
     * 绑定视频或解除视频绑定
     * @param videocap 视频流, 若为 null 则解除视频绑定
     * @param closeLastVideoCap 是否关闭前一个视频流
     * @return 若 closeLastVideoCap 为 false, 返回前一个视频流; 为 true 则关闭前一个视频流并返回 null。
     * <p>attachVideo 方法会在一定程度上影响 videoOn 属性值</p>
     * <ul>
     * <li>在连接建立之前调用 attachVideo 不会影响 videoOn 的值</li>
     * <li>连接成功后，若已绑定视频流，则 videoOn 自动变为 true，同时在流上发送视频数据</li>
     * <li>连接建立后调用 attachVideo 绑定视频，不会影响 videoOn 的值，如果原 videoOn 为 false，
     * 不会立即在流上发送视频数据，videoOn 设为 true 后，开始发送视频数据</li>
     * <li>连接建立后调用 attachVideo 解除视频绑定后，videoOn 的值为 false</li>
     * </ul>
     */
    function attachVideo (videocap:IVideoCapture = null, closeLastVideoCap:Boolean = true):IVideoCapture;

    /**
     * 开始录制
     * @param file
     * @param recordVideo
     */
    function recordStart (file:String, recordVideo:Boolean):void;
    /**
     * 结束录制
     */
    function recordStop ():void;
}
}
