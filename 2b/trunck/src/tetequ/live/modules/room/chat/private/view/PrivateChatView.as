package tetequ.live.modules.room.chat.private.view 
{
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Rect;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 私聊界面UI
	 */
	public class PrivateChatView extends Group 
	{
		public function PrivateChatView(single:SingletonEnforcer) 
		{
			super();
			if (!single)
				throw new Error('please call getInstance');
		}
		
		private static var instance:PrivateChatView;
		public static function getInstance():PrivateChatView
		{
			return instance = instance || new PrivateChatView(new SingletonEnforcer());
		}
		
		private var _bg:Rect;
		//private var _
		
	}

}

class SingletonEnforcer
{
	
}