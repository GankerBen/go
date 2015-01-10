package framework.view 
{
	import org.flexlite.domUI.managers.SystemManager;
	import tetequ.live.modules.room.common.GlobalVars;
	
	/**
	 * ...
	 * @author pandazhong
	 * 桥接Flexlite中的UI与flash的原生显示列表
	 */
	public class UIRoot extends SystemManager 
	{
		
		public function UIRoot() 
		{
			super();
			this.percentWidth = 100;
			this.percentHeight = 100;
			GlobalVars.uiroot = this;
		}
		
	}

}