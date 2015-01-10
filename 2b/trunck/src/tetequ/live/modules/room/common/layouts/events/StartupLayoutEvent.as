package tetequ.live.modules.room.common.layouts.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class StartupLayoutEvent extends Event 
	{
		public static const MASTER:String = "master";
		public static const STUDENT:String = "student";
		
		public function StartupLayoutEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			
		}
		
	}

}