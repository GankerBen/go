package tetequ.live.modules.room.userlist.mediator 
{
	import com.e2et.datalogic.AVStream;
	import com.e2et.datalogic.User;
	import com.e2et.ISession;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import org.flexlite.domUI.components.Alert;
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.domUI.events.CloseEvent;
	import org.flexlite.domUI.events.PopUpEvent;
	import org.flexlite.domUI.events.UIEvent;
	import org.flexlite.domUI.managers.PopUpManager;
	import robotlegs.bender.bundles.mvcs.Mediator;
	import robotlegs.bender.framework.api.ILogger;
	import tetequ.live.core.network.NetworkFacade;
	import tetequ.live.modules.room.avdocument.DeviceSettingManager;
	import tetequ.live.modules.room.chat.privates.view.PrivateChatManager;
	import tetequ.live.modules.room.common.GlobalVars;
	import tetequ.live.modules.room.common.panel.PanelManager;
	//import tetequ.live.modules.room.stream.video.master.event.TokenChangedEvent;
	import tetequ.live.modules.room.userlist.events.AddUserToListEvent;
	import tetequ.live.modules.room.userlist.events.RemoveUserFromListEvent;
	import tetequ.live.modules.room.userlist.events.UserDeviceStatusEvent;
	import tetequ.live.modules.room.userlist.model.UserInfoItemVo;
	import tetequ.live.modules.room.userlist.UserListMsgManager;
	import tetequ.live.modules.room.userlist.view.UserInfoItemView;
	import tetequ.live.modules.room.userlist.view.UserListView;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 用户列表mediator
	 */
	public class UserListMediator extends Mediator 
	{
		[Inject]
		public var view:UserListView;
		
		[Inject]
		public var networkFacade:NetworkFacade;
		
		[Inject]
		public var logger:ILogger;
		
		[Inject]
		public var panelManager:PanelManager;
		
		[Inject]
		public var userListMsgManager:UserListMsgManager;
		
		/**
		 * 构造函数
		 */
		public function UserListMediator() 
		{
			super();
			
		}
		
		/**
		 * 初始化
		 */
		override public function initialize():void
		{
			super.initialize();
			
			logger.debug( "User List Mediator initialize." );
			this.addContextListener( AddUserToListEvent.ADD_USER, onAddUserCalled, AddUserToListEvent );
			this.addContextListener( RemoveUserFromListEvent.REMOVE_USER, onRemoveUserCalled, RemoveUserFromListEvent );
			this.addContextListener( UserDeviceStatusEvent.CAMERA, onUserDeviceStatus, UserDeviceStatusEvent );
			this.addContextListener( UserDeviceStatusEvent.MIKE, onUserDeviceStatus, UserDeviceStatusEvent );
			
			//this.view.vscroller.addEventListener( MouseEvent.MOUSE_OVER, onVScrollOver );
			//this.view.vscroller.addEventListener( MouseEvent.ROLL_OVER, onVScrollOver );
			//this.view.vscroller.addEventListener( MouseEvent.MOUSE_OUT, onVScrollOut );
			//this.view.vscroller.addEventListener( MouseEvent.ROLL_OUT, onVScrollOut );
			this.view.vscroller.alpha = 0;
			this.view.addEventListener(CloseEvent.CLOSE, onClose );

			for each( var user:User in networkFacade.userList )
			{
				if(user.userid==""||user.name=="")
				{
					trace("更新用户信息");
					networkFacade.requestUserUpdate( user, userUpdateCallback );
				}else
				{
					trace("不需要更新！", user.name);
					//if (isVisitor(user))
						//continue;
					onAddUserCalled( new AddUserToListEvent( user ) );
				}
			}
			//把'我'加入用户列表
			if (!view.hasUser(networkFacade.user.userid))
			{
				onAddUserCalled( new AddUserToListEvent( networkFacade.user ) );
			}
			checkUserIn();
			checkUserOut();
		}
		
		private function checkUserOut():void 
		{
			var msgs:Vector.<RemoveUserFromListEvent> = userListMsgManager.userOutList;
			for each( var msg:RemoveUserFromListEvent in msgs )
			{
				trace( "移除用户:", msg.userId );
				onRemoveUserCalled( msg );
			}
			
			msgs.length = 0;
		}
		
		private function checkUserIn():void 
		{
			var msgs:Vector.<AddUserToListEvent> = userListMsgManager.userInList;
			for each( var msg:AddUserToListEvent in msgs )
			{
				trace( "加入用户:", msg.user.userid );
				onAddUserCalled( msg );
			}
			
			msgs.length = 0;
		}
		
		private function onClose(e:CloseEvent):void 
		{
			view.visible = false;
		}
		
		/**
		 * 用户设备状态发生改变时调用
		 * @param	e
		 */
		private function onUserDeviceStatus(e:UserDeviceStatusEvent):void 
		{
			switch( e.type )
			{
				case UserDeviceStatusEvent.CAMERA:
					if( view.getUseItem( e.userId ) )
						view.getUseItem( e.userId ).hasCam = e.has;
					break;
				case UserDeviceStatusEvent.MIKE:
					if( view.getUseItem( e.userId ) )
						view.getUseItem( e.userId ).hasMic = e.has;
					break;
				default:
					break;
			}
		}
		
		/**
		 * 垂直滚动条不可见
		 * @param	e
		 */
		//private function onVScrollOut(e:MouseEvent):void 
		//{
			//this.view.vscroller.alpha = 0;
		//}
		//
		///**
		 //* 垂直滚动条可见
		 //* @param	e
		 //*/
		//private function onVScrollOver(e:MouseEvent):void 
		//{
			//this.view.vscroller.alpha = 1;
		//}
		
		
		/**
		 * 更新用户信息回调
		 * @param	$
		 * @param	user
		 */
		private function userUpdateCallback( $:ISession, user:User ):void
		{
			//if (isVisitor(user))
				//return;
			onAddUserCalled( new AddUserToListEvent( user ) );
		}
		
		/**
		 * 从用户列表中删除一个指定用户
		 * @param	e
		 */
		private function onRemoveUserCalled(e:RemoveUserFromListEvent):void 
		{
			if ( view.hasUser( e.userId ) )
			{
				var itemView:UserInfoItemView = view.getUseItem( e.userId );
				itemView.removeEventListener( MouseEvent.ROLL_OUT, onItemMouseOut );
				itemView.removeEventListener( MouseEvent.MOUSE_OUT, onItemMouseOut );
				itemView.removeEventListener( MouseEvent.ROLL_OVER, onItemMouseOver );
				itemView.removeEventListener( MouseEvent.MOUSE_OVER, onItemMouseOver );
				itemView.btnInvite.removeEventListener( MouseEvent.CLICK, onItemClick );
				itemView.levelIcon.removeEventListener( MouseEvent.CLICK, openPrivateChat );
				view.removeUserItem( e.userId );
			}
		}
		
		/**
		 * 被选中
		 * @param	e
		 */
		private function onItemMouseOver(e:MouseEvent):void 
		{
			UserInfoItemView(e.currentTarget).selected = true;
		}
		
		/**
		 * 未被选中
		 * @param	e
		 */
		private function onItemMouseOut(e:MouseEvent):void 
		{
			UserInfoItemView(e.currentTarget).selected = false;
		}
		
		/**
		 * 添加一个用户到用户列表
		 * @param	e
		 */
		private function onAddUserCalled(e:AddUserToListEvent):void 
		{
			if ( !view.hasUser( e.user.userid ) )
			{
				var itemView:UserInfoItemView = new UserInfoItemView( e.user );
				view.addUserItem( itemView );
				itemView.addEventListener( MouseEvent.ROLL_OUT, onItemMouseOut );
				itemView.addEventListener( MouseEvent.MOUSE_OUT, onItemMouseOut );
				itemView.addEventListener( MouseEvent.ROLL_OVER, onItemMouseOver );
				itemView.addEventListener( MouseEvent.MOUSE_OVER, onItemMouseOver );
				itemView.btnInvite.addEventListener( MouseEvent.CLICK, onItemClick );
				itemView.levelIcon.addEventListener( MouseEvent.CLICK, openPrivateChat );
				itemView.levelIcon.userData = e.user;
				logger.debug( "添加一个用户." );
			}else {
				logger.debug( "用户已经存在 userid" + e.user.userid );
			}
		}
		
		private function openPrivateChat(e:MouseEvent):void 
		{
			if(networkFacade.user.userid!=UIAsset(e.currentTarget).userData.userid)
				PrivateChatManager.getInstance().openChat(UIAsset(e.currentTarget).userData);
		}
		
		//临时用-2014-6-26
		private function onItemClick(e:MouseEvent):void 
		{
			var user:User = UserInfoItemView(e.currentTarget.parent).vo;
			
		
			if (GlobalVars.language == GlobalVars.LANG_ENGLISH)
			{
				//英文
					Alert.show( "Are you sure open " + user.name + " 's devices?", "", onClose, "确定", "取消"  );
			}else if(GlobalVars.language == GlobalVars.LANG_CHINESE)
			{
				//中文
					Alert.show( "您想要打开 " + user.name + " 的视频吗?", "", onClose, "确定", "取消"  );
				
			}else
			{
				throw new Error('无法识别的语言！');
			}
			
			trace(networkFacade.avListLength);
			function onClose( e:CloseEvent ):void
			{
				switch( CloseEvent(e).detail )
				{
					case Alert.FIRST_BUTTON:
						if( networkFacade.hasToken )
						{
							if ( networkFacade.avListLength >= GlobalVars.max_av_num )
							{
								
								if (GlobalVars.language == GlobalVars.LANG_ENGLISH)
								{
									//英文
										Alert.show( "Devices open failed, because the room has already max count of videos now!" );
								}else if(GlobalVars.language == GlobalVars.LANG_CHINESE)
								{
									//中文
									Alert.show( "打开该用户的视频失败！因为房间的视频数量已达最大值 "+GlobalVars.max_av_num);
									
								}else
								{
									throw new Error('无法识别的语言！');
								}
								
								return;
							}
							
							//trace( "视频数量", networkFacade.avListLength );
							
							if ( user.userid == networkFacade.userId )
							{
								DeviceSettingManager.getInstance().startup();
								DeviceSettingManager.getInstance().publish();
								return;
							}
							
							var num:int = 0;
							if( user.hasStream )
							{
								for each( var avstm:AVStream in user.streams )
								{
									if ( avstm.user.userid == user.userid )
									{
										num++;
									}
								}
								
								if (num == 2)
								{
									if (GlobalVars.language == GlobalVars.LANG_ENGLISH)
									{
										//英文
										Alert.show( "The user has two video now！not allowed to open devices any more！" );
									}else if(GlobalVars.language == GlobalVars.LANG_CHINESE)
									{
										//中文
										Alert.show( "该用户已经使用了两路视频，不能打开更多的视频了！" );
										
									}else
									{
										throw new Error('无法识别的语言！');
									}
									return;
								}
							}
							
							//networkFacade.addAVItem( user, { }, networkFacade.user );
							networkFacade.sendRPC( user, 'invitedPublish' );
						}else
						{
							
							if (GlobalVars.language == GlobalVars.LANG_ENGLISH)
							{
								//英文
								Alert.show( "Sorry, you don't have token to open the user's devices!" );
							}else if(GlobalVars.language == GlobalVars.LANG_CHINESE)
							{
								//中文
								Alert.show( "对不起，您没有权限打开该用户的视频!" );
								
							}else
							{
								throw new Error('无法识别的语言！');
							}
						}
						break;
					case Alert.SECOND_BUTTON:case Alert.CLOSE_BUTTON:
						break;
					default:
						break;
				}
			}
		}
		
		/**
		 * 销毁数据
		 */
		override public function destroy():void
		{
			super.destroy();
			
			//for each( var item:UserInfoItemView in view.itemsHash.getValues() )
			//{
				//if ( item )
				//{
					//item.removeEventListener( MouseEvent.ROLL_OUT, onItemMouseOut );
					//item.removeEventListener( MouseEvent.MOUSE_OUT, onItemMouseOut );
					//item.removeEventListener( MouseEvent.ROLL_OVER, onItemMouseOver );
					//item.removeEventListener( MouseEvent.MOUSE_OVER, onItemMouseOver );
					//item.removeEventListener( MouseEvent.CLICK, onItemClick );
				//}
			//}
			
			this.removeContextListener( AddUserToListEvent.ADD_USER, onAddUserCalled, AddUserToListEvent );
			this.removeContextListener( RemoveUserFromListEvent.REMOVE_USER, onRemoveUserCalled, RemoveUserFromListEvent );
			//this.view.vscroller.removeEventListener( MouseEvent.MOUSE_OVER, onVScrollOver );
			//this.view.vscroller.removeEventListener( MouseEvent.ROLL_OVER, onVScrollOver );
			//this.view.vscroller.removeEventListener( MouseEvent.MOUSE_OUT, onVScrollOut );
			//this.view.vscroller.removeEventListener( MouseEvent.ROLL_OUT, onVScrollOut );
			this.view.removeEventListener(CloseEvent.CLOSE, onClose );

			this.removeContextListener( UserDeviceStatusEvent.CAMERA, onUserDeviceStatus, UserDeviceStatusEvent );
			this.removeContextListener( UserDeviceStatusEvent.MIKE, onUserDeviceStatus, UserDeviceStatusEvent );
		}
		
	}

}