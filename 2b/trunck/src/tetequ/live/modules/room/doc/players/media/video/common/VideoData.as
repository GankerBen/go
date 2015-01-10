package tetequ.live.modules.room.doc.players.media.video.common 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;
	import flash.utils.Timer;
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.domUI.core.IVisualElement;
	import org.flexlite.domUI.events.UIEvent;
	import org.flexlite.domUI.utils.callLater;
	import tetequ.live.modules.room.doc.common.IFileInfo;
	import tetequ.live.modules.room.doc.players.common.interfaces.IResizable;
	import tetequ.live.modules.room.doc.players.media.common.events.FirstPlayEvent;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class VideoData extends EventDispatcher implements IResizable
	{
		protected var metadata:IFileInfo;
		protected var content:UIAsset;
		protected var delay:Function;
		
		protected var video:Video;
		protected var netConnection:NetConnection;
		protected var netStream:NetStream;
		protected var hasConnected:Boolean;
		
		private var _volume:Number = 1;
		private var _duration:Number = 0;
		
		//如果是第一次播放，则需要强制刷新一下流的时间戳，以便和发起文档同步
		private var _isFirstPlay:Boolean = true;
		
		private var _isReady:Boolean = false;
		
		private var _isPlaying:Boolean = false;
		
		private var _client:Object;
		
		protected static const rawWidth:Number = 320;
		protected static const rawHeight:Number = 240;
		
		public function VideoData( metadata:IFileInfo ) 
		{
			this.metadata = metadata;
			init();
		}
		
		private function init():void 
		{
			video = new Video();
			
			content = new UIAsset();
			//content.top = 0;
			content.skinName = video;
			content.addEventListener( UIEvent.SKIN_CHANGED, onSkinChanged );
			
			content.horizontalCenter = 0;
			content.verticalCenter = 0;
			
			netConnection = new NetConnection();
			netConnection.connect( null );
			netStream = new NetStream( netConnection );
			netStream.addEventListener( NetStatusEvent.NET_STATUS, onNetStatus );
			_client = { };
			_client.onMetaData = onMetaDataHandler;
			netStream.client = _client;
		}
		
		private function onMetaDataHandler( data:Object ):void
		{
			_duration = data['duration'];
			if ( _duration > 0 )
			{
				if ( !_isFirstPlay ) return;
				_isFirstPlay = false;
				_isReady = true;
				_isPlaying = true;
				dispatchEvent( new FirstPlayEvent() );
			}
		}
		
		private function onNetStatus(e:NetStatusEvent):void 
		{
			switch( e.info.code )
			{
				case "NetStream.Play.Start":
					break;
				case "NetStream.Play.Failed":
					trace( "x" );
					break;
				case "NetStream.Play.StreamNotFound":
					trace( "x" );
					break;
				case "NetStream.Failed":
					trace( "x" );
					break;
				default:
					break;
			}
		}
		
		private function onSkinChanged(e:UIEvent):void 
		{
			content.removeEventListener( UIEvent.SKIN_CHANGED, onSkinChanged );
			Boolean(delay) ? delay.apply() : null;
		}
		
		/* INTERFACE tetequ.live.modules.room.doc.players.common.interfaces.IVisualContent */
		
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
			if ( isNaN( width ) || isNaN( height ) ) return;
			if ( isNaN( rawWidth ) || isNaN( rawHeight ) ) return;
			if ( oldHeight == 0 ) return;
			if ( oldWidth == 0 ) return;
			if ( width == oldWidth && height == oldHeight ) return;
			if ( width == oldWidth ) return;
			if ( width <= 0 || height <= 0 ) return;
			
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
		
		public function resume():void
		{
			if ( hasConnected )
			{
				netStream.resume();
			}else 
			{
				startConnect();
			}
			
			var st:SoundTransform = new SoundTransform( _volume );
			netStream.soundTransform = st;
			_isPlaying = true;
		}

		public function pause():void
		{
			_isPlaying = false;
			hasConnected ? netStream.pause() : null;
		}
		
		public function seek( time:Number ):void
		{
			if ( netStream )
			{
				if ( netStream.time == time ) return;
				netStream.seek( time );
			}
		}
		
		public function setVolume( volume:Number ):void
		{
			if ( _volume == volume ) return;
			var st:SoundTransform = new SoundTransform( _volume = volume );
			netStream.soundTransform = st;
		}
		
		public function setPaused( paused:Boolean ):void
		{
			if ( paused ) pause();
			else resume();
		}
		
		public function reset():void
		{
			video.attachNetStream( null );
			video.clear();
			content.skinName = null;
			netStream.pause();
			netStream.dispose();
			hasConnected = false;
			_volume = 1;
			_isPlaying = false;
		}
		
		private function startConnect():void
		{
			hasConnected = true;
			netConnection.connect( null );
			netStream.play( metadata.path );
			content.skinName = video;
			content.addEventListener( UIEvent.SKIN_CHANGED, onSkinChanged );
			video.attachNetStream( netStream );
		}
		
		//开启或者关闭声音
		public function toggleMute():void
		{
			_volume = _volume == 0 ? 1 : 0;
			var st:SoundTransform = new SoundTransform( _volume );
			netStream.soundTransform = st;
		}
		
		public function getCurTime():int
		{
			return netStream.time * 1000;
		}
		
		public function getTotalTime():int
		{
			return _duration * 1000;
		}
		
		public function get isReady():Boolean 
		{
			return _isReady;
		}
		
		public function get isPlaying():Boolean 
		{
			return _isPlaying;
		}
		
	}

}