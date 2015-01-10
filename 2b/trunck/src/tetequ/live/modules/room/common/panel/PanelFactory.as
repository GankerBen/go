package tetequ.live.modules.room.common.panel 
{
	import tetequ.live.utils.HashMap;
	/**
	 * ...
	 * @author Pandazhong
	 * 负责创建面板实例
	 */
	public class PanelFactory 
	{
		private var _panelClasses:HashMap;
		
		/**
		 * 构造函数
		 */
		public function PanelFactory() 
		{
			_panelClasses = new HashMap();
		}
		
		/**
		 * 注册面板类，用于后续的实例化
		 * @param	panelId
		 * @param	panelClass
		 */
		public function registerPanelClass( panelId:int, panelClass:Class ):void
		{
			if ( !_panelClasses.containsKey( panelId ) )
			{
				_panelClasses.put( panelId, panelClass );
			}
		}
		
		/**
		 * 根据id获取面板
		 * 注意，PanelFactory不会缓存任何面板的引用
		 * @param	panelId
		 * @return
		 */
		public function getPanelInstance( panelId:int ):IPanel
		{
			if ( !_panelClasses.containsKey( panelId ) )
			{
				throw new Error( "ID为 " + panelId + " 的面板类尚未注册，无法实例化!" );
			}
			return IPanel(new (_panelClasses.getValue( panelId )));
		}
		
	}

}