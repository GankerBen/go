package tetequ.live.modules.room.doc.players.ppt.common 
{
	import tetequ.live.modules.room.doc.players.common.interfaces.IFrameStep;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public interface IPPTFrameStep extends IFrameStep
	{
		/**
		 * PPT动画的下一步
		 */
		function nextStep():void;
		
		/**
		 * 下一步时回调
		 * @param	callback
		 */
		function onNextStep( callback:Function ):void;
		
		/**
		 * PPT翻页、下一步时回调
		 * @param	callback 回调函数，格式为 function callback( frame, step ):void
		 */
		function onAnimationChanged( callback:Function ):void;
		
		/**
		 * PPT动画内容初始化完毕后回调
		 * @param	callback 回调函数，格式为 function callback( totalframes:uint ):void
		 */
		function onAnimationInited( callback:Function ):void;
		
		/**
		 * 激活或禁用画布
		 * @param	enabled
		 */
		function enabledCanvas( enabled:Boolean ):void;
		
		/**
		 * 开始加载PPT动画
		 */
		function startLoad():void;
	}
	
}