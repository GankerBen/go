package tetequ.live.modules.room.navigation.common.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class OpenContactUSEvent extends Event 
	{
		public static const CONTACT_US:String = "contact-us";
		public function OpenContactUSEvent(type:String = CONTACT_US, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			
		}
		
	}

}