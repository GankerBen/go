package tetequ.live.core.network.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class MapMetaActionToHandlerEvent extends Event 
	{
		public static const MAP:String = "map";
		
		public function MapMetaActionToHandlerEvent(type:String = MAP, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			
		}
		
	}

}