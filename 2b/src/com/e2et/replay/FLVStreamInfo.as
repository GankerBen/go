package com.e2et.replay
{
import flash.events.Event;
import flash.events.ProgressEvent;
import flash.events.StatusEvent;

/**
 * 监听 FLVStream 的各种事件，通知 ReplaySession
 */
internal class FLVStreamInfo
{
    internal var stream:FLVStream;
    internal var progress:Number;
    internal var $:ReplaySession;

    public function FLVStreamInfo (stream:FLVStream, $:ReplaySession)
    {
        this.stream = stream;
        this.$ = $;
        if (stream.dataBufferFull)
            progress = 1.0;
        else
            setup (stream.addEventListener);
    }
    private function loadProgress (event:ProgressEvent):void
    {
        progress = event.bytesLoaded / event.bytesTotal;
        $.updateLoadProgress ();
    }
    private function loadFailed (event:StatusEvent):void
    {
        $.loadFailed (event.code);
    }
    private function loadDone (event:Event):void
    {
        progress = 1.0;
    }
    private function setup (func:Function):void
    {
        func (FLVStream.DATA_BUFFER_PROGRESS, loadProgress);
        func (FLVStream.DATA_BUFFER_FULL, loadDone);
        func (FLVStream.LOAD_FAILED, loadFailed);
    }
    internal function dispose ():void
    {
        setup (stream.removeEventListener);
        stream = null;
        $ = null;
    }
}
}