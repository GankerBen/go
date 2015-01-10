package tetequ.live.modules.room.doc.players.media.common.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Pandazhong
	 * media音量改变
	 */
	public class MediaPlayChangeVolumeEvent extends Event 
	{
		public static const CHANGE_VOLUME:String = "change-volume";
		private var _volume:Number;
		private var _file:String;
		
		public function MediaPlayChangeVolumeEvent( file:String, volume:Number, type:String = CHANGE_VOLUME, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			_volume = volume;
			_file = file;
		}
		
		public function get volume():Number 
		{
			return _volume;
		}
		
		public function get file():String 
		{
			return _file;
		}
		
	}

}