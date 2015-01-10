package tetequ.live.modules.room.common.layouts.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 布局管理器注册
	 */
	public class LayoutDirectorRegisterEvent extends Event 
	{
		public static const REGISTER:String = "register";
		
		public function LayoutDirectorRegisterEvent(type:String = REGISTER, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			
		}
		
	}

}