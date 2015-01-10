package tetequ.live.modules.room.doc.tools.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 取消选择任何画笔工具
	 */
	public class DummyToolEvent extends Event 
	{
		public static const DUMMY_TOOL:String = "dummy-tool";
		public function DummyToolEvent(type:String = DUMMY_TOOL, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			
		}
		
	}

}