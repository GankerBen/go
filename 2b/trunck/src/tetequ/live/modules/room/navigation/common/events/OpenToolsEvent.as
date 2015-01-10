package tetequ.live.modules.room.navigation.common.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 打开工具面板事件
	 */
	public class OpenToolsEvent extends Event 
	{
		public static const TOOLS:String = "tools";
		public function OpenToolsEvent(type:String = TOOLS, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			
		}
		
	}

}