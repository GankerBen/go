package com.e2et.replay
{
import com.e2et.datalogic.Room;
import com.e2et.datalogic.User;

public interface IReplayHandler
{
    function loadComplete ($:ReplaySession):void;
    function loadProgress ($:ReplaySession, progress:Number):void;
    function loadFailed ($:ReplaySession, reason:String):void;

    function playStarting ($:ReplaySession, seg:ReplaySegment, time:uint):void;
    function playStarted ($:ReplaySession, seg:ReplaySegment, time:uint):void;
    function playEnded ($:ReplaySession, seg:ReplaySegment):void;
    function timeTick ($:ReplaySession, seg:ReplaySegment, time:uint):void;

    function userIn ($:ReplaySession, seg:ReplaySegment, user:User):void;
    function userOut ($:ReplaySession, seg:ReplaySegment, user:User):void;

    function userUpdate ($:ReplaySession, seg:ReplaySegment, user:User):void;
    function roomUpdate ($:ReplaySession, seg:ReplaySegment, room:Room):void;

    /**
     * Seek 操作前被调用，可以保存 Seek 前的回放状态。各种 handler 的清理工作
     * @param $
     * @param seg
     * @param time
     */
    function beforeSeek ($:ReplaySession, seg:ReplaySegment, time:uint):void;
    /**
     * Seek 操作后被调用
     * @param $
     * @param seg
     * @param time
     */
    function afterSeek ($:ReplaySession, seg:ReplaySegment, time:uint):void;
}
}
