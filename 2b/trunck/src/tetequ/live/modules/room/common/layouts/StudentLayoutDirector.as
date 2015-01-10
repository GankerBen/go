package tetequ.live.modules.room.common.layouts 
{
	import flash.events.Event;
	import org.flexlite.domUI.core.IVisualElement;
	import org.flexlite.domUI.core.UIComponent;
	import tetequ.live.modules.room.common.layouts.style.common.IScheme;
	import tetequ.live.modules.room.common.layouts.style.master.MasterSchemeB;
	import tetequ.live.modules.room.common.layouts.style.student.StudentSchemeB;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 学生界面布局管理器
	 */
	public class StudentLayoutDirector extends LayoutDirector
	{
		/**
		 * 构造函数
		 */
		public function StudentLayoutDirector() 
		{
			super();
			
		}
		
		/**
		 * 初始化
		 */
		override protected function init():void
		{
			super.init();
			
			_scheme = new StudentSchemeB( 
			this.elementInstances );
			addElement( IVisualElement( _scheme  ) );
		}
	}
}