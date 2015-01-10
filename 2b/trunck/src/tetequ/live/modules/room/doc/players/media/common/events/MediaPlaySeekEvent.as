package tetequ.live.modules.room.doc.players.media.common.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class MediaPlaySeekEvent extends Event 
	{
		public static const SEEK:String = "seek";
		private var _time:Number;
		private var _file:String;
		
		public function MediaPlaySeekEvent(file:String, time:Number, type:String = SEEK, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			_file = file;
			_time = time;
		}
		
		public function get time():Number 
		{
			return _time;
		}
		
		public function get file():String 
		{
			return _file;
		}
		
	}

}