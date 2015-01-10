package com.e2et.net.media.player
{
import com.e2et.net.media.IMediaClient;

public interface IMediaPlayClient extends IMediaClient
{
    function addHandler (h:IMediaPlayHandler):void;
    function delHandler (h:IMediaPlayHandler):void;

    /**
     * 流中是否有音频数据
     */
    function get hasAudio ():Boolean;
    /**
     * 流中是否有视频数据
     */
    function get hasVideo ():Boolean;
}
}
