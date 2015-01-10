package tetequ.live.modules.room.doc.players.common 
{
	import com.e2et.datalogic.Document;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.core.IVisualElement;
	import tetequ.live.modules.room.doc.common.IFileInfo;
	import tetequ.live.modules.room.doc.players.common.interfaces.ICanvas;
	import tetequ.live.modules.room.doc.players.common.interfaces.IFrameStep;
	import tetequ.live.modules.room.doc.players.common.interfaces.IResizable;

	/**
	 * ...
	 * @author Pandazhong
	 */
	public class MultiFramesContent implements IResizable, IFrameStep
	{
		protected var container:Group;
		protected var metadata:IFileInfo;
		protected var stepper:IFrameStep;
		
		/**
		 * 构造函数
		 * @param	metadata	文档信息
		 * @param	stepper		翻页控制器
		 */
		public function MultiFramesContent( metadata:IFileInfo, stepper:IFrameStep ) 
		{
			this.metadata = metadata;
			this.stepper = stepper;
			initComponents();
		}
		
		/**
		 * 初始化组件，子类若要重写该方法，
		 * 请首先调用super.initComponents();
		 */
		private function initComponents():void 
		{
			this.setContainer( container = new Group() );
		}
		
		/* INTERFACE tetequ.live.modules.room.doc.players.common.IVisualContent */
		
		/**
		 * 获取文档内容
		 */
		public function getContent():IVisualElement 
		{
			return container;
		}
		
		public function setContainer( container:Group ):void
		{
			stepper.setContainer( container );
		}
		
		/**
		 * 获取文档来源(url)
		 */
		public function getSource():String 
		{
			return this.metadata.path;
		}
		
		/**
		 * 文档内容所在的播放器尺寸发生变化时调用
		 * @param	width	播放器内容区域的宽度
		 * @param	height	播放器内容区域的高度
		 */
		public function onHostResize( width:Number, height:Number, delay:Boolean = true ):void 
		{
			stepper.onHostResize( width, height, delay );
		}
		
		/* INTERFACE tetequ.live.modules.room.doc.players.common.IFrameStep */
		
		public function nextFrame():void 
		{
			stepper.nextFrame();
		}
		
		public function prevFrame():void 
		{
			stepper.prevFrame();
		}
		
		public function gotoAndStop(frame:int, step:uint = 0):void 
		{
			stepper.gotoAndStop( frame, step );
		}
		
		public function get currentFrame():int 
		{
			return stepper.currentFrame;
		}
		
		public function get totalFrames():int 
		{
			return metadata.pages;
		}
		
		public function setResizeDelayCall( delay:Function ):void
		{
			stepper.setResizeDelayCall( delay );
		}
		
		public function set bindDocument( doc:Document ):void
		{
			stepper.bindDocument = doc;
		}
		
		public function get bindDocument():Document
		{
			return stepper.bindDocument;
		}
		
		public function getCanvas():ICanvas
		{
			return stepper.getCanvas();
		}
		
		public function set onLoadStart(value:Function):void
		{
			stepper.onLoadStart = value;
		}
		
		public function set onLoadComplete(value:Function):void
		{
			stepper.onLoadComplete = value;
		}
	}

}