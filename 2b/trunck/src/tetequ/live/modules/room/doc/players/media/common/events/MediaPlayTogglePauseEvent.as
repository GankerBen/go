package tetequ.live.modules.room.doc.players.media.common.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class MediaPlayTogglePauseEvent extends Event 
	{
		public static const TOGGLE_PAUSE:String = "toggle-pause";
		private var _paused:Boolean;
		private var _file:String;
		
		public function MediaPlayTogglePauseEvent( file:String, paused:Boolean, type:String = TOGGLE_PAUSE, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			_paused = paused;
			_file = file;
		}
		
		public function get paused():Boolean 
		{
			return _paused;
		}
		
		public function get file():String 
		{
			return _file;
		}
		
	}

}