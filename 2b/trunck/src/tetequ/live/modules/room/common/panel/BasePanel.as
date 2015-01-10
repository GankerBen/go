package tetequ.live.modules.room.common.panel 
{
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.TitleWindow;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 软件UI面板基类
	 */
	public class BasePanel extends TitleWindow implements IPanel
	{
		/**
		 * 构造函数
		 */
		public function BasePanel() 
		{
			super();
			initComponents();
		}
		
		/**
		 * 初始化组件
		 */
		protected function initComponents():void 
		{
			this.title = "面板基类";
			this.width = 820;
			this.height = 600;
		}
		
		/**
		 * 获取面板ID
		 */
		public function get panelId():int
		{
			throw new Error( "抽象方法不能直接调用!" );
		}
		
	}

}