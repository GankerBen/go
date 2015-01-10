package tetequ.live.modules.room.doc.players.common 
{
	import com.e2et.datalogic.Document;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import org.flexlite.domDll.Dll;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Rect;
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.domUI.components.VScrollBar;
	import org.flexlite.domUI.core.IVisualElement;
	import org.flexlite.domUI.events.UIEvent;
	import org.flexlite.domUI.utils.callLater;
	import tetequ.live.modules.room.doc.players.common.interfaces.ICanvas;
	import tetequ.live.modules.room.doc.players.common.interfaces.IFrameStep;
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class DocumentFrameStepper implements IFrameStep
	{
		protected var frames:Vector.<UIAsset>;
		protected var frameUrls:Vector.<String>;
		protected var delayCall:Function;
		protected var firstResized:Boolean = true;
		protected var current:int;
		protected var total:int;
		protected var source:String; 
		protected var container:Group;
		protected var docContent:UIAsset;
		
		//画图
		protected var canvas:ICanvas;
		
		/**
		 * 构造函数
		 * @param	url	文档url
		 * @param	totalFrames	文档总页数
		 * @param	currentFrame	文档当前页
		 */
		public function DocumentFrameStepper(url:String, totalFrames:int, currentFrame:int= -1) 
		{
			source = url;
			current = currentFrame;
			total = totalFrames;
			initComponents();
		}
		
		/**
		 * 初始化组件
		 * frames第一位包含null占位，以便用页码(从1开始)直接索引数组元素
		 */
		protected function initComponents():void
		{
			docContent = new UIAsset();
			docContent.mouseChildren = true;
			docContent.mouseEnabled = true;

			canvas = new Canvas( this.total );
			
			frames = new Vector.<UIAsset>( this.total + 1, true );
			frameUrls = new Vector.<String>( this.total + 1, true );

			for ( var i:int = 1; i != this.total + 1; ++i )
			{
				frameUrls[i] = this.source + "/" + i.toString() + ".swf";
			}
		}
		
		public function setContainer( container:Group ):void
		{
			this.container = container;
			this.container.addElement( docContent );
			this.container.addElement( IVisualElement( canvas ) );
		}
		
		public function get currentFrame():int
		{
			return current;
		}
		
		public function get totalFrames():int
		{
			return total;
		}
		
		/**
		 * 到下一帧
		 */
		public function nextFrame():void 
		{
			if ( currentFrame == totalFrames ) return;
			processFrame( ++current );
		}
		
		/**
		 * 到上一帧
		 */
		public function prevFrame():void 
		{
			if ( currentFrame == 1 ) return;
			processFrame( --current );
		}
		
		/**
		 * 到第frame帧
		 * @param	frame
		 */
		public function gotoAndStop(frame:int, step:uint = 0):void 
		{
			if ( currentFrame == frame ) return;
			if ( frame in frames )
			{
				processFrame( frame );
			}
		}
		
		/**
		 * 处理frame帧
		 * @param	frame
		 */
		private function processFrame( frame:int ):void
		{
			current = frame;
			
			var asset:UIAsset = frames[frame];
			
			if ( asset )
			{
				docContent.skinName = asset;
				if ( delayCall != null )
				{
					delayCall.apply();
				}
			}else {
				
				//添加loading提示界面
				_onLoadStart.apply();
				
				frames[frame] = asset = new UIAsset();
				asset.skinName = frameUrls[frame];
				asset.addEventListener( UIEvent.SKIN_CHANGED, onSkinChanged );
				docContent.skinName = asset;
			}
			
			canvas.drawPage( frame );
		}
	
		/**
		 * 帧内容加载完毕
		 * @param	e
		 */
		private function onSkinChanged(e:UIEvent):void 
		{
			e.currentTarget.removeEventListener( e.type, arguments.callee );
			Boolean(delayCall) ? delayCall.apply() : null;
			
			//移除loading提示界面
			_onLoadComplete.apply();
		}
		
		/**
		 * 主机组件尺寸发生改变
		 * @param	width
		 * @param	height
		 * @param	delay	是否延迟调用
		 */
		public function onHostResize( width:Number, height:Number, delay:Boolean = true ):void
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
			var frameAsset:UIAsset = frames[current];
			if ( !frameAsset.skin ) return;
			
			if ( width <= 0 || height <= 0 ) return;
			
			var oldWidth:Number = frameAsset.width;
			var oldHeight:Number = frameAsset.height;

			if ( oldHeight == 0 ) return;
			if ( oldWidth == 0 ) return;
			if ( width == oldWidth && height == oldHeight ) return;
			if ( width == oldWidth ) return;
			
			var scale:Number = width / oldWidth;
			docContent.width = width;
			docContent.height = oldHeight * scale;
			
			if (docContent.height < height)
			{
				container.verticalCenter = 0;
			}else
			{
				container.y = 0;
			}
			
			//调整绘图层尺寸
			canvas.onResize( width, oldHeight * scale, height );
		}
		
		/**
		 * 当前帧内容加载完毕后主动调用delayCall，
		 * 第一时间适应主机组件的尺寸。
		 * @param	delay
		 */
		public function setResizeDelayCall( delay:Function ):void
		{
			delayCall = delay;
		}
		
		/**
		 * 设置所在的文档对象
		 */
		public function set bindDocument( doc:Document ):void
		{
			canvas.bindDocument = doc;
		}
		
		/**
		 * 获取文档对象
		 */
		public function get bindDocument():Document
		{
			return canvas.bindDocument;
		}
		
		public function getCanvas():ICanvas
		{
			return canvas;
		}
		
		/**
		 * 加载等待界面
		 */
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