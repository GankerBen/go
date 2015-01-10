package tetequ.live.modules.room.doc.players.ppt.common 
{
	import tetequ.live.modules.room.doc.common.IFileInfo;
	import tetequ.live.modules.room.doc.players.common.interfaces.IFrameStep;
	import tetequ.live.modules.room.doc.players.common.MultiFramesContent;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 多页动画PPT文档数据以及翻页操作
	 */
	public class PPTData extends MultiFramesContent
	{
		/**
		 * 构造函数
		 * @param	metadata	文档元数据
		 * @param	stepper		文档翻页步进器
		 */
		public function PPTData( metadata:IFileInfo, stepper:IFrameStep ) 
		{
			super( metadata, stepper );
		}
		
		/**
		 * 文档内容所在容器的尺寸发生变化
		 * @param	width
		 * @param	height
		 * @param	delay
		 */
		override public function onHostResize( width:Number, height:Number, delay:Boolean = true ):void 
		{
			super.onHostResize( width, height, delay );
		}
		
		/**
		 * PPT翻页、下一步时回调
		 * @param	callback
		 */
		public function onAnimationChanged( callback:Function ):void
		{
			IPPTFrameStep(this.stepper).onAnimationChanged( callback );
		}
		
		/**
		 * PPT动画内容初始化完毕时回调
		 * @param	callback
		 */
		public function onAnimationInited( callback:Function ):void
		{
			IPPTFrameStep(this.stepper).onAnimationInited( callback );
		}
		
		/**
		 * 激活或禁用画布
		 * @param	enabled
		 */
		public function enabledCanvas( enabled:Boolean ):void
		{
			IPPTFrameStep(this.stepper).enabledCanvas( enabled );
		}
		
		/**
		 * 下一步
		 */
		public function nextStep():void
		{
			IPPTFrameStep(this.stepper).nextStep();
		}
		
		/**
		 * 下一步
		 * @param	callback
		 */
		public function onNextStep( callback:Function ):void
		{
			IPPTFrameStep(this.stepper).onNextStep( callback );
		}
		
		/**
		 * 总页数
		 */
		override public function get totalFrames():int 
		{
			return stepper.totalFrames;
		}
		
		override public function set onLoadStart(value:Function):void
		{
			stepper.onLoadStart = value;
		}
		
		override public function set onLoadComplete(value:Function):void
		{
			stepper.onLoadComplete = value;
		}
		
		public function startLoad():void
		{
			IPPTFrameStep(this.stepper).startLoad();
		}
		
	}

}