package tetequ.live.modules.room.doc.players.media.video.common 
{
	import flash.display.Sprite;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.components.UIAsset;
	import tetequ.live.modules.room.doc.players.media.common.SimpleMediaPlayer;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 视频播放器基类
	 */
	public class VideoPlayer extends SimpleMediaPlayer 
	{
		protected var totalTime:int;
		
		public function VideoPlayer() 
		{
			super();	
		}
		
		public function setTotalTime( value:int ):void
		{
			//if ( value == totalTime ) return;
			labelTotalTime.text = convertTimeToString( value );
			_slider.maximum = value;
		}
		
		/**
		 * 毫秒转换为时分秒字符串
		 * @param	ms
		 * @return
		 */
		protected static function convertTimeToString( ms:int ):String
		{
			var h:int = int(ms / (1000 * 3600));
			var m:int = int((ms - h * 1000 * 3600) / (60 * 1000) );
			var s:int = int( (ms - m * 60 * 1000 - h * 3600 * 1000 ) / 1000 );
			return convertUnit( h ) + ":" + convertUnit( m ) + ":" + convertUnit( s );
		}
		
		protected static function convertUnit( u:int ):String
		{
			return u >= 10 ? u.toString() : "0" + u.toString();
		}
		
		public function setCurrentTime( value:int ):void
		{
			labelCurTime.text = convertTimeToString( value );
		}
	}

}