package tetequ.live.modules.room.userlist.model 
{
	/**
	 * ...
	 * @author Pandazhong
	 * 用户列表中的一条用户数据
	 */
	public class UserInfoItemVo 
	{
		/**
		 * 用户id
		 */
		private var _userId:String;
		
		/**
		 * 用户名
		 */
		private var _username:String;
		
		/**
		 * 是否有麦克风
		 */
		private var _hasMike:Boolean;
		
		/**
		 *	是否有摄像头 
		 */
		private var _hasCamera:Boolean;
		
		/**
		 * 构造函数
		 */
		public function UserInfoItemVo() 
		{
			
		}
		
		public function get username():String 
		{
			return _username;
		}
		
		public function set username(value:String):void 
		{
			_username = value;
		}
		
		public function get hasMike():Boolean 
		{
			return _hasMike;
		}
		
		public function set hasMike(value:Boolean):void 
		{
			_hasMike = value;
		}
		
		public function get hasCamera():Boolean 
		{
			return _hasCamera;
		}
		
		public function set hasCamera(value:Boolean):void 
		{
			_hasCamera = value;
		}
		
		public function get userId():String 
		{
			return _userId;
		}
		
		public function set userId(value:String):void 
		{
			_userId = value;
		}
		
	}

}