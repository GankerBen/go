package tetequ.live.modules.room.chat.input.events 
{
	import flash.events.Event;
	import tetequ.live.modules.room.chat.common.message.ChatMessageVo;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 发送群聊天消息
	 */
	public class SendGroupChatMessageEvent extends Event 
	{
		public static const SEND:String = "send";
		private var _msgVo:ChatMessageVo;
		
		public function SendGroupChatMessageEvent( msgVo:ChatMessageVo, type:String = SEND, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			_msgVo = msgVo;
		}
		
		public function get msgVo():ChatMessageVo 
		{
			return _msgVo;
		}
		
	}

}