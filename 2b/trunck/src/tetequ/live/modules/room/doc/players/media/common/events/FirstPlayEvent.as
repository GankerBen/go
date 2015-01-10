package tetequ.live.modules.room.doc.players.media.common.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class FirstPlayEvent extends Event 
	{
		public static const FIRST:String = "first";
		
		public function FirstPlayEvent(type:String = FIRST, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			
		}
		
	}

}