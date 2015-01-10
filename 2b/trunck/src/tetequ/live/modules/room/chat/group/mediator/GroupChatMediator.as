package tetequ.live.modules.room.chat.group.mediator 
{
	import com.e2et.datalogic.User;
	import flash.events.MouseEvent;
	import robotlegs.bender.bundles.mvcs.Mediator;
	import tetequ.live.core.network.NetworkFacade;
	import tetequ.live.modules.room.chat.common.message.ChatMessageItemView;
	import tetequ.live.modules.room.chat.group.events.AddGroupChatMessageEvent;
	import tetequ.live.modules.room.chat.group.events.UserEvent;
	import tetequ.live.modules.room.chat.group.view.GroupChatView;
	import tetequ.live.modules.room.common.panel.PanelID;
	import tetequ.live.modules.room.common.panel.PanelManager;
	import tetequ.live.modules.room.userlist.view.UserListView;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 群聊消息面板
	 */
	public class GroupChatMediator extends Mediator 
	{
		[Inject]
		public var view:GroupChatView;
		
		[Inject]
		public var networkFacade:NetworkFacade;
		
		[Inject]
		public var panelManager:PanelManager;
		public function GroupChatMediator() 
		{
			super();
			
		}
		
		/**
		 * 初始化
		 */
		override public function initialize():void
		{
			super.initialize();
			
			this.addContextListener( AddGroupChatMessageEvent.ADD_MESSAGE, onAddMessage, AddGroupChatMessageEvent );
			this.addContextListener( UserEvent.USER_IN, onUserIn, UserEvent );
			this.addContextListener( UserEvent.USER_Out, onUserOut, UserEvent );
			this.view.btnUser.addEventListener(MouseEvent.CLICK , onClick);
			_num = networkFacade.userList.length;
			//for each(var user:User in networkFacade.userList)
			//{
				//if (isVisitor(user))
				//{
					//_num--;
				//}
			//}
			
			this.view.refreshUserNum(_num);
		}
		
		private function onClick(e:MouseEvent):void 
		{
			switch (e.currentTarget)
			{
				case this.view.btnUser:
					openUserList();
					break;
				default :
					break;
			}
		}
		
		/**
		 * 打开用户列表
		 */
		private function openUserList():void 
		{
			if (UserListView.getInstance().visible)
			{
				UserListView.getInstance().visible = false;
			}else
			{
				UserListView.getInstance().visible = true;
			}
		}
		
		
		
		private var _num:uint;
		
		/**
		 * 人数减1
		 * @param	e
		 */
		private function onUserOut(e:UserEvent):void 
		{
			this.view.refreshUserNum(--_num);
		}
		
		/**
		 * 人数加1
		 * @param	e
		 */
		private function onUserIn(e:UserEvent):void 
		{
			this.view.refreshUserNum(++_num);
		}

		/**
		 * 添加一条群聊天消息
		 * @param	e
		 */
		private function onAddMessage(e:AddGroupChatMessageEvent):void 
		{
			var item:ChatMessageItemView = new ChatMessageItemView( e.messageVo );
			view.addMessage(item);
		}
		
		/**
		 * 清除数据
		 */
		override public function destroy():void
		{
			super.destroy();
			this.removeContextListener( UserEvent.USER_IN, onUserIn, UserEvent );
			this.removeContextListener( UserEvent.USER_Out, onUserOut, UserEvent );
			this.removeContextListener( AddGroupChatMessageEvent.ADD_MESSAGE, onAddMessage, AddGroupChatMessageEvent );
		}
		
	}

}