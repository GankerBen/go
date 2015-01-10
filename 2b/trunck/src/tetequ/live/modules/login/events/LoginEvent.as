package tetequ.live.modules.login.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class LoginEvent extends Event 
	{
		public static const LOGIN:String = "login";
		private var _username:String;
		
		public function LoginEvent( username:String, type:String = LOGIN, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			_username = username;
		}
		
		public function get username():String 
		{
			return _username;
		}
		
	}

}