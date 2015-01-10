package tetequ.live.modules.loading.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author pandazhong
	 * 显示loading界面事件
	 */
	public class ShowLoadingEvent extends Event 
	{
		public static const SHOW_LOADING:String = "show-loading";
		
		public function ShowLoadingEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			
		}
		
	}

}