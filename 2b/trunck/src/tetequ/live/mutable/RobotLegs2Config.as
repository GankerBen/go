package tetequ.live.mutable 
{
	import tetequ.live.core.assets.AssetsFactory;
	import tetequ.live.core.network.actionhandlers.AVStreamChangeStateHandler;
	import tetequ.live.core.network.actionhandlers.AVStreamCloseHandler;
	import tetequ.live.core.network.actionhandlers.AVStreamOpenHandler;
	import tetequ.live.core.network.actionhandlers.AVStreamToggleAudioHandler;
	import tetequ.live.core.network.actionhandlers.AVStreamToggleVideoHandler;
	import tetequ.live.core.network.actionhandlers.DocCloseHandler;
	import tetequ.live.core.network.actionhandlers.DocLineAddPointHandler;
	import tetequ.live.core.network.actionhandlers.DocLineEndHandler;
	import tetequ.live.core.network.actionhandlers.DocLineStartHandler;
	import tetequ.live.core.network.actionhandlers.DocOpenHandler;
	import tetequ.live.core.network.actionhandlers.DocPageGotoHandler;
	import tetequ.live.core.network.actionhandlers.DocSetPageCountHandler;
	import tetequ.live.core.network.actionhandlers.DocTextChangePositionHandler;
	import tetequ.live.core.network.actionhandlers.DocTextChangeTextHandler;
	import tetequ.live.core.network.actionhandlers.MediaPlayChangeVolumeHandler;
	import tetequ.live.core.network.actionhandlers.MediaPlayCloseHandler;
	import tetequ.live.core.network.actionhandlers.MediaPlayOpenHandler;
	import tetequ.live.core.network.actionhandlers.MediaPlaySeekHandler;
	import tetequ.live.core.network.actionhandlers.MediaPlayTogglePauseHandler;
	import tetequ.live.core.network.actionhandlers.RoomAddDelAVItemHandler;
	import tetequ.live.core.network.actionhandlers.RoomAddDelAVReqHandler;
	import tetequ.live.core.network.actionhandlers.RoomChangeConfigHandler;
	import tetequ.live.core.network.actionhandlers.RoomObjectPurgeHandler;
	import tetequ.live.core.network.actionhandlers.UserChangeLevelHandler;
	import tetequ.live.core.network.actionhandlers.UserUpdateHasCamHandler;
	import tetequ.live.core.network.actionhandlers.UserUpdateHasMicHandler;
	import tetequ.live.core.network.command.MapMetaActionToHandlerCommand;
	import tetequ.live.core.network.events.MapMetaActionToHandlerEvent;
	import tetequ.live.core.network.MediaPlayHandler;
	import tetequ.live.core.network.MediaPubHandler;
	import tetequ.live.core.network.MetaActionHandlerFacade;
	import tetequ.live.core.network.MetaActionHandlerMapper;
	import tetequ.live.core.network.NetworkFacade;
	import tetequ.live.core.network.RPCClientImpl;
	import tetequ.live.core.network.SessionHandler;
	import tetequ.live.modules.loading.command.RemoveLoadingCommand;
	import tetequ.live.modules.loading.events.RemoveLoadingEvent;
	import tetequ.live.modules.loading.view.LoadingView2;
	import tetequ.live.modules.login.command.LoginCommand;
	import tetequ.live.modules.login.command.RemoveLoginCommand;
	import tetequ.live.modules.login.command.ShowLoginCommand;
	import tetequ.live.modules.login.events.LoginEvent;
	import tetequ.live.modules.login.events.RemoveLoginEvent;
	import tetequ.live.modules.login.events.ShowLoginEvent;
	import tetequ.live.modules.login.mediator.LoginMediator;
	import tetequ.live.modules.login.model.LoginVoCache;
	import tetequ.live.modules.login.view.LoginView;
	//import tetequ.live.modules.room.avfullscreen.mediator.AVFullScreenMediator;
	//import tetequ.live.modules.room.avfullscreen.view.AVFullScreenView;
	import tetequ.live.modules.room.avreq.mediator.AVReqMediator;
	import tetequ.live.modules.room.avreq.view.AVReqView;
	import tetequ.live.modules.room.chat.common.face.FaceFactory;
	import tetequ.live.modules.room.chat.common.face.FaceLoader;
	import tetequ.live.modules.room.chat.group.events.AddGroupChatMessageEvent;
	import tetequ.live.modules.room.chat.group.mediator.GroupChatMediator;
	import tetequ.live.modules.room.chat.group.view.GroupChatView;
	import tetequ.live.modules.room.chat.input.command.OpenFacePanelCommand;
	import tetequ.live.modules.room.chat.input.command.SendGroupChatMessageCommand;
	import tetequ.live.modules.room.chat.input.events.OpenFacePanelEvent;
	import tetequ.live.modules.room.chat.input.events.SendGroupChatMessageEvent;
	import tetequ.live.modules.room.chat.input.mediator.GroupChatInputMediator;
	import tetequ.live.modules.room.chat.input.view.GroupChatInputView;
	import tetequ.live.modules.room.chat.privates.mediator.PrivateInputMediator;
	import tetequ.live.modules.room.chat.privates.view.PrivateInputView;
	import tetequ.live.modules.room.common.keyboard.command.KeyboardManagerInitCommand;
	import tetequ.live.modules.room.common.keyboard.event.KeyboardManagerEvent;
	import tetequ.live.modules.room.common.keyboard.KeyboardManager;
	import tetequ.live.modules.room.common.layouts.command.LayoutDirectorRegisterCommand;
	import tetequ.live.modules.room.common.layouts.command.MasterLayoutElementsInstallCommand;
	import tetequ.live.modules.room.common.layouts.command.StudentLayoutElementsInstallCommand;
	import tetequ.live.modules.room.common.layouts.command.StartupMasterLayoutCommand;
	import tetequ.live.modules.room.common.layouts.command.StartupStudentLayoutCommand;
	import tetequ.live.modules.room.common.layouts.events.LayoutDirectorRegisterEvent;
	import tetequ.live.modules.room.common.layouts.events.LayoutElementsInstallEvent;
	import tetequ.live.modules.room.common.layouts.events.StartupLayoutEvent;
	import tetequ.live.modules.room.common.layouts.MasterLayoutDirector;
	import tetequ.live.modules.room.common.layouts.StudentLayoutDirector;
	import tetequ.live.modules.room.common.layouts.UIManager;
	import tetequ.live.modules.room.doc.common.upload.FileUploadManager;
	import tetequ.live.modules.room.doc.doclist.model.WebServerConfig;
	import tetequ.live.modules.room.doc.doclist.network.WebServerManager;
	import tetequ.live.modules.room.doc.players.common.CanvasManager;
	import tetequ.live.modules.room.doc.players.common.MasterPlayerLayout;
	import tetequ.live.modules.room.doc.players.common.MasterPlayerManager;
	import tetequ.live.modules.room.doc.players.common.PlayerManager;
	import tetequ.live.modules.room.doc.players.common.StudentPlayerLayout;
	import tetequ.live.modules.room.doc.players.common.StudentPlayerManager;
	import tetequ.live.modules.room.doc.players.img.common.IMGDataCenter;
	import tetequ.live.modules.room.doc.players.media.audio.common.AudioDataCenter;
	import tetequ.live.modules.room.doc.players.media.audio.common.MasterAudioPlayerManager;
	import tetequ.live.modules.room.doc.players.media.audio.common.NormalAudioPlayerManager;
	import tetequ.live.modules.room.doc.players.media.video.common.MasterVideoPlayerManager;
	import tetequ.live.modules.room.doc.players.media.video.common.StudentVideoPlayerManager;
	import tetequ.live.modules.room.doc.players.media.video.common.VideoDataCenter;
	import tetequ.live.modules.room.doc.players.ppt.common.PPTDataCenter;
	import tetequ.live.modules.room.doc.tools.mediator.DocToolMediator;
	import tetequ.live.modules.room.doc.tools.model.DocToolData;
	import tetequ.live.modules.room.doc.tools.view.DocToolView;
	import tetequ.live.modules.room.error.FrozenLayer;
	import tetequ.live.modules.room.navigation.common.command.OpenContactUSCommand;
	import tetequ.live.modules.room.navigation.common.command.OpenHelpCommand;
	import tetequ.live.modules.room.navigation.common.command.OpenIncPowerCommand;
	import tetequ.live.modules.room.navigation.common.command.OpenToolsCommand;
	import tetequ.live.modules.room.navigation.common.events.OpenContactUSEvent;
	import tetequ.live.modules.room.navigation.common.events.OpenHelpEvent;
	import tetequ.live.modules.room.navigation.common.events.OpenIncPowerEvent;
	import tetequ.live.modules.room.navigation.common.events.OpenToolsEvent;
	import tetequ.live.modules.room.navigation.master.mediator.MasterNavigationMediator;
	import tetequ.live.modules.room.navigation.master.view.MasterNavigationView;
	import tetequ.live.modules.room.navigation.normal.mediator.NormalNavigationMediator;
	import tetequ.live.modules.room.navigation.normal.view.NormalNavigationView;
	import tetequ.live.modules.room.recording.mediator.RecordingMediator;
	import tetequ.live.modules.room.recording.view.RecordingView;
	import tetequ.live.modules.room.remotelogin.command.RemoteLoginWarningCommand;
	import tetequ.live.modules.room.remotelogin.events.RemoteLoginWarningEvent;
	//import tetequ.live.modules.room.stream.common.DeviceFacade;
	//import tetequ.live.modules.room.stream.video.master.mediator.MultiMasterVideoMediator;
	//import tetequ.live.modules.room.stream.video.master.view.MultiAVView;
	import tetequ.live.modules.room.userlist.mediator.UserListMediator;
	import tetequ.live.modules.room.userlist.UserListMsgManager;
	import tetequ.live.modules.room.userlist.view.UserListView;
	import tetequ.live.mutable.RegisterPanelCommand;
	import robotlegs.bender.extensions.matching.ITypeMatcher;
	import robotlegs.bender.extensions.matching.TypeFilter;
	import robotlegs.bender.extensions.matching.TypeMatcher;
	import tetequ.live.core.network.events.ConnectServerEvent;
	import framework.command.FrameworkDoneCommand;
	import framework.events.FrameworkEvent;
	import framework.view.UIRoot;
	import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
	import robotlegs.bender.framework.api.IConfig;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IInjector;
	import tetequ.live.core.assets.AssetsLoader;
	import tetequ.live.core.assets.command.GroupCompleteCommand;
	import tetequ.live.core.assets.events.GroupCompleteEvent;
	import tetequ.live.modules.loading.command.ShowLoadingCommand;
	import tetequ.live.modules.loading.events.ShowLoadingEvent;
	import tetequ.live.modules.loading.view.LoadingView;
	import tetequ.live.core.network.command.ConnectServerCommand;
	import tetequ.live.core.network.events.ConnectServerEvent;
	import tetequ.live.modules.room.common.panel.events.RegisterPanelClassEvent;
	import tetequ.live.modules.room.common.panel.PanelFactory;
	import tetequ.live.modules.room.common.panel.PanelManager;
	import tetequ.live.modules.room.doc.doclist.mediator.FileListMediator;
	import tetequ.live.modules.room.doc.doclist.view.FileListView;
	import tetequ.live.modules.room.doc.players.docx.common.model.DocxDataCenter;
	import tetequ.live.modules.room.doc.players.docx.master.mediator.MasterDocxGroupsPlayerMediator;
	import tetequ.live.modules.room.doc.players.docx.master.view.MasterDocxGroupsPlayer;
	import tetequ.live.modules.room.doc.players.docx.normal.mediator.NormalDocxGroupsPlayerMediator;
	import tetequ.live.modules.room.doc.players.docx.normal.view.NormalDocxGroupsPlayer;
	import tetequ.live.modules.room.doc.players.img.master.mediator.MasterSIMGGPlayerMediator;
	import tetequ.live.modules.room.doc.players.img.master.view.MasterSingleIMGGroupsPlayer;
	import tetequ.live.modules.room.doc.players.img.normal.mediator.NormalSIMGGPlayerMediator;
	import tetequ.live.modules.room.doc.players.img.normal.view.NormalSingleIMGGroupsPlayer;
	import tetequ.live.modules.room.doc.players.media.audio.master.mediator.MasterAudioPlayerMediator;
	import tetequ.live.modules.room.doc.players.media.audio.master.view.MasterAudioPlayer;
	import tetequ.live.modules.room.doc.players.media.audio.normal.mediator.NormalAudioPlayerMediator;
	import tetequ.live.modules.room.doc.players.media.audio.normal.view.NormalAudioPlayer;
	import tetequ.live.modules.room.doc.players.media.video.master.mediator.MasterVideoPlayerMediator;
	import tetequ.live.modules.room.doc.players.media.video.master.view.MasterVideoPlayer;
	import tetequ.live.modules.room.doc.players.media.video.normal.mediator.NormalVideoPlayerMediator;
	import tetequ.live.modules.room.doc.players.media.video.normal.view.NormalVideoPlayer;
	import tetequ.live.modules.room.doc.players.ppt.master.mediator.MasterPPTPlayerMediator;
	import tetequ.live.modules.room.doc.players.ppt.master.view.MasterPPTPlayer;
	import tetequ.live.modules.room.doc.players.ppt.normal.mediator.NormalPPTPlayerMediator;
	import tetequ.live.modules.room.doc.players.ppt.normal.view.NormalPPTPlayer;
	//import tetequ.live.modules.room.individuation.setup.mediator.SystemSettingsMediator;
	//import tetequ.live.modules.room.individuation.setup.view.SystemSettingsView;
	import tetequ.live.modules.room.tools.mediator.ToolsMediator;
	import tetequ.live.modules.room.tools.view.ToolsView;
	import tetequ.live.startup.StartupCommand;
	
	/**
	 * ...
	 * @author pandazhong
	 * robotlegs2初始化相关配置
	 */
	public class RobotLegs2Config implements IConfig 
	{
		[Inject]
		public var injector:IInjector;
		
		[Inject]
		public var commandMap:IEventCommandMap;
		
		[Inject]
		public var mediatorMap:IMediatorMap;
		
		public function RobotLegs2Config() {}
		
		/* INTERFACE robotlegs.bender.framework.api.IConfig */
		
		public function configure():void 
		{
			configureModels();
			configureCommands();
			configureMediators();
		}
		
		/**
		 * 建立event与command的映射关系
		 */
		private function configureCommands():void 
		{
			//登陆界面-仅内部测试用
			commandMap.map( ShowLoginEvent.SHOW_LOGIN, ShowLoginEvent ).toCommand( ShowLoginCommand );
			commandMap.map( RemoveLoginEvent.REMOVE_LOGIN, RemoveLoginEvent ).toCommand( RemoveLoginCommand );
			commandMap.map( LoginEvent.LOGIN, LoginEvent ).toCommand( LoginCommand );
			
			//应用程序框架初始化完毕
			commandMap.map( FrameworkEvent.FRAMEWORK_DONE, FrameworkEvent ).toCommand( FrameworkDoneCommand );		
			
			//启动资源加载流程
			commandMap.map( FrameworkEvent.APPLICATION_STARTUP, FrameworkEvent ).toCommand( StartupCommand );				
			
			//UI资源组加载完毕
			commandMap.map( GroupCompleteEvent.GROUP_COMPLETE, GroupCompleteEvent ).toCommand( GroupCompleteCommand );		

			//显示loading界面
			commandMap.map( ShowLoadingEvent.SHOW_LOADING, ShowLoadingEvent ).toCommand( ShowLoadingCommand );
			
			//连接信令服务器
			commandMap.map( ConnectServerEvent.CONNECT_SERVER, ConnectServerEvent ).toCommand( ConnectServerCommand );
			
			//移除loading界面
			commandMap.map( RemoveLoadingEvent.REMOVE_LOADING, RemoveLoadingEvent ).toCommand( RemoveLoadingCommand );
			
			//注册action到handler
			commandMap.map( MapMetaActionToHandlerEvent.MAP, MapMetaActionToHandlerEvent ).toCommand( MapMetaActionToHandlerCommand );
			
			//注册面板类到工厂
			commandMap.map( RegisterPanelClassEvent.REGISTER, RegisterPanelClassEvent ).toCommand( RegisterPanelCommand );
			
			//键盘管理器
			commandMap.map( KeyboardManagerEvent.INIT, KeyboardManagerEvent ).toCommand( KeyboardManagerInitCommand );

			//打开聊天表情面板
			commandMap.map( OpenFacePanelEvent.OPEN, OpenFacePanelEvent ).toCommand( OpenFacePanelCommand );
			
			//发送群聊天消息
			commandMap.map( SendGroupChatMessageEvent.SEND, SendGroupChatMessageEvent ).toCommand( SendGroupChatMessageCommand );
			
			//使用主讲界面布局
			commandMap.map( StartupLayoutEvent.MASTER, StartupLayoutEvent ).toCommand( StartupMasterLayoutCommand );
			
			//使用学生界面布局
			commandMap.map( StartupLayoutEvent.STUDENT, StartupLayoutEvent ).toCommand( StartupStudentLayoutCommand );
			
			//注册界面布局管理器
			commandMap.map( LayoutDirectorRegisterEvent.REGISTER, LayoutDirectorRegisterEvent ).toCommand( LayoutDirectorRegisterCommand );
			
			//主讲界面元素初始化
			commandMap.map( LayoutElementsInstallEvent.MASTER, LayoutElementsInstallEvent ).toCommand( MasterLayoutElementsInstallCommand );
			
			//学生界面元素初始化
			commandMap.map( LayoutElementsInstallEvent.STUDENT, LayoutElementsInstallEvent ).toCommand( StudentLayoutElementsInstallCommand );
			
			//用户帐号在别处登陆
			commandMap.map( RemoteLoginWarningEvent.REMOTE_WARNING, RemoteLoginWarningEvent ).toCommand( RemoteLoginWarningCommand );
		}
		
		/**
		 * 建立view与mediator的映射关系
		 */
		private function configureMediators():void 
		{
			//登陆界面，内部测试用
			mediatorMap.map( LoginView ).toMediator( LoginMediator );
			
			//主讲版本的普通文档播放器
			mediatorMap.map( MasterDocxGroupsPlayer ).toMediator( MasterDocxGroupsPlayerMediator );		
			
			//学生版本的普通文档播放器
			mediatorMap.map( NormalDocxGroupsPlayer ).toMediator( NormalDocxGroupsPlayerMediator );	
			
			//主讲版本的单帧图片播放器
			mediatorMap.map( MasterSingleIMGGroupsPlayer ).toMediator( MasterSIMGGPlayerMediator );	
			
			//学生版本的单帧图片播放器
			mediatorMap.map( NormalSingleIMGGroupsPlayer ).toMediator( NormalSIMGGPlayerMediator );	
			
			//主讲版本的音频播放器
			mediatorMap.map( MasterAudioPlayer ).toMediator( MasterAudioPlayerMediator );	
			
			//学生版本的音频播放器
			mediatorMap.map( NormalAudioPlayer ).toMediator( NormalAudioPlayerMediator );					
			
			//主讲版本的视频播放器
			mediatorMap.map( MasterVideoPlayer ).toMediator( MasterVideoPlayerMediator );		
			
			//学生版本的视频播放器
			mediatorMap.map( NormalVideoPlayer ).toMediator( NormalVideoPlayerMediator );					
			
			//主讲版本的PPT文档播放器
			mediatorMap.map( MasterPPTPlayer ).toMediator( MasterPPTPlayerMediator );		
			
			//学生版本的PPT文档播放器
			mediatorMap.map( NormalPPTPlayer ).toMediator( NormalPPTPlayerMediator );						
			
			//主讲摄像头视频播放界面-单路
			//mediatorMap.map( MasterVideoView ).toMediator( MasterVideoMediator );//已废弃2014-6-26
			
			//主讲摄像头视频播放界面-多路
			//mediatorMap.map( MultiMasterVideoView ).toMediator( MultiMasterVideoMediator );
			//mediatorMap.map( MultiAVView ).toMediator( MultiMasterVideoMediator );
			
			//学生摄像头视频播放界面-单路
			//mediatorMap.map( NormalVideoView ).toMediator( NormalVideoMediator );//已废弃2014-6-26
			
			//学生摄像头视频播放界面-多路
			//mediatorMap.map( MultiStudentVideoView ).toMediator( MultiStudentVideoMediator );
			
			
			
			//导航条(主讲)
			mediatorMap.map( MasterNavigationView ).toMediator( MasterNavigationMediator );
			
			//导航条(学生)
			mediatorMap.map( NormalNavigationView ).toMediator( NormalNavigationMediator );
			
			//文档列表-面板
			mediatorMap.map( FileListView ).toMediator( FileListMediator );			
			
			//系统设置-面板
			//mediatorMap.map( SystemSettingsView ).toMediator( SystemSettingsMediator );	
			
			//工具-面板
			mediatorMap.map( ToolsView ).toMediator( ToolsMediator );						
			
			//群聊天消息输入组件
			mediatorMap.map( GroupChatInputView ).toMediator( GroupChatInputMediator );		
			
			//群聊天消息显示组件
			mediatorMap.map( GroupChatView ).toMediator( GroupChatMediator );

			//用户列表组件
			mediatorMap.map( UserListView ).toMediator( UserListMediator );
			
			//发言申请消息显示界面
			mediatorMap.map( AVReqView ).toMediator( AVReqMediator );
			
			//画笔工具
			mediatorMap.map( DocToolView ).toMediator( DocToolMediator );
			
			//av全屏
			//mediatorMap.map(AVFullScreenView).toMediator(AVFullScreenMediator);
			
			//录制
			mediatorMap.map(RecordingView).toMediator(RecordingMediator);
			
			//私聊输入框
			mediatorMap.map(PrivateInputView).toMediator(PrivateInputMediator);
		}
		
		/**
		 * 建立类型到实例的映射关系
		 */
		private function configureModels():void 
		{
			//UI框架主容器，桥接flexlite与flash的原生显示列表
			injector.map( UIRoot ).asSingleton();
			
			//键盘管理器
			injector.map( KeyboardManager ).asSingleton();
			injector.injectInto( injector.getInstance( KeyboardManager ) as KeyboardManager );
			
			//loading界面
			injector.map( LoadingView ).asSingleton();
			injector.injectInto( injector.getInstance( LoadingView ) as LoadingView );
			
			//loading界面2
			injector.map( LoadingView2 ).asSingleton();
			injector.injectInto( injector.getInstance( LoadingView2 ) as LoadingView2 );
			
			//播放器管理器
			injector.map( PlayerManager ).asSingleton();
			injector.injectInto( injector.getInstance( PlayerManager ) as PlayerManager );
			
			//动作处理器映射器
			injector.map( MetaActionHandlerMapper ).asSingleton();
			injector.injectInto( injector.getInstance( MetaActionHandlerMapper ) as MetaActionHandlerMapper );
			
			//动作处理器门户(比如:打开某个文档，这就是一个动作，这个动作被同步到其他客户端之后，其他客户端会根据这个动作做处理)
			injector.map( MetaActionHandlerFacade ).asSingleton();
			injector.injectInto( injector.getInstance( MetaActionHandlerFacade ) as MetaActionHandlerFacade );
			
			//injector.injectInto( injector.getInstance( SessionHandler ) as SessionHandler );
			
			//打开文档
			injector.map( DocOpenHandler ).asSingleton();
			
			//关闭文档
			injector.map( DocCloseHandler ).asSingleton();
			
			//文档翻页
			injector.map( DocPageGotoHandler ).asSingleton();
			
			//文档设置页码
			injector.map( DocSetPageCountHandler ).asSingleton();
			
			//打开媒体
			injector.map( MediaPlayOpenHandler ).asSingleton();
			
			//关闭媒体
			injector.map( MediaPlayCloseHandler ).asSingleton();
			
			//音视频流打开
			injector.map( AVStreamOpenHandler ).asSingleton();
			
			//音视频流关闭
			injector.map( AVStreamCloseHandler ).asSingleton();
			
			//音频流开关
			injector.map( AVStreamToggleAudioHandler ).asSingleton();
			
			//视频流开关
			injector.map( AVStreamToggleVideoHandler ).asSingleton();
			
			//视频流状态改变
			injector.map( AVStreamChangeStateHandler ).asSingleton();
			
			//用户权限发生改变
			injector.map( UserChangeLevelHandler ).asSingleton();
			
			//用户摄像头状态发生改变
			injector.map( UserUpdateHasCamHandler ).asSingleton();
			
			//用户摄像头状态发生改变
			injector.map( UserUpdateHasMicHandler ).asSingleton();
			
			//流播放
			injector.map( MediaPlayHandler ).asSingleton();
			
			//媒体发布
			injector.map( MediaPubHandler ).asSingleton();
			
			//流改变声音
			injector.map( MediaPlayChangeVolumeHandler ).asSingleton();
			
			//流暂停播放
			injector.map( MediaPlayTogglePauseHandler ).asSingleton();
			
			//流seek
			injector.map( MediaPlaySeekHandler ).asSingleton();
			
			//房间增加、删除发布流
			injector.map( RoomAddDelAVItemHandler ).asSingleton();
			
			//房间增加、删除发布流请求
			injector.map( RoomAddDelAVReqHandler ).asSingleton();
			
			//画线开始
			injector.map( DocLineStartHandler ).asSingleton();
			
			//画线中
			injector.map( DocLineAddPointHandler ).asSingleton();
			
			//画线结束
			injector.map( DocLineEndHandler ).asSingleton();
			
			//新建文本
			injector.map( DocTextChangePositionHandler ).asSingleton();
			
			//改变文本内容
			injector.map( DocTextChangeTextHandler ).asSingleton();
			
			//房间对象擦除
			injector.map( RoomObjectPurgeHandler ).asSingleton();
			
			//房间配置改变
			injector.map(RoomChangeConfigHandler).asSingleton();

			//冻结层(在进行某些高密度的计算时，为了防止用户的无意义操作而造成的干扰而采取的折中限制)
			injector.map( FrozenLayer ).asSingleton();
			
			//文件上传管理器
			injector.map( FileUploadManager ).asSingleton();
			
			//面板工厂
			injector.map( PanelFactory ).asSingleton();
			injector.injectInto( injector.getInstance( PanelFactory ) as PanelFactory );
			
			//面板管理器
			injector.map( PanelManager ).toValue( PanelManager.getInstance() );
			injector.injectInto( injector.getInstance( PanelManager ) as PanelManager );
			
			//php通信相关
			injector.map( WebServerManager ).asSingleton();
			injector.injectInto( injector.getInstance( WebServerManager ) as WebServerManager );
			
			//表情动画加载器
			injector.map( FaceLoader ).asSingleton();
			injector.injectInto( injector.getInstance( FaceLoader ) as FaceLoader );

			//普通文档数据管理中心
			injector.map( DocxDataCenter ).asSingleton();
			injector.injectInto( injector.getInstance( DocxDataCenter ) as DocxDataCenter );
			
			//PPT动画文档数据管理中心
			injector.map( PPTDataCenter ).asSingleton();
			injector.injectInto( injector.getInstance( PPTDataCenter ) as PPTDataCenter );
			
			//视频数据管理中心
			injector.map( VideoDataCenter ).asSingleton();
			injector.injectInto( injector.getInstance( VideoDataCenter ) as VideoDataCenter );
			
			//音频数据管理中心
			injector.map( AudioDataCenter ).asSingleton();
			injector.injectInto( injector.getInstance( AudioDataCenter ) as AudioDataCenter );
			
			//图片数据管理中心
			injector.map( IMGDataCenter ).asSingleton();
			injector.injectInto( injector.getInstance( IMGDataCenter ) as IMGDataCenter );
			
			//资源工厂
			injector.map( AssetsFactory ).toValue(AssetsFactory.getInstance());
			injector.injectInto( injector.getInstance( AssetsFactory ) as AssetsFactory );
			
			//资源管理器
			injector.map( AssetsLoader ).asSingleton();
			injector.injectInto( injector.getInstance( AssetsLoader ) as AssetsLoader );

			//用户列表消息管理器
			injector.map( UserListMsgManager ).asSingleton();
			injector.injectInto( injector.getInstance( UserListMsgManager ) as UserListMsgManager );
			
			//UI管理器
			injector.map( UIManager ).asSingleton();
			injector.injectInto( injector.getInstance( UIManager ) as UIManager );
			
			//主讲界面布局管理器
			injector.map( MasterLayoutDirector ).asSingleton();
			injector.injectInto( injector.getInstance( MasterLayoutDirector ) as MasterLayoutDirector );
			
			//学生界面布局管理器
			injector.map( StudentLayoutDirector ).asSingleton();
			injector.injectInto( injector.getInstance( StudentLayoutDirector ) as StudentLayoutDirector );
			
			//主讲文档播放器布局区域
			injector.map( MasterPlayerLayout ).asSingleton();
			injector.injectInto( injector.getInstance( MasterPlayerLayout ) as MasterPlayerLayout );
			
			//学生文档播放器布局区域
			injector.map( StudentPlayerLayout ).asSingleton();
			injector.injectInto( injector.getInstance( StudentPlayerLayout ) as StudentPlayerLayout );
			
			//主讲文档播放器管理器
			injector.map( MasterPlayerManager ).asSingleton();
			injector.injectInto( injector.getInstance( MasterPlayerManager ) as MasterPlayerManager );
			
			//学生文档播放器管理器
			injector.map( StudentPlayerManager ).asSingleton();
			injector.injectInto( injector.getInstance( StudentPlayerManager ) as StudentPlayerManager );
			
			//主讲音频播放器管理器
			injector.map( MasterAudioPlayerManager ).asSingleton();
			injector.injectInto( injector.getInstance( MasterAudioPlayerManager ) as MasterAudioPlayerManager );
			
			//学生音频播放器管理器
			injector.map( NormalAudioPlayerManager ).asSingleton();
			injector.injectInto( injector.getInstance( NormalAudioPlayerManager ) as NormalAudioPlayerManager );
			
			//主讲MP4播放器管理器
			injector.map( MasterVideoPlayerManager ).asSingleton();
			injector.injectInto( injector.getInstance( MasterVideoPlayerManager ) as MasterVideoPlayerManager );
			
			//学生MP4播放器管理器
			injector.map( StudentVideoPlayerManager ).asSingleton();
			injector.injectInto( injector.getInstance( StudentVideoPlayerManager ) as StudentVideoPlayerManager );
			
			//界面布局元素工厂
			injector.map( LayoutElementsFactory ).asSingleton();
			injector.injectInto( injector.getInstance( LayoutElementsFactory ) as LayoutElementsFactory );
			
			//rpc
			injector.map( RPCClientImpl ).asSingleton();
			injector.injectInto( injector.getInstance( RPCClientImpl ) as RPCClientImpl );
			
			injector.injectInto( injector.getInstance( MediaPubHandler ) as MediaPubHandler );
			
			//信令处理器
			injector.map( SessionHandler ).asSingleton();
			injector.injectInto( injector.getInstance( SessionHandler ) as SessionHandler );
			
			//网络通信与界面表现的中间层
			injector.map( NetworkFacade ).asSingleton();
			injector.injectInto( injector.getInstance( NetworkFacade ) as NetworkFacade );

			//设备管理器
			//injector.map( DeviceFacade ).asSingleton();
			//injector.injectInto( injector.getInstance( DeviceFacade ) as DeviceFacade );
			
			//登陆数据缓存
			injector.map( LoginVoCache ).asSingleton();
			injector.injectInto( injector.getInstance( LoginVoCache ) as LoginVoCache );
			
			//绘图层数据缓存中心
			injector.map( CanvasManager ).asSingleton();
			injector.injectInto( injector.getInstance( CanvasManager ) as CanvasManager );
			
			injector.injectInto( injector.getInstance( DocOpenHandler ) as DocOpenHandler );
			injector.injectInto( injector.getInstance( DocPageGotoHandler ) as DocPageGotoHandler );
			injector.injectInto( injector.getInstance( DocSetPageCountHandler ) as DocSetPageCountHandler );
			injector.injectInto( injector.getInstance( DocCloseHandler ) as DocCloseHandler );
			
			injector.injectInto( injector.getInstance( AVStreamOpenHandler ) as AVStreamOpenHandler );
			injector.injectInto( injector.getInstance( AVStreamCloseHandler ) as AVStreamCloseHandler );
			injector.injectInto( injector.getInstance( AVStreamToggleAudioHandler ) as AVStreamToggleAudioHandler );
			injector.injectInto( injector.getInstance( AVStreamToggleVideoHandler ) as AVStreamToggleVideoHandler );
			injector.injectInto( injector.getInstance( AVStreamChangeStateHandler ) as AVStreamChangeStateHandler );
			
			injector.injectInto( injector.getInstance( UserChangeLevelHandler ) as UserChangeLevelHandler );
			injector.injectInto( injector.getInstance( UserUpdateHasCamHandler ) as UserUpdateHasCamHandler );
			injector.injectInto( injector.getInstance( UserUpdateHasMicHandler ) as UserUpdateHasMicHandler );
			
			injector.injectInto( injector.getInstance( MediaPlayOpenHandler ) as MediaPlayOpenHandler );
			injector.injectInto( injector.getInstance( MediaPlayCloseHandler ) as MediaPlayCloseHandler );
			injector.injectInto( injector.getInstance( MediaPlayChangeVolumeHandler ) as MediaPlayChangeVolumeHandler );
			injector.injectInto( injector.getInstance( MediaPlayTogglePauseHandler ) as MediaPlayTogglePauseHandler );
			injector.injectInto( injector.getInstance( MediaPlaySeekHandler ) as MediaPlaySeekHandler );
			
			injector.injectInto( injector.getInstance( RoomAddDelAVItemHandler ) as RoomAddDelAVItemHandler );
			injector.injectInto( injector.getInstance( RoomAddDelAVReqHandler ) as RoomAddDelAVReqHandler );
			
			injector.injectInto( injector.getInstance( DocLineStartHandler ) as DocLineStartHandler );
			injector.injectInto( injector.getInstance( DocLineEndHandler ) as DocLineEndHandler );
			injector.injectInto( injector.getInstance( DocLineAddPointHandler ) as DocLineAddPointHandler );
			injector.injectInto( injector.getInstance( DocTextChangePositionHandler ) as DocTextChangePositionHandler );
			injector.injectInto( injector.getInstance( DocTextChangeTextHandler ) as DocTextChangeTextHandler );
			injector.injectInto( injector.getInstance( RoomObjectPurgeHandler ) as RoomObjectPurgeHandler );
		}
		
	}

}