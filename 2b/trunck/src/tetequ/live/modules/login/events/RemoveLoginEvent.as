package tetequ.live.modules.login.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class RemoveLoginEvent extends Event 
	{
		public static const REMOVE_LOGIN:String = "remove-login";
		
		public function RemoveLoginEvent(type:String = REMOVE_LOGIN, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			
		}
		
	}

}