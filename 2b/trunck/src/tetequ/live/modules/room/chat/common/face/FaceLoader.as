package tetequ.live.modules.room.chat.common.face 
{
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import framework.view.UIRoot;
	import org.bytearray.gif.events.GIFPlayerEvent;
	import org.bytearray.gif.frames.GIFFrame;
	import org.bytearray.gif.player.GIFPlayer;
	import org.flexlite.domUI.components.UIAsset;
	import tetequ.live.core.assets.events.GroupCompleteEvent;
	import tetequ.live.modules.room.common.GlobalVars;
	import tetequ.live.modules.room.error.FrozenLayer;
	/**
	 * ...
	 * @author Pandazhong
	 * 表情加载器
	 */
	public class FaceLoader 
	{
		[Inject]
		public var eventDispatcher:IEventDispatcher;
		
		[Inject]
		public var frozen:FrozenLayer;
		
		[Inject]
		public var uiroot:UIRoot;
		
		/**
		 * 用于加载并解析gif文件为多帧位图数据
		 */
		private var _loader:GIFPlayer;
		
		/**
		 * 是否加载完
		 */
		private var _loaded:Boolean;
		
		/**
		 * 是否正在加载
		 */
		private var _loading:Boolean;
		
		/**
		 * 表情文件名后缀
		 */
		private var _faceNameIndex:int = 1;
		
		/**
		 * 表情动画
		 */
		private var _faceAnimations:Vector.<GIFPlayer>;

		public function FaceLoader() 
		{
			init();
		}
		
		private function init():void 
		{
			_faceAnimations = new Vector.<GIFPlayer>;
		}
		
		public function loadAllFace():void
		{
			if ( !_loaded )
			{
				//frozen.show( "正在加载表情素材，请稍候...", uiroot );
			}
			next();
		}
		
		private function next():void
		{
			if ( _loaded )
			{
				//frozen.hide();
				eventDispatcher.dispatchEvent( new GroupCompleteEvent(GroupCompleteEvent.GROUP_COMPLETE, 'face') );
				return;
			}
			
			if ( _loading )
			{
				return;
			}

			_loading = true;
			_loader = new GIFPlayer( true );
			_loader.id = _faceNameIndex;
			_loader.addEventListener( IOErrorEvent.IO_ERROR, onIOError );
			_loader.addEventListener( GIFPlayerEvent.COMPLETE, onComplete );
			_loader.load( new URLRequest( GlobalVars.topUri + "app/web/assets/face/" + _faceNameIndex + ".gif" ) );
		}
		
		/**
		 * 当前表情加载完毕
		 * @param	e
		 */
		private function onComplete(e:GIFPlayerEvent):void 
		{
			_loader.removeEventListener( IOErrorEvent.IO_ERROR, onIOError );
			_loader.removeEventListener( GIFPlayerEvent.COMPLETE, onComplete );
			_faceAnimations.push( _loader );
			
			if ( _faceNameIndex == GlobalVars.MAX_FACE_INDEX ) {
				_loaded = true;
				_loading = false;
				//frozen.hide();
				eventDispatcher.dispatchEvent( new GroupCompleteEvent(GroupCompleteEvent.GROUP_COMPLETE, 'face') );
				return;
			}else 
			{
				_faceNameIndex++;
				_loading = false;
				next();
			}
		}
		
		/**
		 * 加载过程中遇到IO错误
		 * @param	e
		 */
		private function onIOError(e:IOErrorEvent):void 
		{
			trace( "加载遇到错误!" );
		}
		
		/**
		 * 获取一组表情动画
		 */
		public function get faceAnimations():Vector.<GIFPlayer> 
		{
			return _faceAnimations;
		}
		
	}

}