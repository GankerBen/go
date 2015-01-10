package tetequ.live.core.assets.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author pandazhong
	 * 资源组加载完毕触发的事件
	 */
	public class GroupCompleteEvent extends Event 
	{
		public static const GROUP_COMPLETE:String = "group-complete";
		private var _groupName:String;
		
		public function GroupCompleteEvent(type:String, groupName:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			_groupName = groupName;
		}
		
		public function get groupName():String 
		{
			return _groupName;
		}
		
	}

}