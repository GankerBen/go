package tetequ.live.modules.room.doc.players.media.video.normal.mediator 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import org.flexlite.domUI.components.Group;
	import robotlegs.bender.bundles.mvcs.Mediator;
	import tetequ.live.core.network.NetworkFacade;
	import tetequ.live.modules.room.common.drag.DragManagerLite;
	import tetequ.live.modules.room.doc.players.common.events.CallPlayerEvent;
	import tetequ.live.modules.room.doc.players.common.events.DocCloseEvent;
	import tetequ.live.modules.room.doc.players.common.StudentPlayerManager;
	import tetequ.live.modules.room.doc.players.media.common.events.FirstPlayEvent;
	import tetequ.live.modules.room.doc.players.media.common.events.MediaPlayChangeVolumeEvent;
	import tetequ.live.modules.room.doc.players.media.common.events.MediaPlaySeekEvent;
	import tetequ.live.modules.room.doc.players.media.common.events.MediaPlayTogglePauseEvent;
	import tetequ.live.modules.room.doc.players.media.common.MediaStatusCache;
	import tetequ.live.modules.room.doc.players.media.video.common.StudentVideoPlayerManager;
	import tetequ.live.modules.room.doc.players.media.video.common.VideoData;
	import tetequ.live.modules.room.doc.players.media.video.common.VideoDataCenter;
	import tetequ.live.modules.room.doc.players.media.video.normal.view.NormalVideoPlayer;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class NormalVideoPlayerMediator extends Mediator 
	{
		[Inject]
		public var view:NormalVideoPlayer;

		[Inject]
		public var dataCenter:VideoDataCenter;
		
		[Inject]
		public var networkFacade:NetworkFacade;
		
		[Inject]
		public var playerManager:StudentVideoPlayerManager;
		
		private var _data:VideoData;
		
		private var _timer:Timer;
		
		private var _mediaStatusCache:MediaStatusCache = new MediaStatusCache();
		
		public function NormalVideoPlayerMediator() 
		{
			super();
			
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			view.showCloseButton = false;
			
			if ( !_data && view.getVisualContent() )
			{
				_data = dataCenter.getVideoData( view.getVisualContent().getSource() );
			}
			
			this.addContextListener( CallPlayerEvent.NORMAL_VIDEO, onPlayerCalled, CallPlayerEvent );
			
			//设置比较高的优先级，以便第一时间停止视频流
			view.addEventListener( Event.REMOVED_FROM_STAGE, onRemoved, false, 1000 );
			
			//远程关闭播放器
			this.addContextListener( DocCloseEvent.CLOSE_VIDEO_NORMAL, onRemoteCloseCalled, DocCloseEvent );
			
			//播放、暂停
			this.addContextListener( MediaPlayTogglePauseEvent.TOGGLE_PAUSE, onTogglePauseCalled, MediaPlayTogglePauseEvent );
			
			//音量调节
			this.addContextListener( MediaPlayChangeVolumeEvent.CHANGE_VOLUME, onChangeVolumeCalled, MediaPlayChangeVolumeEvent );
			
			//seek
			this.addContextListener( MediaPlaySeekEvent.SEEK, onSeekCalled, MediaPlaySeekEvent );
			
			this.view.slider.mouseChildren = false;
			this.view.slider.mouseEnabled = false;
			
			DragManagerLite.registerDraggable( this.view );
		}
		
		[Inline]
		private function onSeekCalled(e:MediaPlaySeekEvent):void 
		{
			if ( _data.getSource() == e.file )
			{
				if ( !_data.isReady ) {
					_mediaStatusCache.time = e.time;
					return;
				}
				
				_data.seek( e.time );
			}
		}
		
		[Inline]
		private function onChangeVolumeCalled(e:MediaPlayChangeVolumeEvent):void 
		{
			if ( _data.getSource() == e.file )
			{
				if ( !_data.isReady ) {
					_mediaStatusCache.volume = e.volume;
					return;
				}
				
				_data.setVolume( e.volume );
			}
		}
		
		[Inline]
		private function onTogglePauseCalled(e:MediaPlayTogglePauseEvent):void 
		{
			if ( _data.getSource() == e.file )
			{
				if ( !_data.isReady ) {
					_mediaStatusCache.paused = e.paused;
					return;
				}
				
				_data.setPaused( e.paused );
			}
		}
		
		/**
		 * 远程关闭播放器
		 * @param	e
		 */
		private function onRemoteCloseCalled(e:DocCloseEvent):void 
		{
			playerManager.closePlayerById( this.view.id );
		}
		
		private function onRemoved(e:Event):void 
		{
			view.removeEventListener( Event.REMOVED_FROM_STAGE, onRemoved, false );
			clearTimer();
			_data.reset();
		}
		
		private function initTimer():void 
		{
			if ( !_timer )
			{
				_timer = new Timer( 1000 );
				_timer.addEventListener( TimerEvent.TIMER, onTimer );
				_timer.start();
			}
		}
		
		private function onTimer(e:TimerEvent):void 
		{
			view.setCurrentTime( _data.getCurTime() );
			view.setTotalTime( _data.getTotalTime() );
			view.slider.value = _data.getCurTime();
		}
		
		private function clearTimer():void
		{
			if ( _timer )
			{
				_timer.removeEventListener( TimerEvent.TIMER, onTimer );
				_timer.stop();
				_timer = null;
			}
		}
		
		override public function destroy():void
		{
			super.destroy();
			clearTimer();
			this.removeContextListener( CallPlayerEvent.NORMAL_VIDEO, onPlayerCalled, CallPlayerEvent );
			this.removeContextListener( DocCloseEvent.CLOSE_VIDEO_NORMAL, onRemoteCloseCalled, DocCloseEvent );
			this.removeContextListener( MediaPlayTogglePauseEvent.TOGGLE_PAUSE, onTogglePauseCalled, MediaPlayTogglePauseEvent );
			this.removeContextListener( MediaPlayChangeVolumeEvent.CHANGE_VOLUME, onChangeVolumeCalled, MediaPlayChangeVolumeEvent );
			this.removeContextListener( MediaPlaySeekEvent.SEEK, onSeekCalled, MediaPlaySeekEvent );
			view.removeEventListener( Event.REMOVED_FROM_STAGE, onRemoved, false );
			
			if( _data )
			{
				_data.removeEventListener( FirstPlayEvent.FIRST, onDataFirstPlay );
				_data = null;
			}
			
			dataCenter = null;
			view = null;
		}
		
		/**
		 * 播放视频
		 * @param	e
		 */
		private function onPlayerCalled(e:CallPlayerEvent):void 
		{
			/**
			 * 文档播放请求时，可能是由于选择了与当前文档
			 * 不同的其他文档，此时，播放器的可视内容是存在
			 * 的，只是_data需要重新获取，因为此时_data将不再
			 * 是当前正在播放文档的data
			 */
			if ( view.getVisualContent() ) {
				_data = dataCenter.getVideoData( e.fileInfo.path );
			}
			
			/**
			 * 设置播放器标题为文档名
			 */
			view.title = e.fileInfo.name;
			
			/**
			 * 打开了一个新的文档，注册到文档数据中心
			 */
			if ( !_data || !dataCenter.getVideoData( e.fileInfo.path ) )
			{
				dataCenter.registerVideoData( e.fileInfo );
			}
			
			/**
			 * 即将要播放的文档数据
			 */
			_data = dataCenter.getVideoData( e.fileInfo.path );
			
			/**
			 * 设置当前文档内容的尺寸变化回调
			 */
			_data.setResizeDelayCall( view.onStageResize );

			/**
			 * 替换显示内容为即将播放的文档
			 */
			view.setVisualContent( _data );
			
			//监听数据初始化完成
			_data.addEventListener( FirstPlayEvent.FIRST, onDataFirstPlay );
			
			/**
			 * 开始播放
			 */
			_data.resume();
			
			initTimer();
			
			/**
			 * 强制刷新文档内容尺寸适应播放器尺寸
			 */
			view.onStageResize();
		}
		
		/**
		 * 流第一次播放，强制seek一次
		 * @param	e
		 */
		private function onDataFirstPlay(e:FirstPlayEvent):void 
		{
			_data.removeEventListener( FirstPlayEvent.FIRST, onDataFirstPlay );
			_data.setPaused( _mediaStatusCache.paused );
			_data.seek( _mediaStatusCache.time );
			if ( !networkFacade.isMediaPlayPaused( _data.getSource() ) )
				_data.resume();
			_data.setVolume( _mediaStatusCache.volume );
		}
		
	}

}