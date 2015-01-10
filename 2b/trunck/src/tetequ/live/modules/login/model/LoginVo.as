package tetequ.live.modules.login.model 
{
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class LoginVo 
	{
		private var _username:String;
		private var _userid:String;
		private var _userlevel:uint;
		private var _usericonurl:String;
		private var _roomid:String;
		private var _roomorgname:String;
		private var _videoId:String;

		public function LoginVo() 
		{
			
		}
		
		public function get roomorgname():String 
		{
			return _roomorgname;
		}
		
		public function set roomorgname(value:String):void 
		{
			_roomorgname = value;
		}
		
		public function get roomid():String 
		{
			return _roomid;
		}
		
		public function set roomid(value:String):void 
		{
			_roomid = value;
		}
		
		public function get usericonurl():String 
		{
			return _usericonurl;
		}
		
		public function set usericonurl(value:String):void 
		{
			_usericonurl = value;
		}
		
		public function get userlevel():uint 
		{
			return _userlevel;
		}
		
		public function set userlevel(value:uint):void 
		{
			_userlevel = value;
		}
		
		public function get userid():String 
		{
			return _userid;
		}
		
		public function set userid(value:String):void 
		{
			_userid = value;
		}
		
		public function get username():String 
		{
			return _username;
		}
		
		public function set username(value:String):void 
		{
			_username = value;
		}
		
		public function get videoId():String 
		{
			return _videoId;
		}
		
		public function set videoId(value:String):void 
		{
			_videoId = value;
		}
		
	}

}