package tetequ.live.modules.room.common.panel.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 注册面板类事件
	 */
	public class RegisterPanelClassEvent extends Event 
	{
		public static const REGISTER:String = "register";
		
		public function RegisterPanelClassEvent(type:String = REGISTER, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			
		}
		
	}

}