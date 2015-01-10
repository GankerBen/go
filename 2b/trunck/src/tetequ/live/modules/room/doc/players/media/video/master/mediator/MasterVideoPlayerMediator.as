package tetequ.live.modules.room.doc.players.media.video.master.mediator 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import flash.utils.Timer;
	import org.flexlite.domUI.components.Alert;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.core.DragSource;
	import org.flexlite.domUI.events.CloseEvent;
	import org.flexlite.domUI.events.DragEvent;
	import org.flexlite.domUI.events.UIEvent;
	import org.flexlite.domUI.managers.DragManager;
	import robotlegs.bender.bundles.mvcs.Mediator;
	import tetequ.live.core.network.NetworkFacade;
	import tetequ.live.modules.room.common.drag.DragManagerLite;
	import tetequ.live.modules.room.doc.players.common.events.CallPlayerEvent;
	import tetequ.live.modules.room.doc.players.common.events.DocCloseEvent;
	import tetequ.live.modules.room.doc.players.common.MasterPlayerManager;
	import tetequ.live.modules.room.doc.players.common.PlayerID;
	import tetequ.live.modules.room.doc.players.media.common.events.FirstPlayEvent;
	import tetequ.live.modules.room.doc.players.media.common.events.MediaPlayChangeVolumeEvent;
	import tetequ.live.modules.room.doc.players.media.common.events.MediaPlaySeekEvent;
	import tetequ.live.modules.room.doc.players.media.common.events.MediaPlayTogglePauseEvent;
	import tetequ.live.modules.room.doc.players.media.common.MediaStatusCache;
	import tetequ.live.modules.room.doc.players.media.video.common.MasterVideoPlayerManager;
	import tetequ.live.modules.room.doc.players.media.video.common.VideoData;
	import tetequ.live.modules.room.doc.players.media.video.common.VideoDataCenter;
	import tetequ.live.modules.room.doc.players.media.video.master.view.MasterVideoPlayer;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class MasterVideoPlayerMediator extends Mediator 
	{
		[Inject]
		public var view:MasterVideoPlayer;
		
		[Inject]
		public var dataCenter:VideoDataCenter;
		
		[Inject]
		public var networkFacade:NetworkFacade;
		
		[Inject]
		public var playerManager:MasterVideoPlayerManager;
		
		private var _data:VideoData;
		private var _timer:Timer;
		private var _mediaStatusCache:MediaStatusCache = new MediaStatusCache();
		private var _isSliding:Boolean;
		
		public function MasterVideoPlayerMediator() 
		{
			super();
			
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			if ( view.getVisualContent() )
			{
				_data = dataCenter.getVideoData( view.getVisualContent().getSource() );
			}
			
			this.addContextListener( CallPlayerEvent.MASTER_VIDEO, onPlayerCalled, CallPlayerEvent );
			
			//设置比较高的优先级，以便第一时间停止视频流
			view.addEventListener( Event.REMOVED_FROM_STAGE, onRemoved, false, 1000 );
			
			//本地关闭播放器
			view.addEventListener( CloseEvent.CLOSE, onLocalCloseCalled );
			
			//远程关闭播放器
			this.addContextListener( DocCloseEvent.CLOSE_VIDEO_MASTER, onRemoteCloseCalled, DocCloseEvent );
			
			//播放、暂停
			this.addContextListener( MediaPlayTogglePauseEvent.TOGGLE_PAUSE, onTogglePauseCalled, MediaPlayTogglePauseEvent );
			
			//音量调节
			this.addContextListener( MediaPlayChangeVolumeEvent.CHANGE_VOLUME, onChangeVolumeCalled, MediaPlayChangeVolumeEvent );
			
			//seek
			this.addContextListener( MediaPlaySeekEvent.SEEK, onSeekCalled, MediaPlaySeekEvent );
			
			//令牌变了
			this.addContextListener( TokenChangedEvent.TOKEN_CHANGED, onTokenChangedCalled, TokenChangedEvent );
			
			//拖动
			DragManagerLite.registerDraggable( this.view );
		}
		
		private function onTokenChangedCalled(e:TokenChangedEvent):void 
		{
			if ( networkFacade.hasToken )
			{
				networkFacade.mediaPlaySeek( _data.getSource(), _mediaStatusCache.time );
			}
		}
		
		private function onSeekCalled(e:MediaPlaySeekEvent):void 
		{
			if ( _data.getSource() == e.file )
			{
				if ( !_data.isReady ) {
					_mediaStatusCache.time = e.time;
					return;
				}
				
				_data.seek( e.time );
				updateBtnByPaused( networkFacade.isMediaPlayPaused( _data.getSource() ) );
			}
		}
		
		private function onChangeVolumeCalled(e:MediaPlayChangeVolumeEvent):void 
		{
			if ( _data.getSource() == e.file )
			{
				if ( !_data.isReady ) {
					_mediaStatusCache.volume = e.volume;
					return;
				}
				_data.setVolume( e.volume );
				//FIXME:假设volume为0或者1，目前UI只能表现静音或者声音两种状态
				updateBtnByVolume( e.volume );
			}
		}

		private function onTogglePauseCalled(e:MediaPlayTogglePauseEvent):void 
		{
			if ( _data.getSource() == e.file )
			{
				if ( !_data.isReady ) {
					_mediaStatusCache.paused = e.paused;
					return;
				}
				_data.setPaused( e.paused );
				updateBtnByPaused( networkFacade.isMediaPlayPaused( _data.getSource() ) );
			}
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
			if ( _data.getTotalTime() - _data.getCurTime() < 1000 && _data.getTotalTime() > 0 )
			{
				_data.seek( 0 );
				networkFacade.mediaPlaySeek( _data.getSource(), 0 );
			}
			
			view.setCurrentTime( _data.getCurTime() );
			if( _data.getTotalTime() > 0 )
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
		
		private var _lastTime:Number = 0;
	
		private function onSliderValueChangeStart(e:UIEvent):void 
		{
			if ( !_timer ) {
				initTimer();
				return;
			}
			_isSliding = true;
			_timer.removeEventListener( TimerEvent.TIMER, onTimer );
			_timer.stop();
			_lastTime = view.slider.value;
			view.slider.addEventListener( UIEvent.CHANGE_END, onSliderValueChangeEnd );
		}
		
		private function onSliderValueChangeEnd(e:UIEvent):void 
		{
			view.slider.removeEventListener( UIEvent.CHANGE_END, onSliderValueChangeEnd );
			
			if ( !_timer ) return;
			_isSliding = false;
			_timer.addEventListener( TimerEvent.TIMER, onTimer );
			_timer.start();
			
			if ( !networkFacade.hasToken )
			{
				Alert.show( "对不起，您没有权限，不能进行该操作." );
				view.slider.value = _lastTime;
				return;
			}
			
			if( _lastTime != view.slider.value )
			{
				_data.seek( view.slider.value / 1000 );
				networkFacade.mediaPlaySeek( _data.getSource(), view.slider.value / 1000 );
				_lastTime = 0;
				//if ( networkFacade.isMediaPlayPaused( _data.getSource() ) )
					//networkFacade.mediaPlayTogglePause( _data.getSource() );
				updateBtnByPaused( networkFacade.isMediaPlayPaused( _data.getSource() ) );
			}
		}
		
		private function onClick(e:MouseEvent):void 
		{
			if ( !networkFacade.hasToken )
			{
				Alert.show( "对不起，您没有权限，不能进行该操作." );
				return;
			}
			
			if ( _isSliding )
			{
				Alert.show( "对不起，您的操作过于频繁，请稍后再试!" );
				return;
			}
			
			switch( e.currentTarget )
			{
				case view.btnMute:
					updateBtnByVolume( 0 );
					_data.toggleMute();
					networkFacade.mediaPlayChangeVolume( _data.getSource(), 0 );
					break;
				case view.btnPlay:
					updateBtnByPaused( !networkFacade.isMediaPlayPaused(_data.getSource()) );
					_data.resume();
					networkFacade.mediaPlayTogglePause( _data.getSource() );
					break;
				case view.btnStop:
					updateBtnByPaused( !networkFacade.isMediaPlayPaused(_data.getSource()) );
					_data.pause();
					networkFacade.mediaPlayTogglePause( _data.getSource() );
					break;
				case view.btnVoice:
					updateBtnByVolume( 1 );
					_data.toggleMute();
					networkFacade.mediaPlayChangeVolume( _data.getSource(), 1 );
					break;
				default:
					break;
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
		
		/**
		 * 本地关闭播放器
		 * @param	e
		 */
		private function onLocalCloseCalled(e:CloseEvent):void 
		{
			if ( !networkFacade.hasToken )
			{
				Alert.show( "对不起，您没有权限，不能进行该操作!" );
				return;
			}
			
			networkFacade.closePrevMedia( PlayerID.MASTER_VIDEO_PLAYER );
			playerManager.closePlayerById( this.view.id );
		}
		
		private function onRemoved(e:Event):void 
		{
			view.removeEventListener( Event.REMOVED_FROM_STAGE, onRemoved, false );
			clearTimer();
			if( _data )
			_data.reset();
		}
		
		override public function destroy():void
		{
			super.destroy();
			clearTimer();
			this.removeContextListener( CallPlayerEvent.MASTER_VIDEO, onPlayerCalled, CallPlayerEvent );
			this.removeContextListener( DocCloseEvent.CLOSE_VIDEO_MASTER, onRemoteCloseCalled, DocCloseEvent );
			this.removeContextListener( MediaPlayTogglePauseEvent.TOGGLE_PAUSE, onTogglePauseCalled, MediaPlayTogglePauseEvent );
			this.removeContextListener( MediaPlayChangeVolumeEvent.CHANGE_VOLUME, onChangeVolumeCalled, MediaPlayChangeVolumeEvent );
			this.removeContextListener( MediaPlaySeekEvent.SEEK, onSeekCalled, MediaPlaySeekEvent );
			view.removeEventListener( Event.REMOVED_FROM_STAGE, onRemoved, false );
			view.removeEventListener( CloseEvent.CLOSE, onLocalCloseCalled );
			view.btnMute.removeEventListener( MouseEvent.CLICK, onClick );
			view.btnPlay.removeEventListener( MouseEvent.CLICK, onClick );
			view.btnStop.removeEventListener( MouseEvent.CLICK, onClick );
			view.btnVoice.removeEventListener( MouseEvent.CLICK, onClick );
			view.slider.removeEventListener( UIEvent.CHANGE_END, onSliderValueChangeEnd );
			view.slider.removeEventListener( UIEvent.CHANGE_START, onSliderValueChangeStart );
			
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

			//隐藏播放按钮，因为默认就播放了
			updateBtnByPaused( false );
			updateBtnByVolume( 1 );
			
			//监听数据初始化完成
			if( !_data.isReady )
			{
				//等待画面
				view.showTips();
				_data.addEventListener( FirstPlayEvent.FIRST, onDataFirstPlay );
			}else 
			{
				view.hideTips();
				view.btnMute.addEventListener( MouseEvent.CLICK, onClick );
				view.btnPlay.addEventListener( MouseEvent.CLICK, onClick );
				view.btnStop.addEventListener( MouseEvent.CLICK, onClick );
				view.btnVoice.addEventListener( MouseEvent.CLICK, onClick );
				view.slider.addEventListener( UIEvent.CHANGE_START, onSliderValueChangeStart );	
				_data.setPaused( _mediaStatusCache.paused );
				_data.seek( _mediaStatusCache.time );
				
				networkFacade.mediaPlaySeek( _data.getSource(), _mediaStatusCache.time );
				
				_data.setVolume( _mediaStatusCache.volume );
				
				updateBtnByPaused( _mediaStatusCache.paused );
				updateBtnByVolume( _mediaStatusCache.volume );
				initTimer();
			}
			
			/**
			 * 开始播放
			 */
			_data.resume();

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
			view.hideTips();
			view.btnMute.addEventListener( MouseEvent.CLICK, onClick );
			view.btnPlay.addEventListener( MouseEvent.CLICK, onClick );
			view.btnStop.addEventListener( MouseEvent.CLICK, onClick );
			view.btnVoice.addEventListener( MouseEvent.CLICK, onClick );
			view.slider.addEventListener( UIEvent.CHANGE_START, onSliderValueChangeStart );
			_data.removeEventListener( FirstPlayEvent.FIRST, onDataFirstPlay );
			_data.setPaused( _mediaStatusCache.paused );
			_data.seek( _mediaStatusCache.time );
			networkFacade.mediaPlaySeek( _data.getSource(), _mediaStatusCache.time );
			_data.setVolume( _mediaStatusCache.volume );
			
			updateBtnByPaused( _mediaStatusCache.paused );
			updateBtnByVolume( _mediaStatusCache.volume );

			initTimer();
		}
		
		private function updateBtnByPaused( paused:Boolean ):void
		{
			if ( paused )
			{
				view.btnStop.visible = false;
				view.btnPlay.visible = true;
			}else 
			{
				view.btnStop.visible = true;
				view.btnPlay.visible = false;
			}
		}
		
		private function updateBtnByVolume( volume:Number ):void
		{
			if ( volume == 0 )
			{
				view.btnMute.visible = false;
				view.btnVoice.visible = true;
			}else 
			{
				view.btnMute.visible = true;
				view.btnVoice.visible = false;
			}
		}
		
	}

}