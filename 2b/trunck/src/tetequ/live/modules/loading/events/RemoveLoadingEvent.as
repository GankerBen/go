package tetequ.live.modules.loading.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 移除loading界面
	 */
	public class RemoveLoadingEvent extends Event 
	{
		public static const REMOVE_LOADING:String = "remove-loading";
		
		public function RemoveLoadingEvent(type:String = REMOVE_LOADING, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			
		}
		
	}

}