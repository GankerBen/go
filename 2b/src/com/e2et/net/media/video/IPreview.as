package com.e2et.net.media.video
{
import flash.media.Video;

public interface IPreview
{
    function get previewing ():Boolean;
    function startPreview (v:Video):void;
    function stopPreview (v:Video):void;
}
}
