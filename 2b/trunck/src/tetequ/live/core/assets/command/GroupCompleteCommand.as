package tetequ.live.core.assets.command 
{
	import flash.events.IEventDispatcher;
	import framework.view.UIRoot;
	import org.flexlite.domUI.components.UIAsset;
	import robotlegs.bender.bundles.mvcs.Command;
	import robotlegs.bender.framework.api.ILogger;
	import tetequ.live.core.assets.AssetsFactory;
	import tetequ.live.core.assets.events.GroupCompleteEvent;
	import tetequ.live.core.network.events.MapMetaActionToHandlerEvent;
	import tetequ.live.modules.loading.events.RemoveLoadingEvent;
	import tetequ.live.modules.loading.events.ShowLoadingEvent;
	import tetequ.live.core.network.events.ConnectServerEvent;
	import tetequ.live.modules.loading.view.LoadingView;
	import tetequ.live.modules.loading.view.LoadingView2;
	import tetequ.live.modules.login.events.ShowLoginEvent;
	import tetequ.live.modules.login.model.LoginVoCache;
	import tetequ.live.modules.room.chat.common.face.FaceFactory;
	import tetequ.live.modules.room.chat.common.face.FaceLoader;
	import tetequ.live.modules.room.common.GlobalVars;
	import tetequ.live.modules.room.common.layouts.events.LayoutDirectorRegisterEvent;
	import tetequ.live.modules.room.common.layouts.events.StartupLayoutEvent;
	import tetequ.live.modules.room.common.panel.events.RegisterPanelClassEvent;
	
	/**
	 * ...
	 * @author pandazhong
	 * 资源组加载完毕触发的命令
	 */
	public class GroupCompleteCommand extends Command 
	{
		[Inject]
		public var logger:ILogger;
		
		[Inject]
		public var event:GroupCompleteEvent;
		
		[Inject]
		public var eventDispatcher:IEventDispatcher;

		[Inject]
		public var loading2:LoadingView2;
		
		[Inject]
		public var faceLoader:FaceLoader;

		[Inject]
		public var loginVoCache:LoginVoCache;
		
		public function GroupCompleteCommand() 
		{
			super();
		}
		
		override public function execute():void
		{
			switch( event.groupName ) {
				//assets.swf加载完毕
				case "assets":
					loading2.init();
					browserLog('开始加载表情素材...');
					faceLoader.loadAllFace();
					break;
					//表情加载完毕
				case 'face':
					browserLog('表情素材加载完毕...');
					FaceFactory.getInstance().registerRawAnimations(faceLoader.faceAnimations);
					
					if (loginVoCache.cache)
					{
						browserLog('开始连接服务器...');
						eventDispatcher.dispatchEvent( new ConnectServerEvent( loginVoCache.cache, ConnectServerEvent.CONNECT_SERVER ) );
					}else
					{
						browserLog('显示登录框...');
						eventDispatcher.dispatchEvent( new ShowLoginEvent() );
					}
					break;
				default:
					break;
			}
		}
	}
}