package tetequ.live.modules.room.userlist.events 
{
	import com.e2et.datalogic.User;
	import flash.events.Event;
	import tetequ.live.modules.room.userlist.model.UserInfoItemVo;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 向用户列表中加入一条栏目的事件
	 */
	public class AddUserToListEvent extends Event 
	{
		public static const ADD_USER:String = "add-user";
		private var _user:User;
		
		public function AddUserToListEvent( userInfo:User, type:String = ADD_USER, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			_user = userInfo;
		}
		
		/**
		 * 获取用户信息
		 */
		public function get user():User 
		{
			return _user;
		}
		
		override public function clone():Event
		{
			return new AddUserToListEvent(_user);
		}
		
	}

}