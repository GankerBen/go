package tetequ.live.modules.login.model 
{
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class LoginVoCache 
	{
		private var _cache:LoginVo;
		
		public function LoginVoCache()
		{
			
		}
		
		public function get cache():LoginVo 
		{
			return _cache;
		}
		
		public function set cache(value:LoginVo):void 
		{
			_cache = value;
		}
	}

}