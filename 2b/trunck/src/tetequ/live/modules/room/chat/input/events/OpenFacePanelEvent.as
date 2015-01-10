package tetequ.live.modules.room.chat.input.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 打开聊天表情面板事件
	 */
	public class OpenFacePanelEvent extends Event 
	{
		public static const OPEN:String = "open";
		
		public function OpenFacePanelEvent(type:String = OPEN, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			
		}
		
	}

}