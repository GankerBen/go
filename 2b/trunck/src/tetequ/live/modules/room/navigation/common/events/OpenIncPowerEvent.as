package tetequ.live.modules.room.navigation.common.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 提升权限
	 */
	public class OpenIncPowerEvent extends Event 
	{
		public static const INC_POWER:String = "inc-power";
		
		public function OpenIncPowerEvent(type:String = INC_POWER, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			
		}
		
	}

}