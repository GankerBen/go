package tetequ.live.modules.room.common.layouts 
{
	import org.flexlite.domUI.core.IVisualElement;
	import org.flexlite.domUI.core.UIComponent;
	import tetequ.live.modules.room.common.layouts.style.common.IScheme;
	import tetequ.live.modules.room.common.layouts.style.master.MasterSchemeB;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 主讲界面布局管理器
	 */
	public class MasterLayoutDirector extends LayoutDirector
	{
		/**
		 * 构造函数
		 */
		public function MasterLayoutDirector() 
		{
			super();
		}
		
		override protected function init():void
		{
			super.init();
			
			_scheme = new MasterSchemeB( 
			this.elementInstances );
			addElement( IVisualElement( _scheme ) );
		}
	}
}