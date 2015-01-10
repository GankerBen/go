package tetequ.live.modules.room.common.keyboard.event 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class KeyboardManagerEvent extends Event 
	{
		public static const INIT:String = "init";
		public function KeyboardManagerEvent(type:String = INIT, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			
		}
		
	}

}