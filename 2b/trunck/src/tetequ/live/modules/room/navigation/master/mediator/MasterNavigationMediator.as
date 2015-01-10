package tetequ.live.modules.room.navigation.master.mediator 
{
	import com.e2et.datalogic.User;
	import com.e2et.net.media.video.IVideoCapture;
	import com.e2et.ScreenCap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import framework.view.UIRoot;
	import org.flexlite.domUI.components.Alert;
	import org.flexlite.domUI.core.IVisualElement;
	import org.flexlite.domUI.events.CloseEvent;
	import robotlegs.bender.bundles.mvcs.Mediator;
	import tetequ.live.core.network.NetworkFacade;
	import tetequ.live.modules.room.avdocument.AVDocumentManager;
	import tetequ.live.modules.room.avdocument.DeviceSettingManager;
	import tetequ.live.modules.room.chat.input.events.InsertEscapeCharEvent;
	import tetequ.live.modules.room.cm.sanhao.CM_SANHAO_WebServer;
	import tetequ.live.modules.room.common.GlobalVars;
	import tetequ.live.modules.room.common.panel.PanelID;
	import tetequ.live.modules.room.common.panel.PanelManager;
	import tetequ.live.modules.room.doc.doclist.network.WebServerManager;
	import tetequ.live.modules.room.navigation.common.events.OpenContactUSEvent;
	import tetequ.live.modules.room.navigation.common.events.OpenHelpEvent;
	import tetequ.live.modules.room.navigation.common.events.OpenToolsEvent;
	import tetequ.live.modules.room.navigation.master.view.MasterNavigationView;
	//import tetequ.live.modules.room.stream.video.common.events.PublishEvent;
	//import tetequ.live.modules.room.stream.video.master.event.CloseScreenCaptureEvent;
	//import tetequ.live.modules.room.stream.video.master.event.TokenChangedEvent;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class MasterNavigationMediator extends Mediator 
	{
		[Inject]
		public var view:MasterNavigationView;
		
		[Inject]
		public var networkFacade:NetworkFacade;
		
		[Inject]
		public var webServer:WebServerManager;
		
		[Inject]
		public var panelManager:PanelManager;
		
		[Inject]
		public var uiroot:UIRoot;
		
		/**
		 * 距离上次打开系统设置面板的时间(毫秒)
		 * 用于限制用户打开系统设置面板的频率，
		 * 因为系统设置面板中对摄像头和麦克风的
		 * 设置很耗费性能！
		 */
		private var _interval:int;
		
		public function MasterNavigationMediator() 
		{
			super();
		}
		
		/**
		 * 初始化
		 */
		override public function initialize():void
		{
			super.initialize();
			this.view.btnDocument.addEventListener( MouseEvent.CLICK, onClick );
			this.view.btnCamPublish.addEventListener( MouseEvent.CLICK, onClick );
			this.view.btnToken.addEventListener( MouseEvent.CLICK, onClick );
			this.view.btnSysSettings.addEventListener( MouseEvent.CLICK, onClick );
			this.view.btnRecord.addEventListener(MouseEvent.CLICK, onClick);
			DeviceSettingManager.getInstance().network = networkFacade;
			
			//没有权限的用户不能看到上课下课按钮
			addContextListener(TokenChangedEvent.TOKEN_CHANGED, onTokenChanged);
			
			//三好机构需要上下课功能 cm=custom made，定制 
			addViewListener('shangke', cm_onShangKe);
			addViewListener('xiake', cm_onXiaKe);
		}
		
		private function onTokenChanged(e:TokenChangedEvent):void 
		{
			if (e.hasToken)
			{
				view.btnShangKe.visible = true;
				view.btnXiaKe.visible = true;
			}else
			{
				view.btnShangKe.visible = false;
				view.btnXiaKe.visible = false;
			}
		}
		
		/** cm_开头的变量或者方法都属于定制的 **/
		
		private function cm_onXiaKe(e:Event):void 
		{
			if (hasToken())
			{
				Alert.show('您确定要下课吗?', '', onClose, null, '确定', '取消');
				function onClose( e:CloseEvent ):void
				{
					switch( CloseEvent(e).detail )
					{
						case Alert.FIRST_BUTTON:
							trace('下课了~');
							networkFacade.sendRPC(null, 'cm_finishClass');
							CM_SANHAO_WebServer.getInstance().teacherClassReq(GlobalVars.user_session, GlobalVars.room_id, CM_SANHAO_WebServer.FINISH_CLASS);
							break;
						case Alert.SECOND_BUTTON:case Alert.CLOSE_BUTTON:
							break;
						default:
							break;
					}
				}
			}else WarningNoToken();
		}
		
		private function cm_onShangKe(e:Event):void 
		{
			if (hasToken())
			{
				Alert.show('您确定要开始上课吗?', '', onClose, null, '确定', '取消');
				function onClose( e:CloseEvent ):void
				{
					switch( CloseEvent(e).detail )
					{
						case Alert.FIRST_BUTTON:
							trace('上课了~');
							CM_SANHAO_WebServer.getInstance().teacherClassReq(GlobalVars.user_session, GlobalVars.room_id, CM_SANHAO_WebServer.ATTEND_CLASS);
							break;
						case Alert.SECOND_BUTTON:case Alert.CLOSE_BUTTON:
							break;
						default:
							break;
					}
				}
			}else WarningNoToken();
		}
		
		/**
		 * 按钮点击
		 * @param	e
		 */
		private function onClick(e:MouseEvent):void 
		{
			switch( e.currentTarget )
			{
				case this.view.btnDocument:
					webServer.reqDocsInfo();
					break;
				case this.view.btnCamPublish:
					if (uiroot.containsElement(DeviceSettingManager.getInstance())) return;
					DeviceSettingManager.getInstance().startup(false, true);
					DeviceSettingManager.getInstance().publish();
					break;
				case this.view.btnToken:
					tokenAcquire();
					break;
				case this.view.btnSysSettings :
					if (uiroot.containsElement(DeviceSettingManager.getInstance()))
					{
						uiroot.removeElement(DeviceSettingManager.getInstance());
					}else
					{
						uiroot.addElement(DeviceSettingManager.getInstance());
						DeviceSettingManager.getInstance().startup(true);
					}
					break;
				case view.btnRecord:
					if (!networkFacade.hasToken)
					{
						Alert.show("您没有权限使用录制功能!");
						return;
					}
					
					//FIXME:此处还应该判断videoId
					
					if (networkFacade.recording)
					{
						networkFacade.stopRecord();
						return;
					}
					
					//networkFacade.startRecord(Math.random().toString());
					var videoId:String = GlobalVars.videoId;
					if (!videoId)
					{
						//非平台下使用
						videoId = Math.random().toString();
					}

					networkFacade.startRecord(videoId);
					break;
				default:
					break;
			}
		}
		
		/**
		 * 抢令牌
		 */
		private function tokenAcquire():void 
		{
			
			var msg:String;
			var token:User = networkFacade.tokenUser;
			var btnLabel:String;
			if (token)
			{
				if (token.userid == networkFacade.userId)
				{
					
					if (GlobalVars.language == GlobalVars.LANG_ENGLISH)
					{
						//英文
						Alert.show("You have a speaker it!");
					}else if(GlobalVars.language == GlobalVars.LANG_CHINESE)
					{
						//中文
						Alert.show("您已经是主讲了！");
					}else
					{
						throw new Error('无法识别的语言！');
					}
					return;
				}
			
				
				if (GlobalVars.language == GlobalVars.LANG_ENGLISH)
				{
					//英文
						msg = "Speaker is the room " + token.name + ", You want to apply when the speaker it?";
						btnLabel = "申请主讲";
				}else if(GlobalVars.language == GlobalVars.LANG_CHINESE)
				{
					//中文
					msg = "房间主讲是 " + token.name + ", 您想申请当主讲吗？";
					btnLabel = "申请主讲";
				}else
				{
					throw new Error('无法识别的语言！');
				}
			}else
			{
				
				if (GlobalVars.language == GlobalVars.LANG_ENGLISH)
				{
					//英文
					msg = "No room speaker, you want it immediately became Speaker?";
					btnLabel = "Become Speaker";
				}else if(GlobalVars.language == GlobalVars.LANG_CHINESE)
				{
					//中文
					msg = "房间没有主讲，您想立刻成为主讲吗？";
					btnLabel = "成为主讲";
				}else
				{
					throw new Error('无法识别的语言！');
				}
			}
			
			Alert.show( msg, "", onClose, btnLabel, "更多信息"  );
			
			function onClose( e:CloseEvent ):void
			{
				switch( CloseEvent(e).detail )
				{
					case Alert.FIRST_BUTTON:
						if (token)
						{
							networkFacade.sendRPC(token, "borrowTokenFromMe");
						}else
						{
							networkFacade.acquireToken();
						}
						break;
					case Alert.SECOND_BUTTON:
						Alert.show("成为主讲后，您可以进行发言、文档翻页、画笔注记等操作。");
						break;
					default:
						break;
				}
			}
		}
		
	
		
		/**
		 * 清除操作
		 */
		override public function destroy():void
		{
			super.destroy();
			
			this.view.btnDocument.removeEventListener( MouseEvent.CLICK, onClick );
			this.view.btnCamPublish.removeEventListener( MouseEvent.CLICK, onClick );
			this.view.btnToken.removeEventListener( MouseEvent.CLICK, onClick );
			this.view.btnSysSettings.removeEventListener( MouseEvent.CLICK, onClick );
		}
		
	}

}