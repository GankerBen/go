package tetequ.live.modules.room.doc.players.media.common 
{
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class MediaStatusCache 
	{
		private var _paused:Boolean;
		private var _time:Number = 0;
		private var _volume:Number = 1;
		
		public function MediaStatusCache() 
		{
			
		}
		
		public function get paused():Boolean 
		{
			return _paused;
		}
		
		public function set paused(value:Boolean):void 
		{
			_paused = value;
		}
		
		public function get time():Number 
		{
			return _time;
		}
		
		public function set time(value:Number):void 
		{
			_time = value;
		}
		
		public function get volume():Number 
		{
			return _volume;
		}
		
		public function set volume(value:Number):void 
		{
			_volume = value;
		}
		
	}

}