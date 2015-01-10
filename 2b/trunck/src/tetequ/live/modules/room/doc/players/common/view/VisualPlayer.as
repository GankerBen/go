package tetequ.live.modules.room.doc.players.common.view 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import org.flexlite.domUI.components.Rect;
	import org.flexlite.domUI.components.Scroller;
	import org.flexlite.domUI.components.TitleWindow;
	import org.flexlite.domUI.components.VScrollBar;
	import org.flexlite.domUI.core.DomGlobals;
	import org.flexlite.domUI.core.IViewport;
	import org.flexlite.domUI.core.ScrollPolicy;
	import org.flexlite.domUI.core.UIComponent;
	import org.flexlite.domUI.events.CloseEvent;
	import org.flexlite.domUI.events.ResizeEvent;
	import tetequ.live.core.assets.AssetsFactory;
	import tetequ.live.modules.room.common.GlobalVars;
	import tetequ.live.modules.room.doc.players.common.interfaces.IResizable;
	import tetequ.live.modules.room.doc.players.common.interfaces.IVisualContent;
	import tetequ.live.modules.room.doc.players.common.interfaces.IVisualPlayer;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.components.UIAsset;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 可视化内容播放器基类
	 */
	public class VisualPlayer extends Group implements IVisualPlayer 
	{
		/**
		 * 可视化内容容器
		 */
		protected var contentContainer:Group;
		
		/**
		 * 可视化内容接口
		 */
		protected var visualContent:IResizable;
		
		/**
		 * 内容滚动条
		 */
		protected var scroller:Scroller;
		
		private var _closeButton:UIAsset;
		private var _showCloseButton:Boolean = true;
		private var _title:String;
		private var _dummyBg:Rect;
		
		/**
		 * 构造函数
		 */
		public function VisualPlayer() 
		{
			super();
			initComponents();
		}
		
		/**
		 * 获取播放器可视化内容
		 * @return
		 */
		public function getVisualContent():IResizable
		{
			return visualContent;
		}
		
		/**
		 * 移除播放器的显示内容
		 * @return
		 */
		public function removeVisualContent():IResizable
		{
			if ( !visualContent ) return null;
			if ( contentContainer.containsElement( visualContent.getContent() ) )
				contentContainer.removeElement( visualContent.getContent() );
			var content:IResizable = visualContent;
			visualContent = null;
			return content;
		}

		/**
		 * 设置播放器的显示内容
		 * @param	value
		 */
		public function setVisualContent( value:IResizable ):void
		{
			removeVisualContent();
			contentContainer.addElement( value.getContent() );
			value.getContent().top = 1;
			visualContent = value;
		}

		/**
		 * 初始化组件，子类若要重写该方法，
		 * 请首先调用super.initComponents();
		 */
		protected function initComponents():void
		{
			addElement(_dummyBg = new Rect());
			_dummyBg.percentWidth = 100;
			_dummyBg.percentHeight = 100;
			_dummyBg.fillColor = 0xcccccc;
			
			addElement( contentContainer = new Group() );
			contentContainer.bottom = 0;
			addElement( scroller = new Scroller() );
			scroller.viewport = contentContainer;
			scroller.percentWidth = 100;
			scroller.percentHeight = 100;
			scroller.left = 0;
			scroller.right = -15;
			scroller.bottom = 30;
			scroller.horizontalScrollPolicy = ScrollPolicy.ON;
			scroller.verticalScrollPolicy = ScrollPolicy.ON;
			scroller.verticalScrollBar.alpha = 0;
			scroller.horizontalScrollBar.alpha = 0;
			
			addElement(_closeButton = new UIAsset());
			_closeButton.mouseChildren = true;
			_closeButton.skinName = AssetsFactory.getInstance().getAsset('CloseButtonSkin');
			_closeButton.top = 5;
			_closeButton.right = 5;
			_closeButton.addEventListener(MouseEvent.CLICK, onClose);
			
			this.percentWidth = 100;
			this.percentHeight = 100;
			
			this.addEventListener( Event.ADDED_TO_STAGE, onStageGetted );
		}
		
		private function onClose(e:MouseEvent):void 
		{
			dispatchEvent(new CloseEvent(CloseEvent.CLOSE));
		}
		
		
		/**
		 * 添加到舞台
		 * @param	e
		 */
		private function onStageGetted(e:Event):void 
		{
			this.addEventListener( ResizeEvent.RESIZE, updateContentSize );
			resiezeContent();
		}
		
		/**
		 * 舞台尺寸发生变化
		 * this.parent.parent是指布局容器(LayoutDirector)中，
		 * 显示播放器的区域group
		 * @param	e
		 */
		public function onStageResize():void 
		{
			resiezeContent();
		}
		
		/**
		 * 父父级组件尺寸发生变化
		 * @param	e
		 */
		private function updateContentSize(e:ResizeEvent = null):void 
		{
			resiezeContent();
		}
		
		/**
		 * 更新文档尺寸
		 */
		private function resiezeContent():void
		{
			if ( this.width == 0 || this.height == 0 ) return;
			if ( visualContent )
			{
				visualContent.onHostResize( this.width, this.height/* - contentContainer.bottom*/, false );
			}
		}
		
		public function get showCloseButton():Boolean 
		{
			return _showCloseButton;
		}
		
		public function set showCloseButton(value:Boolean):void 
		{
			if (value == _showCloseButton) return;
			_showCloseButton = value;
			_closeButton.visible = value;
		}
		
		public function get title():String 
		{
			return _title;
		}
		
		public function set title(value:String):void 
		{
			_title = value;
		}
	}
}