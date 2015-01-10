package tetequ.live.modules.room.doc.players.media.audio.common 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import org.flexlite.domUI.utils.callLater;
	import tetequ.live.modules.room.doc.common.IFileInfo;
	import tetequ.live.modules.room.doc.players.common.interfaces.IContent;
	import tetequ.live.modules.room.doc.players.media.common.events.FirstPlayEvent;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class AudioData extends EventDispatcher implements IContent
	{
		protected var metadata:IFileInfo;
		protected var sound:Sound;
		protected var soundChannel:SoundChannel;
		
		private var _isPlaying:Boolean;
		private var _timestamp:int;
		private var _volume:Number = 1;
		
		private var _isReady:Boolean = false;
		
		public function AudioData( metadata:IFileInfo ) 
		{
			this.metadata = metadata;
			init();
		}
		
		private function init():void 
		{
			
		}
		
		public function getSource():String
		{
			return metadata.path;
		}
		
		public function resume():void
		{
			if ( !sound )
			{
				sound = new Sound( new URLRequest( metadata.path ) );
			}
				
			clearSoundChannel();
			soundChannel = sound.play( _timestamp );
			soundChannel.soundTransform = new SoundTransform( _volume );
			soundChannel.addEventListener( Event.SOUND_COMPLETE, onSoundComplete );
			_isPlaying = true;
			
			if ( !_isReady )
			{
				_isReady = true;
				dispatchEvent( new FirstPlayEvent() );
			}
		}
		
		//声音总时长-毫秒
		public function getTotalTime():int
		{
			return sound.length;
		}
		
		//声音播放的当前时间戳-毫秒
		public function getCurTime():int
		{
			if ( _isPlaying )
			{
				return soundChannel.position;
			}
			
			return _timestamp;
		}
		
		//开启或者关闭声音
		public function toggleMute():void
		{
			_volume = _volume == 0 ? 1 : 0;
			if ( soundChannel )
			{
				var st:SoundTransform = new SoundTransform( _volume );
				soundChannel.soundTransform = st;
			}
		}

		public function pause():void
		{
			if ( !_isPlaying ) return;
			if ( !sound ) return;
			
			_timestamp = soundChannel.position;
			clearSoundChannel();
			
			_isPlaying = false;
		}
		
		public function play( timestamp:int ):void
		{
			_timestamp = timestamp;
			resume();
		}
		
		public function seek( time:Number ):void
		{
			pause();
			play( _timestamp = time * 1000 );
		}
		
		public function setPaused( paused:Boolean ):void
		{
			if ( paused )
			{
				pause();
			}else 
			{
				resume();
			}
		}
		
		public function setVolume( volume:Number ):void
		{
			if ( _volume == volume ) return;
			_volume = volume;
			if ( soundChannel )
			{
				var st:SoundTransform = new SoundTransform( _volume );
				soundChannel.soundTransform = st;
			}
		}
		
		private function clearSoundChannel():void
		{
			if ( soundChannel )
			{
				soundChannel.stop();
				soundChannel.removeEventListener( Event.SOUND_COMPLETE, onSoundComplete );
				soundChannel = null;
			}
		}
		
		//清除
		public function reset():void
		{
			clearSoundChannel();
			
			if ( sound )
			{
				try
				{
					sound.close();
				}catch ( e:Error )
				{
					
				}
				sound = null;
			}
			
			_isPlaying = false;
			_timestamp = 0;
			_volume = 1;
		}
		
		private function onSoundComplete(e:Event):void 
		{
			soundChannel.removeEventListener( Event.SOUND_COMPLETE, onSoundComplete );
			soundChannel.stop();
			_timestamp = sound.length;
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