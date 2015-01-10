package framework.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author pandazhong
	 * 与框架相关事件
	 */
	public class FrameworkEvent extends Event 
	{
		public static const FRAMEWORK_DONE:String = "framework-done";							//框架启动完毕
		public static const APPLICATION_STARTUP:String = "application-startup";		//初始化应用程序
		
		public function FrameworkEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
		}
		
	}

}