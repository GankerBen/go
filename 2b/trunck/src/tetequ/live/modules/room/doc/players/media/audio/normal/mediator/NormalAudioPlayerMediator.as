package tetequ.live.modules.room.doc.players.media.audio.normal.mediator 
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import org.flexlite.domUI.components.Alert;
	import org.flexlite.domUI.events.CloseEvent;
	import robotlegs.bender.bundles.mvcs.Mediator;
	import tetequ.live.core.network.NetworkFacade;
	import tetequ.live.modules.room.common.drag.DragManagerLite;
	import tetequ.live.modules.room.doc.players.common.events.CallPlayerEvent;
	import tetequ.live.modules.room.doc.players.common.events.DocCloseEvent;
	import tetequ.live.modules.room.doc.players.common.PlayerID;
	import tetequ.live.modules.room.doc.players.media.audio.common.AudioData;
	import tetequ.live.modules.room.doc.players.media.audio.common.AudioDataCenter;
	import tetequ.live.modules.room.doc.players.media.audio.common.NormalAudioPlayerManager;
	import tetequ.live.modules.room.doc.players.media.audio.normal.view.NormalAudioPlayer;
	import tetequ.live.modules.room.doc.players.media.common.events.FirstPlayEvent;
	import tetequ.live.modules.room.doc.players.media.common.events.MediaPlayChangeVolumeEvent;
	import tetequ.live.modules.room.doc.players.media.common.events.MediaPlaySeekEvent;
	import tetequ.live.modules.room.doc.players.media.common.events.MediaPlayTogglePauseEvent;
	import tetequ.live.modules.room.doc.players.media.common.MediaStatusCache;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class NormalAudioPlayerMediator extends Mediator 
	{
		[Inject]
		public var view:NormalAudioPlayer;
		
		[Inject]
		public var dataCenter:AudioDataCenter;
		
		[Inject]
		public var playerManager:NormalAudioPlayerManager;
		
		[Inject]
		public var networkFacade:NetworkFacade;
		
		private var _data:AudioData;
		
		private var _timer:Timer;
		
		private var _mediaStatusCache:MediaStatusCache = new MediaStatusCache();
		
		public function NormalAudioPlayerMediator() 
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
			
			//远程控制播放器播放指定内容
			this.addContextListener( CallPlayerEvent.NORMAL_AUDIO, onPlayerCalled, CallPlayerEvent );
			
			//设置比较高的优先级，以便第一时间停止视频流
			view.addEventListener( Event.REMOVED_FROM_STAGE, onRemoved, false, 1000 );
			
			//远程关闭播放器
			this.addContextListener( DocCloseEvent.CLOSE_AUDIO_NORMAL, onRemoteCloseCalled, DocCloseEvent );
			
			//播放、暂停
			this.addContextListener( MediaPlayTogglePauseEvent.TOGGLE_PAUSE, onTogglePauseCalled, MediaPlayTogglePauseEvent );
			
			//音量调节
			this.addContextListener( MediaPlayChangeVolumeEvent.CHANGE_VOLUME, onChangeVolumeCalled, MediaPlayChangeVolumeEvent );
			
			//seek
			this.addContextListener( MediaPlaySeekEvent.SEEK, onSeekCalled, MediaPlaySeekEvent );
			
			DragManagerLite.registerDraggable( this.view );
			
			this.view.slider.mouseChildren = false;
			this.view.slider.mouseEnabled = false;
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
			_data.reset();
		}
		
		override public function destroy():void
		{
			super.destroy();
			
			clearTimer();
			this.removeContextListener( CallPlayerEvent.NORMAL_AUDIO, onPlayerCalled, CallPlayerEvent );
			this.removeContextListener( DocCloseEvent.CLOSE_AUDIO_NORMAL, onRemoteCloseCalled, DocCloseEvent );
			this.removeContextListener( MediaPlayTogglePauseEvent.TOGGLE_PAUSE, onTogglePauseCalled, MediaPlayTogglePauseEvent );
			this.removeContextListener( MediaPlayChangeVolumeEvent.CHANGE_VOLUME, onChangeVolumeCalled, MediaPlayChangeVolumeEvent );
			this.removeContextListener( MediaPlaySeekEvent.SEEK, onSeekCalled, MediaPlaySeekEvent );
			_data.removeEventListener( FirstPlayEvent.FIRST, onDataFirstPlay );
			view.removeEventListener( Event.REMOVED_FROM_STAGE, onRemoved, false );
			_data = null;
			dataCenter = null;
			view = null;
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
			view.title = e.fileInfo.name;
			
			//打开了一个新的文档，注册到文档数据中心
			if ( !_data || !dataCenter.getAudioData( e.fileInfo.path ) )
			{
				dataCenter.registerAudioData( e.fileInfo );
			}
			
			//即将要播放的文档数据
			_data = dataCenter.getAudioData( e.fileInfo.path );
			
			//监听数据初始化完成
			_data.addEventListener( FirstPlayEvent.FIRST, onDataFirstPlay );

			//设置播放器内容
			view.setContent( _data );
			
			//计时器
			initTimer();
			
			//开始播放
			_data.resume();
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
		
	}

}