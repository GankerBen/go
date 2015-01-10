package tetequ.live.core.network.command 
{
	import flash.events.IEventDispatcher;
	import framework.view.UIRoot;
	import robotlegs.bender.bundles.mvcs.Command;
	import robotlegs.bender.extensions.contextView.ContextView;
	import robotlegs.bender.framework.api.ILogger;
	import tetequ.live.core.network.events.ConnectServerEvent;
	import tetequ.live.core.network.NetworkFacade;
	import tetequ.live.modules.loading.view.LoadingView;
	import tetequ.live.modules.room.common.GlobalVars;
	
	/**
	 * ...
	 * @author pandazhong
	 * 连接服务器命令
	 */
	public class ConnectServerCommand extends Command 
	{
		[Inject]
		public var loadingView:LoadingView;
		
		[Inject]
		public var eventDispatcher:IEventDispatcher;
		
		[Inject]
		public var uiroot:UIRoot;
		
		[Inject]
		public var networkFacade:NetworkFacade;
		
		[Inject]
		public var contextView:ContextView;
		
		[Inject]
		public var logger:ILogger;
		
		[Inject]
		public var event:ConnectServerEvent;
		
		public function ConnectServerCommand()
		{
			super();
		}
		
		override public function execute():void
		{
			uiroot.addElement( loadingView );
			//初始化Session
			networkFacade.init( event.loginVo.userid, 
								event.loginVo.username, 
								event.loginVo.roomid, 
								event.loginVo.userlevel );
		}
	}
}