package tetequ.live.modules.room.userlist.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 从用户列表中删除一个指定用户的事件
	 */
	public class RemoveUserFromListEvent extends Event 
	{
		public static const REMOVE_USER:String = "remove-user";
		private var _userId:String;
		
		public function RemoveUserFromListEvent( userId:String, type:String = REMOVE_USER, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			_userId = userId;
		}
		
		public function get userId():String 
		{
			return _userId;
		}
		
		override public function clone():Event
		{
			return new RemoveUserFromListEvent(_userId);
		}
		
	}

}