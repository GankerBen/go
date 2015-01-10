package tetequ.live.modules.room.chat.privates.view 
{
	import com.e2et.datalogic.User;
	import org.flexlite.domUI.components.Group;
	import tetequ.live.modules.room.chat.common.message.ChatMessageItemView;
	import tetequ.live.modules.room.chat.common.message.ChatMessageVo;
	import tetequ.live.utils.HashMap;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class PrivateChatManager extends Group 
	{
		private var _chatWindows:HashMap;
		private var _msgPanels:HashMap;
		
		public function PrivateChatManager(single:SingletonEnforcer) 
		{
			super();
			if (!single)
				throw new Error('please call getInstance!');
			init();
		}
		
		private function init():void 
		{
			_chatWindows = new HashMap();
			_msgPanels = new HashMap();
		}
		
		private static var instance:PrivateChatManager;
		public static function getInstance():PrivateChatManager
		{
			return instance = instance || new PrivateChatManager(new SingletonEnforcer());
		}
		
		public function openChat(toUser:User):void
		{
			var win:PrivateChatView;
			var msgPanel:PrivateMessagePanel;

			if (_chatWindows.containsKey(toUser.userid))
			{
				win = _chatWindows.getValue(toUser.userid);
			}else
			{
				win = new PrivateChatView(toUser, msgPanel = new PrivateMessagePanel(toUser));
				_chatWindows.put(toUser.userid, win);
				_msgPanels.put(toUser.userid, msgPanel);
			}
			
			addElement(win);
		}
		
		public function addMessage(msgVO:ChatMessageVo):void
		{
			var msgPanel:PrivateMessagePanel;
			openChat(msgVO.from);
			msgPanel = getMessagePanel(msgVO.from.userid);
			msgPanel.addMessage(new ChatMessageItemView(msgVO));
		}
		
		public function getMessagePanel(userid:String):PrivateMessagePanel
		{
			return _msgPanels.getValue(userid);
		}
		
		public function delMessagePanel(userid:String):void
		{
			var win:PrivateChatView = _chatWindows.getValue(userid);
			if(win)
			{
				_chatWindows.remove(userid);
				_msgPanels.remove(userid);
				if (containsElement(win))
					removeElement(win);
			}else throw new Error('想要删除的私聊窗口不存在!'+userid);
		}
		
	}

}

class SingletonEnforcer
{
	
}