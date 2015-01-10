package tetequ.live.modules.room.userlist 
{
	import com.e2et.datalogic.User;
	import flash.events.IEventDispatcher;
	import tetequ.live.modules.room.common.panel.PanelID;
	import tetequ.live.modules.room.common.panel.PanelManager;
	import tetequ.live.modules.room.userlist.events.AddUserToListEvent;
	import tetequ.live.modules.room.userlist.events.RemoveUserFromListEvent;
	/**
	 * ...
	 * @author Pandazhong
	 * 负责转发用户登陆、登出的消息
	 * 具体是：
	 * 当用户列表开着时，UserListMediator可以直接接收
	 * 用户登陆、登出等消息，而当用户列表关闭后，需要
	 * 先把这些消息缓存起来，待列表打开后再做处理。
	 */
	public class UserListMsgManager 
	{
		[Inject]
		public var panelManager:PanelManager;
		
		[Inject]
		public var eventDispatcher:IEventDispatcher;
		
		public var userOutList:Vector.<RemoveUserFromListEvent>;
		public var userInList:Vector.<AddUserToListEvent>;
		
		public function UserListMsgManager() 
		{
			userOutList = new Vector.<RemoveUserFromListEvent>;
			userInList = new Vector.<AddUserToListEvent>;
		}
		
		public function addMessageOfUserIn( msg:AddUserToListEvent ):void
		{
			if ( panelManager.isOpened( PanelID.USER_LIST ) )
			{
				eventDispatcher.dispatchEvent(msg.clone());
			}else
			{
				userInList.push(msg.clone());
			}
		}
		
		public function addMessageOfUserOut( msg:RemoveUserFromListEvent ):void
		{
			if ( panelManager.isOpened( PanelID.USER_LIST ) )
			{
				eventDispatcher.dispatchEvent(msg.clone());
			}else
			{
				userOutList.push(msg.clone());
			}
		}
		
	}

}