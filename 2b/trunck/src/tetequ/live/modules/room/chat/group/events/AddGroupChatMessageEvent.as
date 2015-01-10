package tetequ.live.modules.room.chat.group.events 
{
	import flash.events.Event;
	import tetequ.live.modules.room.chat.common.message.ChatMessageVo;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 添加一条群聊天消息
	 */
	public class AddGroupChatMessageEvent extends Event 
	{
		public static const ADD_MESSAGE:String = "add-message";
		private var _messageVo:ChatMessageVo;
		
		public function AddGroupChatMessageEvent(msgVo:ChatMessageVo, type:String = ADD_MESSAGE, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			_messageVo = msgVo;
		}
		
		public function get messageVo():ChatMessageVo 
		{
			return _messageVo;
		}
		
	}

}