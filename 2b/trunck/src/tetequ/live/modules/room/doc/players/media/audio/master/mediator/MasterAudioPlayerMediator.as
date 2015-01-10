package tetequ.live.modules.room.doc.players.media.audio.master.mediator 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import org.flexlite.domUI.components.Alert;
	import org.flexlite.domUI.events.CloseEvent;
	import org.flexlite.domUI.events.UIEvent;
	import robotlegs.bender.bundles.mvcs.Mediator;
	import tetequ.live.core.network.NetworkFacade;
	import tetequ.live.modules.room.common.drag.DragManagerLite;
	import tetequ.live.modules.room.doc.players.common.events.CallPlayerEvent;
	import tetequ.live.modules.room.doc.players.common.events.DocCloseEvent;
	import tetequ.live.modules.room.doc.players.common.PlayerID;
	import tetequ.live.modules.room.doc.players.media.audio.common.AudioData;
	import tetequ.live.modules.room.doc.players.media.audio.common.AudioDataCenter;
	import tetequ.live.modules.room.doc.players.media.audio.common.MasterAudioPlayerManager;
	import tetequ.live.modules.room.doc.players.media.audio.master.view.MasterAudioPlayer;
	import tetequ.live.modules.room.doc.players.media.common.events.FirstPlayEvent;
	import tetequ.live.modules.room.doc.players.media.common.events.MediaPlayChangeVolumeEvent;
	import tetequ.live.modules.room.doc.players.media.common.events.MediaPlaySeekEvent;
	import tetequ.live.modules.room.doc.players.media.common.events.MediaPlayTogglePauseEvent;
	import tetequ.live.modules.room.doc.players.media.common.MediaStatusCache;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class MasterAudioPlayerMediator extends Mediator 
	{
		[Inject]
		public var view:MasterAudioPlayer;
		
		[Inject]
		public var dataCenter:AudioDataCenter;
		
		[Inject]
		public var playerManager:MasterAudioPlayerManager;
		
		[Inject]
		public var networkFacade:NetworkFacade;
		
		private var _data:AudioData;
		private var _timer:Timer;
		private var _mediaStatusCache:MediaStatusCache = new MediaStatusCache();
		private var _isSliding:Boolean;
		private var _st:int;
		
		public function MasterAudioPlayerMediator() 
		{
			super();
			
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			if ( view.getContent() )
			{
				_data = dataCenter.getAudioData( view.getContent().getSource() );
			}
			
			this.addContextListener( CallPlayerEvent.MASTER_AUDIO, onPlayerCalled, CallPlayerEvent );
			
			//设置比较高的优先级，以便第一时间停止视频流
			view.addEventListener( Event.REMOVED_FROM_STAGE, onRemoved, false, 1000 );
			
			//本地关闭播放器
			view.addEventListener( CloseEvent.CLOSE, onLocalCloseCalled );
			
			//远程关闭播放器
			this.addContextListener( DocCloseEvent.CLOSE_AUDIO_MASTER, onRemoteCloseCalled, DocCloseEvent );
			
			//播放、暂停
			this.addContextListener( MediaPlayTogglePauseEvent.TOGGLE_PAUSE, onTogglePauseCalled, MediaPlayTogglePauseEvent );
			
			//音量调节
			this.addContextListener( MediaPlayChangeVolumeEvent.CHANGE_VOLUME, onChangeVolumeCalled, MediaPlayChangeVolumeEvent );
			
			//seek
			this.addContextListener( MediaPlaySeekEvent.SEEK, onSeekCalled, MediaPlaySeekEvent );
			
			//view.btnClose.addEventListener( MouseEvent.CLICK, onClick );
			view.btnMute.addEventListener( MouseEvent.CLICK, onClick );
			view.btnPlay.addEventListener( MouseEvent.CLICK, onClick );
			view.btnStop.addEventListener( MouseEvent.CLICK, onClick );
			view.btnVoice.addEventListener( MouseEvent.CLICK, onClick );
			view.slider.addEventListener( UIEvent.CHANGE_START, onSliderValueChangeStart );
			
			DragManagerLite.registerDraggable( this.view );
		}
		
		[Inline]
		private function onSeekCalled(e:MediaPlaySeekEvent):void 
		{
			if ( _data.getSource() == e.file )
			{
				if ( !_data.isReady )
				{
					_mediaStatusCache.time = e.time;
					return;
				}
				_data.seek( e.time );
				updateBtnByPaused( networkFacade.isMediaPlayPaused( _data.getSource() ) );
			}
		}
		
		[Inline]
		private function onChangeVolumeCalled(e:MediaPlayChangeVolumeEvent):void 
		{
			if ( _data.getSource() == e.file )
			{
				if ( !_data.isReady )
				{
					_mediaStatusCache.volume = e.volume;
					return;
				}
				
				_data.setVolume( e.volume );
				
				//FIXME:假设volume为0或者1，目前UI只能表现静音或者声音两种状态
				updateBtnByVolume( e.volume );
			}
		}
		
		[Inline]
		private function onTogglePauseCalled(e:MediaPlayTogglePauseEvent):void 
		{
			if ( _data.getSource() == e.file )
			{
				if ( !_data.isReady )
				{
					_mediaStatusCache.paused = e.paused;
					return;
				}
				
				_data.setPaused( e.paused );
				
				updateBtnByPaused( networkFacade.isMediaPlayPaused( _data.getSource() ) );
			}
		}
		
		private var _lastTime:Number = 0;
		[Inline]
		private function onSliderValueChangeStart(e:UIEvent):void 
		{
			if ( !_timer ) return;
			_isSliding = true;
			_timer.removeEventListener( TimerEvent.TIMER, onTimer );
			_timer.stop();
			_lastTime = view.slider.value;
			view.slider.addEventListener( UIEvent.CHANGE_END, onSliderValueChangeEnd );
		}
		
		private function onSliderValueChangeEnd(e:UIEvent):void 
		{
			view.slider.removeEventListener( UIEvent.CHANGE_END, onSliderValueChangeEnd );
			_isSliding = false;
			if ( !_timer ) return;
			_timer.addEventListener( TimerEvent.TIMER, onTimer );
			_timer.start();
			
			if ( !networkFacade.hasToken )
			{
				view.slider.value = _lastTime;
				Alert.show( "对不起，您没有权限，不能进行该操作." );
				return;
			}
			
			if( _lastTime != view.slider.value )
			{
				_data.seek( view.slider.value / 1000 );
				networkFacade.mediaPlaySeek( _data.getSource(), view.slider.value / 1000 );
				if ( networkFacade.isMediaPlayPaused( _data.getSource() ) )
					networkFacade.mediaPlayTogglePause( _data.getSource() );
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
				//case view.btnClose:
					//networkFacade.closePrevMedia( PlayerID.MASTER_AUDIO_PLAYER );
					//playerManager.closePlayerById( this.view.id );
					//break;
				case view.btnMute:
					updateBtnByVolume( 0 );
					_data.toggleMute();
					networkFacade.mediaPlayChangeVolume( _data.getSource(), 0 );
					break;
				case view.btnPlay:
					updateBtnByPaused( false );
					_data.resume();
					networkFacade.mediaPlayTogglePause( _data.getSource() );
					break;
				case view.btnStop:
					updateBtnByPaused( true );
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
			
			networkFacade.closePrevMedia( PlayerID.MASTER_AUDIO_PLAYER );
			playerManager.closePlayerById( this.view.id );
		}
		
		private function onRemoved(e:Event):void 
		{
			view.removeEventListener( Event.REMOVED_FROM_STAGE, onRemoved, false );
			clearTimer();
			_data.reset();
		}
		
		override public function destroy():void
		{
			super.destroy();
			
			this.removeContextListener( CallPlayerEvent.MASTER_AUDIO, onPlayerCalled, CallPlayerEvent );
			this.removeContextListener( DocCloseEvent.CLOSE_AUDIO_MASTER, onRemoteCloseCalled, DocCloseEvent );
			this.removeContextListener( MediaPlayTogglePauseEvent.TOGGLE_PAUSE, onTogglePauseCalled, MediaPlayTogglePauseEvent );
			this.removeContextListener( MediaPlayChangeVolumeEvent.CHANGE_VOLUME, onChangeVolumeCalled, MediaPlayChangeVolumeEvent );
			this.removeContextListener( MediaPlaySeekEvent.SEEK, onSeekCalled, MediaPlaySeekEvent );
			view.removeEventListener( Event.REMOVED_FROM_STAGE, onRemoved, false );
			view.removeEventListener( CloseEvent.CLOSE, onLocalCloseCalled );
			//view.btnClose.removeEventListener( MouseEvent.CLICK, onClick );
			view.btnMute.removeEventListener( MouseEvent.CLICK, onClick );
			view.btnPlay.removeEventListener( MouseEvent.CLICK, onClick );
			view.btnStop.removeEventListener( MouseEvent.CLICK, onClick );
			view.btnVoice.removeEventListener( MouseEvent.CLICK, onClick );
			view.slider.removeEventListener( UIEvent.CHANGE_END, onSliderValueChangeEnd );
			_data.removeEventListener( FirstPlayEvent.FIRST, onDataFirstPlay );
			_data = null;
			dataCenter = null;
			view = null;
			clearTimer();
		}
		
		/**
		 * 播放音频
		 * @param	e
		 */
		private function onPlayerCalled(e:CallPlayerEvent):void 
		{
			if ( _data )
			{
				if ( _data.getSource() != e.fileInfo.path )
				{
					_data.reset();
				}
			}
			
			_data = dataCenter.getAudioData( e.fileInfo.path );
			
			//设置播放器标题为文档名
			view.title =  e.fileInfo.name;
			
			//打开了一个新的文档，注册到文档数据中心
			if ( !_data || !dataCenter.getAudioData( e.fileInfo.path ) )
			{
				dataCenter.registerAudioData( e.fileInfo );
			}
			
			//即将要播放的文档数据
			_data = dataCenter.getAudioData( e.fileInfo.path );
			
			//监听数据初始化完成
			_data.addEventListener( FirstPlayEvent.FIRST, onDataFirstPlay );

			//FIXME:目前来看，设置内容没有太大意义，待重构
			view.setContent( _data );

			//隐藏播放按钮，因为默认就播放了
			updateBtnByPaused( false );
			updateBtnByVolume( 1 );
			
			//计时器
			initTimer();
			
			//开始播放
			_data.resume();
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
			if ( _data.getTotalTime() == 0 ) return;
			if ( _data.getTotalTime() - _data.getCurTime() < 1000 )
			{
				_data.seek( 0 );
				networkFacade.mediaPlaySeek( _data.getSource(), 0 );
			}
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
		
		/**
		 * 流第一次播放，强制seek一次
		 * @param	e
		 */
		private function onDataFirstPlay(e:FirstPlayEvent):void 
		{
			_data.removeEventListener( FirstPlayEvent.FIRST, onDataFirstPlay );
			_data.setPaused( _mediaStatusCache.paused );
			_data.seek( _mediaStatusCache.time );
			if ( !_mediaStatusCache.paused )
				_data.resume();
			_data.setVolume( _mediaStatusCache.volume );
			
			updateBtnByPaused( _mediaStatusCache.paused );
			updateBtnByVolume( _mediaStatusCache.volume );
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