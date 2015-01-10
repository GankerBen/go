package tetequ.live.modules.room.userlist.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 请求用户列表信息
	 */
	public class RequestUserListInfoEvent extends Event 
	{
		
		public function RequestUserListInfoEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			
		}
		
	}

}