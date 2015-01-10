package tetequ.live.modules.room.chat.input.command 
{
	import flash.events.IEventDispatcher;
	import robotlegs.bender.bundles.mvcs.Command;
	import tetequ.live.core.network.NetworkFacade;
	import tetequ.live.modules.room.chat.common.message.ChatMessageVo;
	import tetequ.live.modules.room.chat.group.events.AddGroupChatMessageEvent;
	import tetequ.live.modules.room.chat.input.events.SendGroupChatMessageEvent;
	import tetequ.live.modules.room.chat.privates.view.PrivateChatManager;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 发送群聊天消息
	 */
	public class SendGroupChatMessageCommand extends Command 
	{
		[Inject]
		public var eventDispatcher:IEventDispatcher;
		
		[Inject]
		public var event:SendGroupChatMessageEvent;
		
		[Inject]
		public var networkFacade:NetworkFacade;
		
		public function SendGroupChatMessageCommand() 
		{
			super();
			
		}
		
		override public function execute():void
		{
			//暂时只是内部发送，测试
			//eventDispatcher.dispatchEvent( new AddGroupChatMessageEvent( event.msgVo ) );//FIXME!
			
			//发送到服务器-FIXME!
			trace( "send chat......" );
			networkFacade.sendChat( event.msgVo.message, event.msgVo.toUser );
			if (event.msgVo.toUser)
			{
				var vo:ChatMessageVo = new ChatMessageVo();
				vo.from = event.msgVo.toUser;
				vo.toUser = event.msgVo.from;
				vo.message = event.msgVo.message;
				vo.timestamp = event.msgVo.timestamp;
				vo.userId = event.msgVo.from.userid;
				vo.userLevel = event.msgVo.from.level;
				vo.username = event.msgVo.from.name;
				PrivateChatManager.getInstance().addMessage(vo);
			}
		}
	}

}