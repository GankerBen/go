package tetequ.live.core.network 
{
	import com.e2et.datalogic.AVStream;
	import com.e2et.datalogic.User;
	import com.e2et.net.media.video.IPreview;
	import flash.events.IEventDispatcher;
	import org.flexlite.domUI.components.Alert;
	import org.flexlite.domUI.events.CloseEvent;
	import org.flexlite.domUI.managers.PopUpManager;
	import tetequ.live.modules.room.avdocument.DeviceSettingManager;
	import tetequ.live.modules.room.cm.sanhao.CM_ClassRunningView;
	import tetequ.live.modules.room.cm.sanhao.CM_FinishClassConfirmView;
	import tetequ.live.modules.room.cm.sanhao.CM_SANHAO_WebServer;
	import tetequ.live.modules.room.common.GlobalVars;
	import tetequ.live.utils.HashMap;
	/**
	 * ...
	 * @author Pandazhong
	 * RPC处理器
	 */
	public class RPCClientImpl 
	{
		private var _network:NetworkFacade;
		private var _eventDispatcher:IEventDispatcher;
		private var _mediaPubHandler:MediaPubHandler;
		
		public function RPCClientImpl() 
		{
			
		}
		
		public function setNetwork( facade:NetworkFacade ):void
		{
			_network = facade;
		}
		
		public function setEventDispatcher( ed:IEventDispatcher ):void
		{
			_eventDispatcher = ed;
		}
		
		public function setMediaPubHandler( handler:MediaPubHandler ):void
		{
			_mediaPubHandler = handler;
		}
		
		/**
		 * 用户请求发言被拒绝！
		 * @param	from
		 * @param	to
		 * @param	args
		 */
		public function refuseAVReq( from:User, to:User, args:Array ):void
		{
			if( _network.user.userid == to.userid )
			{
				
				
				if (GlobalVars.language == GlobalVars.LANG_ENGLISH)
				{
					//英文
					Alert.show( "Unfortunately, your speech application is " + from.name + " Rejected！" );
				}else if(GlobalVars.language == GlobalVars.LANG_CHINESE)
				{
					//中文
					Alert.show( "很遗憾，您的发言申请被 " + from.name + " 拒绝了！" );
					
				}else
				{
					throw new Error('无法识别的语言！');
				}
			}
		}
		
		/**
		 * 被邀请发言
		 * @param	from
		 * @param	to
		 * @param	args
		 */
		public function invitedPublish( from:User, to:User, args:Array ):void
		{
			if ( _network.user.userid == to.userid )
			{
				DeviceSettingManager.getInstance().startup();
				DeviceSettingManager.getInstance().publish(true);
			}
		}
		
		/**
		 * 远程关闭发布端音视频
		 * @param	from
		 * @param	to
		 * @param	args
		 */
		public function remoteCloseAVStream( from:User, to:User, args:Array ):void
		{
			if ( _network.user.userid == to.userid )
			{
				if ( to.hasStream )
				{
					for each( var avstm:AVStream in to.streams )
					{
						if ( avstm.avid == args[0] )
						{
							//_eventDispatcher.dispatchEvent( new AVPreviewEvent( IPreview(avstm.pc.avstm.videoCap), avstm, AVPreviewEvent.STOP ) );
							_network.closeAVStream(avstm.avid);
							return;
						}
					}
				}
			}
		}
		
		/**
		 * 一组向'我'借令牌的用户
		 */
		private var _borrowTokenUsers:HashMap = new HashMap();
		private var _borrowTokenAlerts:HashMap = new HashMap();
		
		/**
		 * 从'我'这借用令牌
		 * @param	from
		 * @param	to
		 * @param	args
		 */
		public function borrowTokenFromMe( from:User, to:User, args:Array ):void
		{
			if ( _network.user.userid == to.userid )
			{
				if (_network.hasToken)
				{
					if (!_borrowTokenAlerts)
						_borrowTokenAlerts = new HashMap();
					if (!_borrowTokenUsers)
						_borrowTokenUsers = new HashMap();
					_borrowTokenUsers.put(from.userid, from);
					_borrowTokenAlerts.put(from.userid, Alert.show(from.name + GlobalVars.language == GlobalVars.LANG_CHINESE ? 'Speaker identity to your application, you agree?'  :"向您申请主讲身份，您同意吗？" ,'', onClose, "同意", "拒绝" ));
					
					function onClose( e:CloseEvent ):void
					{
						switch( CloseEvent(e).detail )
						{
							case Alert.FIRST_BUTTON:
								if(_network.hasToken)
								{
									_borrowTokenUsers.remove(from.userid);
									_network.sendRPC( from, "agreeMeBorrowToken" );
									var alerts:Array = _borrowTokenAlerts.getValues();
									for each(var alert:Alert in alerts)
									{
										if (alert.isPopUp)
										{
											PopUpManager.removePopUp(alert);
										}
									}
									
									_borrowTokenAlerts = null;
									
									var users:Array = _borrowTokenUsers.getValues();
									for each(var user:User in users)
									{
										_network.sendRPC( user, "denyMeBorrowToken" );
									}
									_borrowTokenUsers = null;
								}else
								{
									if (GlobalVars.language == GlobalVars.LANG_ENGLISH)
									{
										//英文
										Alert.show("You are not the speaker, which can not handle the request！");
									}else if(GlobalVars.language == GlobalVars.LANG_CHINESE)
									{
										//中文
										Alert.show("您目前不是主讲，不能处理该条请求！");
										
									}else
									{
										throw new Error('无法识别的语言！');
									}
									
								}
								break;
							case Alert.SECOND_BUTTON:case Alert.CLOSE_BUTTON:
								if(_network.hasToken)
								{
									_network.sendRPC( from, "denyMeBorrowToken" );
								}else
								{
									
									if (GlobalVars.language == GlobalVars.LANG_ENGLISH)
									{
										//英文
										Alert.show("You are not the speaker, which can not handle the request！");
									}else if(GlobalVars.language == GlobalVars.LANG_CHINESE)
									{
										//中文
										Alert.show("您目前不是主讲，不能处理该条请求！");
										
									}else
									{
										throw new Error('无法识别的语言！');
									}
									
								}
								_borrowTokenAlerts.remove(from.userid);
								break;
							default:
								break;
						}
					}
				}else
				{
					//TODO:A向令牌用户B请求借用令牌，B收到请求之后，有可能B已经不是令牌用户了，此时不清楚如何处理。
				}
			}
		}
		
		/**
		 * 令牌用户同意我抢令牌
		 * @param	from
		 * @param	to
		 * @param	args
		 */
		public function agreeMeBorrowToken( from:User, to:User, args:Array ):void
		{
			if ( _network.user.userid == to.userid )
			{
				_network.acquireToken();
			}
		}
		
		/**
		 * 令牌用户拒绝我抢令牌
		 * @param	from
		 * @param	to
		 * @param	args
		 */
		public function denyMeBorrowToken( from:User, to:User, args:Array ):void
		{
			if ( _network.user.userid == to.userid )
			{
				
				if (GlobalVars.language == GlobalVars.LANG_ENGLISH)
				{
					//英文
					Alert.show("Sorry, failed to apply for Speaker! Because Speaker " + from.name + "not agree!" );
				}else if(GlobalVars.language == GlobalVars.LANG_CHINESE)
				{
					//中文
					Alert.show("对不起，申请主讲失败！因为主讲 " + from.name + "不同意!" );
					
				}else
				{
					throw new Error('无法识别的语言！');
				}
				
				
			}
		}
		
		/**
		 * 机构定制的方法都以cm_开头
		 * 下课确认
		 * @param	from
		 * @param	to
		 * @param	args
		 */
		public function cm_finishClass(from:User, to:User, args:Array):void
		{
			GlobalVars.uiroot.addElement(CM_FinishClassConfirmView.getInstance());
		}
		
		/**
		 * 上课开始
		 * @param	from
		 * @param	to
		 * @param	args
		 */
		public function cm_onClassAttend(from:User, to:User, args:Array):void
		{
			GlobalVars.uiroot.addElement(CM_ClassRunningView.getInstance());
			CM_ClassRunningView.getInstance().handleClassAttend();
			CM_SANHAO_WebServer.getInstance().getLeftTime(GlobalVars.room_id);
		}
		
		/**
		 * 其他客户端委托主讲修改房间状态
		 * @param	from
		 * @param	to
		 * @param	args
		 */
		public function setRoomConfig(from:User, to:User, args:Array):void
		{
			if(to)
			{
				if (to.userid == _network.userId)
				{
					if (hasToken())
					{
						var map:Object = args[0];
						for (var key:String in map)
						{
							roomConfig()[key] = map[key];
						}
					}else
					{
						browserLog('用户', to.name, '不能修改RoomConfig，因为他已经没有权限.');
					}
				}
			}else
			{
				browserLog('没有指定用户来修改RoomConfig');
			}
		}
	}
}