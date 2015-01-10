package tetequ.live.core.network 
{
	import adobe.utils.CustomActions;
	import com.e2et.datalogic.AVItem;
	import com.e2et.datalogic.AVReq;
	import com.e2et.datalogic.AVStream;
	import com.e2et.datalogic.Document;
	import com.e2et.datalogic.IMetaActionHandler;
	import com.e2et.datalogic.MediaPlayer;
	import com.e2et.datalogic.User;
	import com.e2et.ISession;
	import com.e2et.ISessionHandler;
	import com.e2et.Session;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import framework.view.UIRoot;
	import org.flexlite.domUI.components.Alert;
	import org.flexlite.domUI.managers.PopUpManager;
	import robotlegs.bender.framework.api.IInjector;
	import tetequ.live.core.network.events.MapMetaActionToHandlerEvent;
	import tetequ.live.modules.loading.events.RemoveLoadingEvent;
	import tetequ.live.modules.loading.view.LoadingView;
	import tetequ.live.modules.room.avdocument.AVDocumentManager;
	import tetequ.live.modules.room.chat.common.message.ChatMessageVo;
	import tetequ.live.modules.room.chat.group.events.AddGroupChatMessageEvent;
	import tetequ.live.modules.room.chat.group.events.UserEvent;
	import tetequ.live.modules.room.chat.input.events.SendGroupChatMessageEvent;
	import tetequ.live.modules.room.chat.privates.view.PrivateChatManager;
	import tetequ.live.modules.room.cm.sanhao.CM_ClassOverView;
	import tetequ.live.modules.room.cm.sanhao.CM_ClassRunningView;
	import tetequ.live.modules.room.cm.sanhao.CM_FinishClassConfirmView;
	import tetequ.live.modules.room.cm.sanhao.CM_SANHAO_WebServer;
	import tetequ.live.modules.room.common.GlobalVars;
	import tetequ.live.modules.room.common.keyboard.event.KeyboardManagerEvent;
	import tetequ.live.modules.room.common.layouts.command.StartupMasterLayoutCommand;
	import tetequ.live.modules.room.common.layouts.events.LayoutDirectorRegisterEvent;
	import tetequ.live.modules.room.common.layouts.events.StartupLayoutEvent;
	import tetequ.live.modules.room.common.panel.events.RegisterPanelClassEvent;
	import tetequ.live.modules.room.doc.common.FileInfoVo;
	import tetequ.live.modules.room.doc.common.IFileInfo;
	import tetequ.live.modules.room.doc.doclist.model.FileType;
	import tetequ.live.modules.room.doc.players.common.events.BindDocumentToCanvasEvent;
	import tetequ.live.modules.room.doc.players.common.events.CallPlayerEvent;
	import tetequ.live.modules.room.doc.players.common.events.DocGotoEvent;
	import tetequ.live.modules.room.doc.players.common.MasterPlayerManager;
	import tetequ.live.modules.room.doc.players.common.PlayerManager;
	import tetequ.live.modules.room.doc.players.common.StudentPlayerManager;
	import tetequ.live.modules.room.doc.players.media.audio.common.MasterAudioPlayerManager;
	import tetequ.live.modules.room.doc.players.media.audio.common.NormalAudioPlayerManager;
	import tetequ.live.modules.room.doc.players.media.common.events.MediaPlayChangeVolumeEvent;
	import tetequ.live.modules.room.doc.players.media.common.events.MediaPlaySeekEvent;
	import tetequ.live.modules.room.doc.players.media.common.events.MediaPlayTogglePauseEvent;
	import tetequ.live.modules.room.doc.players.media.video.common.MasterVideoPlayerManager;
	import tetequ.live.modules.room.doc.players.media.video.common.StudentVideoPlayerManager;
	import tetequ.live.modules.room.doc.tools.model.DocToolData;
	import tetequ.live.modules.room.error.FrozenLayer;
	import tetequ.live.modules.room.recording.events.RecordEvent;
	import tetequ.live.modules.room.recording.view.RecordingView;
	import tetequ.live.modules.room.remotelogin.events.RemoteLoginWarningEvent;
	import tetequ.live.modules.room.sound.SoundManager;
	//import tetequ.live.modules.room.stream.common.events.AVPlayInterruptEvent;
	//import tetequ.live.modules.room.stream.video.master.event.TokenChangedEvent;
	import tetequ.live.modules.room.userlist.events.AddUserToListEvent;
	import tetequ.live.modules.room.userlist.events.RemoveUserFromListEvent;
	import tetequ.live.modules.room.userlist.model.UserInfoItemVo;
	import tetequ.live.modules.room.userlist.UserListMsgManager;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class SessionHandler implements ISessionHandler 
	{
		[Inject]
		public var loadingView:LoadingView;
		
		[Inject]
		public var uiroot:UIRoot;
		
		[Inject]
		public var eventDispatcher:IEventDispatcher;
		
		[Inject]
		public var injector:IInjector;
		
		[Inject]
		public var actionHandler:MetaActionHandlerFacade;
		
		[Inject]
		public var mediaPlayHandler:MediaPlayHandler;
		
		[Inject]
		public var mediaPubHandler:MediaPubHandler;
		
		[Inject]
		public var playerManager:PlayerManager;
		
		[Inject]
		public var mPlayerManager:MasterPlayerManager;
		
		[Inject]
		public var sPlayerManager:StudentPlayerManager;
		
		[Inject]
		public var mAudioPlayerManager:MasterAudioPlayerManager;
		
		[Inject]
		public var nAudioPlayerManager:NormalAudioPlayerManager;
		
		[Inject]
		public var mVideoPlayerManager:MasterVideoPlayerManager;
		
		[Inject]
		public var sVideoPlayerManager:StudentVideoPlayerManager;
		
		[Inject]
		public var rpcClient:RPCClientImpl;
		
		[Inject]
		public var userListMsgManager:UserListMsgManager;
		
		public function SessionHandler() 
		{

		}
		
		/* INTERFACE com.e2et.ISessionHandler */
		
		public function sessionStarting($:ISession):void 
		{
			
		}
		
		public function sessionStartProgress($:ISession, progress:Number):void 
		{
			
		}
		
		private var _sessionStartedCount:int;
		public function sessionStarted($:ISession):void 
		{
			_sessionStartedCount++;
			if ( _sessionStartedCount == 1 )
			{
				/**
				 * 移除loading界面
				 */
				eventDispatcher.dispatchEvent( new RemoveLoadingEvent() );
				
				/**
				 * 注册所有面板
				 */
				eventDispatcher.dispatchEvent( new RegisterPanelClassEvent() );
				
				/**
				 * 初始化键盘管理器
				 */
				eventDispatcher.dispatchEvent( new KeyboardManagerEvent() );
				
				/**
				 * 注册所有动作到处理器
				 */
				eventDispatcher.dispatchEvent( new MapMetaActionToHandlerEvent() );
				
				//启动布局
				eventDispatcher.dispatchEvent( new LayoutDirectorRegisterEvent() );
				eventDispatcher.dispatchEvent( new StartupLayoutEvent( ( $.user.level & 0x80 ) ? StartupLayoutEvent.MASTER : StartupLayoutEvent.STUDENT ) );
				
				uiroot.addEventListener( Event.REMOVED_FROM_STAGE, onRemoved );
				
				var facade:NetworkFacade = injector.getInstance( NetworkFacade ) as NetworkFacade;

				checkRoomDoc( $ );
				checkRoomStream( $ );
				checkRoomMediaPlayer( $ );
				
				//检查房间上课的状态，这属于定制的功能
				var goon:Boolean = cm_checkRoomClassStatus($);
				if (!goon) return;
				
				if (Microphone.isSupported)
				{
					if (Microphone.getMicrophone() != null)
					{
						$.user.hasMic = true;
					}else
					{
						$.user.hasMic = false;
					}
				}else
				{
					$.user.hasMic = false;
				}
				
				if (Camera.isSupported)
				{
					if (Camera.getCamera() != null)
					{
						$.user.hasCam = true;
					}else
					{
						$.user.hasCam = false;
					}
				}else
				{
					$.user.hasCam = false;
				}
				
				
				// TODO:特殊处理sanhao机构的需求，这需要用接口隔离处理
				if (isVisitor($.user))
				{
					browserLog('当前用户是游客，开始屏蔽');
					uiroot.mouseChildren = false;
					var alert:Alert =  Alert.show('请注意，您是游客身份，除了观看之外将不能进行任何操作！');
					var st:uint = setTimeout(function():void
					{
						clearTimeout(st);
						PopUpManager.removePopUp(alert);
					},3500);
				}
				
				$.rpcClient = rpcClient;
				rpcClient.setNetwork( facade );
				rpcClient.setEventDispatcher( eventDispatcher );
				
				var st:uint = setTimeout(function():void {
					//如果房间没有令牌，则抢令牌
					clearTimeout(st);
					if (!facade.hasTokenUser)
					{
						facade.acquireToken();
					}
				},1000);
			}else
			{
				//重连了
				frozen.hide();
			}
		}
		
		private function cm_checkRoomClassStatus($:ISession):Boolean 
		{
			var goon:Boolean = true;
			var status:String = $.room.config['classStatus'];
			if (status == CM_SANHAO_WebServer.ATTEND_CLASS)
			{
				GlobalVars.uiroot.addElement(CM_ClassRunningView.getInstance());
				CM_ClassRunningView.getInstance().handleClassAttend();
				CM_SANHAO_WebServer.getInstance().getLeftTime(GlobalVars.room_id);
			}else if (status == CM_SANHAO_WebServer.FINISH_CLASS)
			{
				GlobalVars.uiroot.stage.mouseChildren = false;
				GlobalVars.uiroot.addElement(CM_ClassOverView.getInstance());
				$.close();
				goon = false;
			}else
			{
				
			}
			
			return goon;
		}
		
		private function onRemoved(e:Event):void 
		{
			uiroot.removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			trace( "uiroot 被移除" );
		}
		
		public function sessionStartFailed($:ISession, reason:String):void 
		{
			frozen.show( "对不起，重连不成功，请您刷新浏览器重新登陆！", uiroot );
		}
		
		[Inject]
		public var frozen:FrozenLayer;
		
		public function sessionInterrupted($:ISession, reason:String):void 
		{
			var facade:NetworkFacade = injector.getInstance( NetworkFacade ) as NetworkFacade;
			frozen.show( "掉线啦！不过别担心，系统正在尝试重连，请耐心等待...", uiroot );
		}
		
		/**
		 * 检查房间的media
		 * @param	$
		 */
		private function checkRoomMediaPlayer($:ISession):void 
		{
			var mps:Vector.<MediaPlayer> = $.room.mediaPlayers;
			if ( !mps ) return;
			
			var level:uint = $.room.user.level;
			var playerId:String;
			
			for each( var mp:MediaPlayer in mps )
			{
				var mInfo:* = mp.mediaInfo;
				var isMaster:Boolean = level & 0x80;
				playerId = isMaster ? mInfo['master'] : mInfo['normal'];
				
				//此处的playerId如果是AUDIO族的，则需要特殊的处理
				var type:String = mInfo['type'];
				if ( type == FileType.AUDIO )
				{
					uiroot.addElement( ( isMaster ? mAudioPlayerManager : mAudioPlayerManager).playerLayout );
					( isMaster ? mAudioPlayerManager : mAudioPlayerManager).openPlayerById( playerId );
				}else if ( type == FileType.VIDEO )
				{
					uiroot.addElement( ( isMaster ? mVideoPlayerManager : mVideoPlayerManager).playerLayout );
					( isMaster ? mVideoPlayerManager : mVideoPlayerManager).openPlayerById( playerId );
				}
				else
				{
					( isMaster ? mPlayerManager : mPlayerManager ).openPlayerById( playerId );
				}
				
				var fileInfo:IFileInfo = new FileInfoVo();
				fileInfo.id = mInfo['id'];
				fileInfo.name = mInfo['name'];
				fileInfo.path = mp.file;
				fileInfo.type = mInfo['type'];
				
				//播放
				eventDispatcher.dispatchEvent( new CallPlayerEvent( fileInfo, playerId ) );
				
				//更新时间戳
				eventDispatcher.dispatchEvent( new MediaPlaySeekEvent( mp.file, mp.time ) );
				
				//更新音量
				eventDispatcher.dispatchEvent( new MediaPlayChangeVolumeEvent( mp.file, mp.volume ) );
				
				//更新暂停或者播放状态
				eventDispatcher.dispatchEvent( new MediaPlayTogglePauseEvent( mp.file, mp.paused ) );
			}
		}
		
		/**
		 * 检查是否有人正在发布视频
		 * @param	$
		 */
		private function checkRoomStream( $:ISession ):void 
		{
			//TODO:目前感觉没必要在这里进行处理
		}
		
		/**
		 * 检查房间是否有已经打开的文档
		 */
		private function checkRoomDoc( $:ISession ):void
		{
			var doc:Document = $.room.doc;
			if ( !doc ) return;
			
			var docInfo:* = doc.docInfo;
				
			/**
			 * 当前用户的级别
			 */
			var level:uint = $.room.user.level;
			
			/**
			 * 获取用于打开当前文档的播放器id
			 */
			var playerId:String = ( level & 0x80 ) ? docInfo['master'] : docInfo['normal'];
			
			/**
			 * 打开播放器
			 */
			((level & 0x80) ? mPlayerManager : sPlayerManager).openPlayerById( playerId );
			
			/**
			 * 构造一个文档信息对象
			 */
			var fileInfo:IFileInfo = new FileInfoVo();
			fileInfo.id = docInfo['id'];
			fileInfo.name = doc.name;
			fileInfo.path = doc.uri;
			fileInfo.type = docInfo['type'];
			fileInfo.pages = docInfo['pages'];
			
			//通知播放器打开文档
			eventDispatcher.dispatchEvent( new CallPlayerEvent( fileInfo, playerId ) );
			
			//设置文档对象到绘图层FIXME:此处可能会有其他处理！
			eventDispatcher.dispatchEvent( new BindDocumentToCanvasEvent( doc ) );
			
			//可能是打开的图片，不需要翻页
			if ( fileInfo.type == FileType.IMAGE )
			{
				return;
			}
			
			//播放指定页文档(内部pageNo从0开始，所以这里要+1)
			eventDispatcher.dispatchEvent( new DocGotoEvent( doc.pageNo + 1, doc.page.step, playerId ) );
		}
		
		/**
		 * 
		 * @param	$
		 * @param	user 新用户进入房间时，房间内其他用户都会收到 UserIn 消息
		 */
		public function handleUserIn($:ISession, user:User):void 
		{
			user.addHandler( actionHandler );
			
			//if (isVisitor(user)) return;
			
			eventDispatcher.dispatchEvent(new AddUserToListEvent(user));
			eventDispatcher.dispatchEvent(new UserEvent(UserEvent.USER_IN));
			SoundManager.getInstance().playSound('userin');
		}

		/**
		 * 用户离开房间时，房间内其他用户都会收到 UserOut 消息
		 * @param	$
		 * @param	user
		 * @param	type	0 - 用户退出, 1 - 用户掉线, 2 - 用户超时, 3 - 重复登录
		 */
		public function handleUserOut($:ISession, user:User, type:uint):void 
		{
			user.delHandler( actionHandler );
			$.room.delAVItemByUser( user );
			$.room.delAVReqByUser( user );

			//if (isVisitor(user)) return;
			
			eventDispatcher.dispatchEvent(new RemoveUserFromListEvent(user.userid));
			eventDispatcher.dispatchEvent(new UserEvent(UserEvent.USER_Out));

			if ( !user.streams ) return;
			
			for each( var avstm:AVStream in user.streams )
			{
				if ( avstm )
				{
					if( avstm.mp )
					{
						avstm.mp.delHandler( mediaPlayHandler );
					}
					
					if ( avstm.user.userid == user.userid )
					{
						AVDocumentManager.getInstance().mediaPlayInterrupted(avstm.mp, '掉线了');
					}

					avstm.close();
				}
			}
		}
		
		/**
		 * 处理用户状态更新
		 * @param	$
		 * @param	user
		 */
		public function handleUserUpdate($:ISession, user:User):void 
		{
			user.addHandler( actionHandler );
			
			if( user.streams )
			{
				for each( var astm:AVStream in user.streams )
				{
					if ( astm.isOpened )
					{
						astm.mp.addHandler( mediaPlayHandler );
					}
				}
			}
		}
		
		/**
		 * 接收到一条消息
		 * @param	$
		 * @param	sender
		 * @param	receiver
		 * @param	time
		 * @param	msg
		 */
		public function handleChat($:ISession, sender:User, receiver:User, time:uint, msg:String):void 
		{
			var msgVo:ChatMessageVo = new ChatMessageVo();
			msgVo.message = msg;
			msgVo.userId = sender.userid;
			msgVo.username = sender.name;
			msgVo.timestamp = time;
			msgVo.userLevel = sender.level;
			msgVo.from = sender;
			msgVo.toUser = receiver;
			
			if(receiver==null)
			{
				eventDispatcher.dispatchEvent( new AddGroupChatMessageEvent( msgVo ) );
			}else
			{
				PrivateChatManager.getInstance().addMessage(msgVo);
			}
		}
		
		/**
		 * 处理远程调用
		 * @param	$
		 * @param	sender
		 * @param	receiver
		 * @param	func
		 * @param	args
		 */
		public function handleRPC($:ISession, sender:User, receiver:User, func:String, args:Array):void 
		{
			//TODO
			trace( ".............." );
		}
		
		/**
		 * 当前用户帐号在别处登陆
		 * 1.关闭当前用户的各种media流
		 * 2.关闭信令
		 * 3.界面提示
		 * @param	$
		 */
		public function handleRemoteLogin($:ISession):void 
		{
			if ( $.user.hasStream )
			{
				for each( var avstm:AVStream in $.user.streams )
				{
					avstm.close();
				}
			}
			
			$.close();
			
			eventDispatcher.dispatchEvent( new RemoteLoginWarningEvent() );
		}
		
		/**
		 * 令牌易主
		 * 令牌用户可能为空
		 * @param	$
		 * @param	token
		 * @param	prevToken
		 */
		public function tokenChanged($:ISession, token:User, prevToken:User):void 
		{
			var facade:NetworkFacade = injector.getInstance( NetworkFacade ) as NetworkFacade;
			facade.addRoomHandler( actionHandler );
			facade.tokenUser = token;
			
			if (prevToken)
			{
				if (prevToken.userid == facade.userId)
				{
					
					if (GlobalVars.language == GlobalVars.LANG_ENGLISH)
					{
						//英文
						Alert.show("You lose the speaker identity!");
					}else if(GlobalVars.language == GlobalVars.LANG_CHINESE)
					{
						//中文
						Alert.show("您失去了主讲身份！");
						
					}else
					{
						throw new Error('无法识别的语言！');
					}
				}
			}
			
			if (facade.hasToken)
			{
				$.room.config['classStatus'] = 'dummy';
				browserLog('获得令牌');
			}else
			{
				browserLog('未获取到令牌');
			}
			
			if( token )
			{
				DocToolData.hasToken = facade.hasToken;
				eventDispatcher.dispatchEvent( new TokenChangedEvent( token.userid == facade.userId ) );
			}
		}
		
		/**
		 * 获取令牌失败了
		 * @param	$
		 * @param	code	code 1 - 没有权限，2 - 重复获取
		 */
		public function acquireTokenFailed($:ISession, code:uint ):void 
		{
			var facade:NetworkFacade = injector.getInstance( NetworkFacade ) as NetworkFacade;
			facade.addRoomHandler( actionHandler );
			Alert.show("对不起，获取令牌失败了！原因:"+(code==1?"没有权限":"重复获取"));
		}
		
		/********************************录制***************************************/
		
		public function handleRecordStartFailed ($:ISession, code:uint):void
		{
			if (!$.hasToken) return;
			trace("录制失败！", code);
			Alert.show("对不起，录制功能启动失败了！code="+code);
		}
		
		/**
		 * 开始录制成功 - 所有人都可以收到该消息
		 * @param	$
		 * @param	videoId
		 */
		public function handleRecordStarted ($:ISession, videoId:String):void
		{
			if (!$.hasToken) return;
			trace("录制开始了！", videoId);
			uiroot.addElement(RecordingView.getInstance());
			eventDispatcher.dispatchEvent(new RecordEvent($, videoId, RecordEvent.STARTED));
		}
		
		public function handleRecordStopped ($:ISession):void
		{
			if (!$.hasToken) return;
			trace("录制停止了！");
			eventDispatcher.dispatchEvent(new RecordEvent($, null, RecordEvent.STOPED));
		}
		
	}

}