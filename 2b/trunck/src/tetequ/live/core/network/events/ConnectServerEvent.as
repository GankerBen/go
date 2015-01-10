package tetequ.live.core.network.events 
{
	import flash.events.Event;
	import tetequ.live.modules.login.model.LoginVo;
	
	/**
	 * ...
	 * @author pandazhong
	 * 通知连接服务器
	 */
	public class ConnectServerEvent extends Event 
	{
		public static const CONNECT_SERVER:String = "connect-server";
		private var _loginVo:LoginVo;
		
		public function ConnectServerEvent( loginVo:LoginVo, type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			_loginVo = loginVo;
		}
		
		public function get loginVo():LoginVo 
		{
			return _loginVo;
		}
		
	}

}