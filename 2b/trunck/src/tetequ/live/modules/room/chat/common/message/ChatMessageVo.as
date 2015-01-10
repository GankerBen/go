package tetequ.live.modules.room.chat.common.message 
{
	import com.e2et.datalogic.User;
	/**
	 * ...
	 * @author Pandazhong
	 * 一条聊天消息数据
	 */
	public class ChatMessageVo 
	{
		/**
		 * 用户userid
		 */
		private var _userId:String;
		
		/**
		 * 用户名
		 */
		private var _username:String;
		
		/**
		 * 消息内容
		 */
		private var _message:String;
		
		/**
		 * 时间戳
		 */
		private var _timestamp:uint = 0;
		
		/**
		 * 用户级别
		 */
		private var _userLevel:uint;
		
		private var _from:User;
		private var _toUser:User;
		
		public function ChatMessageVo() 
		{
			
		}
		
		public function get userId():String 
		{
			return _userId;
		}
		
		public function set userId(value:String):void 
		{
			_userId = value;
		}
		
		public function get username():String 
		{
			return _username;
		}
		
		public function set username(value:String):void 
		{
			_username = value;
		}
		
		public function get message():String 
		{
			return _message;
		}
		
		public function set message(value:String):void 
		{
			_message = value;
		}
		
		public function get timestamp():uint 
		{
			return _timestamp;
		}
		
		public function set timestamp(value:uint):void 
		{
			_timestamp = value;
		}
		
		public function get userLevel():uint 
		{
			return _userLevel;
		}
		
		public function set userLevel(value:uint):void 
		{
			_userLevel = value;
		}
		
		public function get from():User 
		{
			return _from;
		}
		
		public function set from(value:User):void 
		{
			_from = value;
		}
		
		public function get toUser():User 
		{
			return _toUser;
		}
		
		public function set toUser(value:User):void 
		{
			_toUser = value;
		}
		
	}

}