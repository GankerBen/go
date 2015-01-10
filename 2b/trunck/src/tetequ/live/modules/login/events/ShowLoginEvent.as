package tetequ.live.modules.login.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class ShowLoginEvent extends Event 
	{
		public static const SHOW_LOGIN:String = "show-login";
		public function ShowLoginEvent(type:String = SHOW_LOGIN, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			
		}
		
	}

}