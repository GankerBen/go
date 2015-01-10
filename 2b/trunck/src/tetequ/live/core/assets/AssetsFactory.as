package tetequ.live.core.assets 
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import tetequ.live.modules.room.common.GlobalVars;
	/**
	 * ...
	 * @author Pandazhong
	 * 负责创建资源
	 */
	public class AssetsFactory 
	{
		private var _source:Loader;
		
		public function AssetsFactory(s:SingletonEnforcer) 
		{
			if (!s)
				throw new Error("单例不允许new！");
		}
		
		private static var instance:AssetsFactory;
		public static function getInstance():AssetsFactory
		{
			return instance ||= new AssetsFactory(new SingletonEnforcer());
		}
		
		public function set source(value:Loader):void 
		{
			_source = value;
		}
		
		/**
		 * 根据链接名获取类引用
		 * @param	className
		 * @return
		 */
		public function getAsset(className:String):Class
		{
			if (_source.contentLoaderInfo.applicationDomain.hasDefinition(GlobalVars.language + className))
			{
				//语言特有
				return _source.contentLoaderInfo.applicationDomain.getDefinition(GlobalVars.language+className) as Class;
			}else
			{
				//公共素材
				return _source.contentLoaderInfo.applicationDomain.getDefinition(className) as Class;
			}
		}
	}
}

class SingletonEnforcer{}