package tetequ.live.modules.room.doc.players.ppt.common 
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
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import org.flexlite.domDll.Dll;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Rect;
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.domUI.components.VScrollBar;
	import org.flexlite.domUI.core.DomGlobals;
	import org.flexlite.domUI.core.IVisualElement;
	import org.flexlite.domUI.events.UIEvent;
	import org.flexlite.domUI.utils.callLater;
	import tetequ.live.modules.room.doc.players.common.Canvas;
	import tetequ.live.modules.room.doc.players.common.interfaces.ICanvas;
	import tetequ.live.modules.room.doc.players.common.interfaces.IFrameStep;
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class PPTFramesStepper implements IPPTFrameStep
	{
		protected var frames:Vector.<UIAsset>;
		protected var frameUrls:Vector.<String>;
		protected var delayCall:Function;
		protected var firstResized:Boolean = true;
		protected var current:int = -1;
		protected var total:int;
		protected var source:String; 
		protected var container:Group;
		protected var docContent:UIAsset;
		
		protected var animationChangedCallback:Function;
		protected var animationInitedCallback:Function;
		private var _nextStepCallback:Function;
		
		private var _loader:Loader;
		
		/**
		 * 如下变量名比较晦涩难懂。
		 * 主要是因为这些变量名
		 * 直接取至于外部PPT文件，
		 * 这是历史原因导致的。
		 */
		private var _player:Object;
		private var _playbackController:Object;
		private var _keyboardController:Object;
		private var _slides:Object;
		private var _stepPlayback:Object;
		private var _stepIndex:int;
		private var _slideIndex:int;
		private var _stepCount:int;
		private var _pageIndexPreset:Number = -1;
		private var _stepIndexPreset:Number = -1;
		private var _started:Boolean;
		private var _rawWidth:Number;
		private var _rawHeight:Number;
		
		//画图
		protected var canvas:ICanvas;
		
		/**
		 * 由于画笔层始终会显示，所以
		 * 这会拦截鼠标点击PPT动画层
		 * 的操作，于是添加一个层用于
		 * 模拟点击PPT动画层的效果。
		 */
		private var _animStepLayer:Rect;
		
		/**
		 * 构造函数
		 * @param	url	文档url
		 * @param	totalFrames	文档总页数
		 * @param	currentFrame	文档当前页
		 */
		public function PPTFramesStepper(url:String, totalFrames:int, currentFrame:int= -1) 
		{
			source = url;
			current = 0;
			total = totalFrames;
			initComponents();
		}
		
		public function startLoad():void
		{
			if (_loader) return;
			
			//添加loading界面
			_onLoadStart.apply();
			
			_loader = new Loader();
			_loader.load(new URLRequest(this.source), new LoaderContext (false, ApplicationDomain.currentDomain));
			_loader.contentLoaderInfo.addEventListener( Event.INIT, onInit );
		}
		
		/**
		 * 初始化组件
		 * frames第一位包含null占位，以便用页码(从1开始)直接索引数组元素
		 */
		protected function initComponents():void
		{
			docContent = new UIAsset();
			docContent.horizontalCenter = 0;
			docContent.verticalCenter = 0;
			docContent.mouseChildren = true;
			docContent.mouseEnabled = true;
			docContent.addEventListener( UIEvent.SKIN_CHANGED, onSkinChanged );
		}
		
		private function onInit(e:Event):void 
		{
			if (_loader.content['playerIsAvailable'])
			{
				
			}else
			{
				_loader.content.addEventListener( 'playerIsAvailable', onPlayerIsAvailable );
			}
		}
		
		private function onPlayerIsAvailable(e:Event):void 
		{
			e.currentTarget.removeEventListener( e.type, arguments.callee );
			
			this._player = e.target['player'];
			this._player.skin.window.maximized = false;
			this._playbackController = this._player.presentationView.playbackController;
			this._keyboardController = this._player.presentationView.keyboardController;
			this._slides = this._player.presentation.slides;
			this.total = this._slides.count;

			Boolean(delayCall) ? delayCall.apply() : null;
			animationInitedCallback.apply(null, [this.total]);
			if (this.container.containsElement(_animStepLayer))
				this.container.addElement(_animStepLayer);

			this._playbackController.addEventListener( 'slideChange', onSlideChanged  );
			
			_loader.mouseChildren = false;
			_loader.mouseEnabled = false;
			docContent.skinName = _loader;
			_rawWidth = _loader.width;
			_rawHeight = _loader.height;
			//
			var ldr:Object = this._player.presentationLoader;
			if (ldr.presentationLoadingProgress < 1)
				ldr.addEventListener ("slideLoaded", function(e:Event):void {
					
					if (e.target.presentationLoadingProgress < 1)
					{
						return;
					}
					
					//移除loading界面
					_onLoadComplete.apply();
					
					e.currentTarget.removeEventListener(e.type, arguments.callee);
					_started = true;
					
					if(_pageIndexPreset!=-1)
					{
						_playbackController.gotoTimestamp (_pageIndexPreset, _stepIndexPreset, 0, true);
						_pageIndexPreset = _stepIndexPreset = -1;
					}
				});
		}
		
		private function onStepClick(e:MouseEvent):void 
		{
			if (_nextStepCallback != null)
			{
				_nextStepCallback.apply();
			}
		}
		
		public function onAnimationChanged( callback:Function ):void
		{
			animationChangedCallback = callback;
		}
		
		public function onAnimationInited( callback:Function ):void
		{
			animationInitedCallback = callback;
		}
		
		public function enabledCanvas( enabled:Boolean ):void
		{
			if ( enabled )
			{
				if (container.containsElement(_animStepLayer))
				{
					container.removeElement(_animStepLayer);
				}
			}else
			{
				if ( !container.containsElement(_animStepLayer))
				{
					container.addElement(_animStepLayer);
				}
			}
		}
		
		public function setContainer( container:Group ):void
		{
			this.container = container;
			this.container.addElement( docContent );
			this.container.horizontalCenter = 0;
			this.container.verticalCenter = 0;
			
			canvas = new Canvas( 1 );
			canvas.bindDocument = _bindDocument;
			canvas.drawPage(1);
			this.container.addElement( IVisualElement( canvas ) );
			
			this.container.addElement( _animStepLayer = new Rect() );
			_animStepLayer.addEventListener( MouseEvent.CLICK, onStepClick );
			_animStepLayer.fillColor = 0xffffff;
			_animStepLayer.fillAlpha = 0;
		}
		
		public function get currentFrame():int
		{
			return current;
		}
		
		public function get totalFrames():int
		{
			return this.total;
		}
		
		/**
		 * 到下一帧
		 */
		public function nextFrame():void 
		{
			if ( currentFrame >= totalFrames - 1 ) return;
			processFrame( ++current );
		}
		
		/**
		 * PPT动画当前页的下一步
		 */
		public function nextStep():void
		{
			this._playbackController.gotoNextStep();
		}
		
		/**
		 * 下一步
		 * @param	callback
		 */
		public function onNextStep( callback:Function ):void
		{
			_nextStepCallback = callback;
		}
		
		/**
		 * 到上一帧
		 */
		public function prevFrame():void 
		{
			if ( currentFrame == 0 ) return;
			processFrame( --current );
		}
		
		/**
		 * 到第frame帧
		 * @param	frame
		 */
		public function gotoAndStop(frame:int, step:uint = 0):void 
		{
			current = frame;
			
			if (_started)
			{
				if (frame < 0 || frame >= this._slides.count)
					return;
				if (_slideIndex != frame)
				{
					this._playbackController.gotoTimestamp (frame, step, 0, true);
					_slideIndex = frame; 
					_stepIndex = step;
				}
				else if (step > 0 && _stepIndex != step)
				{
					this._stepPlayback.playFromStep (step);
				}
			}
			else
			{
				_pageIndexPreset = frame;
				_stepIndexPreset = step;
			}
		}
		
		/**
		 * 处理frame帧
		 * @param	frame
		 */
		private function processFrame( frame:int ):void
		{
			this._playbackController.gotoTimestamp (frame, 0, 0, true);
			canvas.drawPage( frame + 1 );
		}
	
		/**
		 * 帧内容加载完毕
		 * @param	e
		 */
		private function onSkinChanged(e:UIEvent):void 
		{
			e.currentTarget.removeEventListener( e.type, arguments.callee );
			Boolean(delayCall) ? delayCall.apply() : null;
		}
		
		/**
		 * 主机组件尺寸发生改变
		 * @param	width
		 * @param	height
		 * @param	delay	已废弃的参数！
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
			var oldWidth:Number = _rawWidth;
			var oldHeight:Number = _rawHeight;
			if ( width <= 0 || height <= 0 ) return;
			if ( isNaN( width ) || isNaN( height ) ) return;
			if ( isNaN( _rawWidth ) || isNaN( _rawHeight ) ) return;
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
					docContent.width = nw;
					docContent.height = nh// - 35;
				}else 
				{
					docContent.width = width;
					docContent.height = nh// - 35;
				}
			}else 
			{
				//匹配高度
				scale = height / oldHeight;
				docContent.height = height// - 35;
				docContent.width = oldWidth * scale;
			}
			
			//调整绘图层尺寸
			canvas.onResize( docContent.width, docContent.height/*oldHeight * scale*/, docContent.height );
			
			//调整PPT动画点击层尺寸
			_animStepLayer.width = docContent.width;
			_animStepLayer.height = docContent.height;
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
		private var _bindDocument:Document;
		public function set bindDocument( doc:Document ):void
		{
			canvas ? canvas.bindDocument = doc : _bindDocument = doc;
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
		
		private function onPresentationStartup(e:Event):void
		{
			e.currentTarget.removeEventListener( e.type, arguments.callee );
			e.preventDefault();
		}
		
		/**
		 * 翻页
		 * @param	e
		 */
		private function onSlideChanged (e:Event):void
		{
			if (_stepPlayback)
				_stepPlayback.removeEventListener ('stepChange', onStepChange);
				
			_stepPlayback = this._playbackController.currentSlideView.playbackController;
			_stepPlayback.addEventListener ('stepChange', onStepChange);

			//当前页页码
			current = _slideIndex = this._playbackController.currentSlideIndex;
			
			//切换画布
			canvas.drawPage( current + 1 );
			
			//当前页步数
			_stepCount = _stepPlayback.animationSteps.count;
		}
		
		/**
		 * 当前页步数改变
		 * @param	e
		 */
		private function onStepChange (e:Event):void
		{
			/**
			 * 刚登陆后，可能就会收到远端的文档翻页动作
			 * 但由于此时本地文档并没有加载完毕，所以只能
			 * 先把页码和步数保存下来，待文档加载完毕后再
			 * 执行。
			 */
			if (_stepIndexPreset != -1)
			{
				return;
			}
			
			_stepIndex = _stepPlayback.currentStepIndex;
			animationChangedCallback.apply(null, [_slideIndex, _stepIndex]);
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