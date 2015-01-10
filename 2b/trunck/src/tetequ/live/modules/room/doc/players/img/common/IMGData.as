package tetequ.live.modules.room.doc.players.img.common 
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.domUI.core.IVisualElement;
	import org.flexlite.domUI.events.UIEvent;
	import org.flexlite.domUI.utils.callLater;
	import tetequ.live.modules.room.doc.common.IFileInfo;
	import tetequ.live.modules.room.doc.players.common.interfaces.IResizable;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class IMGData implements IResizable 
	{
		
		protected var metadata:IFileInfo;
		protected var content:UIAsset;
		protected var delay:Function;
		protected var loader:Loader;
		protected var rawWidth:Number;
		protected var rawHeight:Number;
		protected var message:Label;
		
		public function IMGData( metadata:IFileInfo ) 
		{
			this.metadata = metadata;
			init();
		}
		
		private function init():void 
		{
			content = new UIAsset();
			content.horizontalCenter = 0;
			content.verticalCenter = 0;
		}
		
		private function onSkinChanged(e:UIEvent):void 
		{
			content.removeEventListener( UIEvent.SKIN_CHANGED, onSkinChanged );
			Boolean(delay) ? delay.apply() : null;
		}

		public function getContent():IVisualElement 
		{
			return content;
		}
		
		public function getSource():String 
		{
			return metadata.path;
		}
		
		public function onHostResize(width:Number, height:Number, delay:Boolean = true):void 
		{
			trace("on host resize....");
			_resizeData.x = width;
			_resizeData.y = height;
			
			//延迟生效
			_resizeTimer.stop();
			_resizeTimer.reset();
			_resizeTimer.addEventListener(TimerEvent.TIMER, onResizeTimer);
			_resizeTimer.start();
		}
		
		//500毫秒内如果没有发生尺寸改变，则应用缓冲区中的尺寸
		private function onResizeTimer(e:TimerEvent):void
		{
			if(_resizeData.x!=-1)
			{
				trace("改变尺寸！！");
				commitProperties(_resizeData.x, _resizeData.y);
				_resizeData.x = _resizeData.y = -1;
			}
			
			_resizeTimer.stop();
			_resizeTimer.reset();
			_resizeTimer.removeEventListener(TimerEvent.TIMER, onResizeTimer);
		}
		
		private var _resizeData:Point = new Point();
		private var _resizeTimer:Timer = new Timer(200, 1);
		
		/**
		 * 延迟提交属性
		 * @param	width
		 * @param	height
		 */
		private function commitProperties( width:Number, height:Number ):void
		{
			var oldWidth:Number = rawWidth;
			var oldHeight:Number = rawHeight;
			if ( width <= 0 || height <= 0 ) return;
			if ( isNaN( width ) || isNaN( height ) ) return;
			if ( isNaN( rawWidth ) || isNaN( rawHeight ) ) return;
			if ( oldHeight == 0 ) return;
			if ( oldWidth == 0 ) return;
			if ( width == oldWidth && height == oldHeight ) return;
			if ( width == oldWidth ) return;
			
			if ( oldWidth >= oldHeight )
			{
				//匹配宽度
				var scale:Number = width / oldWidth;
				var nw:Number = width;
				var nh:Number = oldHeight * scale;
				if ( nh > height )
				{
					//继续缩放
					var ns:Number = nh / height;
					nw = width / ns;
					nh = height;
					content.width = nw;
					content.height = nh - 35;
				}else 
				{
					content.width = width;
					content.height = nh - 35;
				}
			}else 
			{
				//匹配高度
				scale = height / oldHeight;
				content.height = height - 35;
				content.width = oldWidth * scale;
				content.height;
			}
		}
		
		public function setResizeDelayCall(delay:Function):void 
		{
			this.delay = delay;
		}
		
		public function startup():void
		{
			if ( loader ) return;
			
			_onLoadStart.apply();
			
			loader = new Loader();
			loader.load( new URLRequest( metadata.path ) );
			setupEventListener(loader.contentLoaderInfo.addEventListener);
		}
		
		private function onIOError(e:IOErrorEvent):void 
		{
			setupEventListener(loader.contentLoaderInfo.removeEventListener);
			loader.unloadAndStop();
			loader = null;
			browserLog('图片未加载成功', metadata.path);
			
			if (metadata.path.indexOf('.swf') < 0)
			{
				browserLog('加载图片不成功', metadata.path);
				if (!message)
				{
					message = new Label();
					message.text = '加载失败！\n不能加载 ' + metadata.path + '\n您可以关闭当前文档并打开其他文档。';
					content.skinName = message;
				}
				_onLoadComplete.apply();
				return;
			}
			
			//去掉path结尾的.swf再次加载
			metadata.path = metadata.path.substring(0, metadata.path.length - 4);
			startup();
		}
		
		private function onComp(e:Event):void 
		{
			setupEventListener(loader.contentLoaderInfo.removeEventListener);
			content.addEventListener( UIEvent.SKIN_CHANGED, onSkinChanged );
			content.skinName = loader;
			rawWidth = loader.width;
			rawHeight = loader.height;
			
			_onLoadComplete.apply();
		}
		
		private function setupEventListener(func:Function):void
		{
			func(Event.COMPLETE, onComp);
			func(IOErrorEvent.IO_ERROR, onIOError);
		}
		
		private var _onLoadStart:Function;
		private var _onLoadComplete:Function;
		public function set onLoadStart(value:Function):void
		{
			if (_onLoadStart == value) return;
			_onLoadStart = value;
		}
		
		public function set onLoadComplete(value:Function):void
		{
			if (_onLoadComplete == value) return;
			_onLoadComplete = value;
		}
		
	}

}