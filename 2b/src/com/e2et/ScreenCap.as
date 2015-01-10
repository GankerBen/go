package com.e2et
{
public class ScreenCap
{
    /**
     * 屏幕共享初始化完成
     */
    static public const INIT_OK:uint = 0;
    /**
     * 屏幕共享初始化被用户取消了
     */
    static public const INIT_CANCEL:uint = 1;
    /**
     * 屏幕共享过程中被用户手动停止了
     */
    static public const STOPPED_BY_USER:uint = 2;
    /**
     * 由于插件连接断开,导致屏幕共享停止了
     */
    static public const STOPPED_BY_MPC:uint = 3;
}
}