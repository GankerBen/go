package tetequ.live.modules.room.common.layouts.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 注册布局元素
	 */
	public class LayoutElementsInstallEvent extends Event 
	{
		/**
		 * 主讲界面布局元素注册
		 */
		public static const MASTER:String = "master";
		
		/**
		 * 学生界面布局元素注册
		 */
		public static const STUDENT:String = "student";
		
		/**
		 * 构造函数
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 */
		public function LayoutElementsInstallEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			
		}
		
	}

}