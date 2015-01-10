package tetequ.live.modules.room.chat.group.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class UserEvent extends Event 
	{
		public static const USER_IN:String = "user-in";
		public static const USER_Out:String = "user-out";
		
		public function UserEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			
		}
		
	}

}