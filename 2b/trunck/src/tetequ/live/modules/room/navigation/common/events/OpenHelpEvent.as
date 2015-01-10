package tetequ.live.modules.room.navigation.common.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 打开帮助面板事件
	 */
	public class OpenHelpEvent extends Event 
	{
		public static const HELP:String = "help";
		public function OpenHelpEvent(type:String = HELP, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			
		}
		
	}

}