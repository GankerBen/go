package tetequ.live.modules.room.common.layouts.command 
{
	import flash.events.IEventDispatcher;
	import robotlegs.bender.bundles.mvcs.Command;
	import robotlegs.bender.framework.api.ILogger;
	import tetequ.live.modules.room.common.layouts.events.LayoutElementsInstallEvent;
	import tetequ.live.modules.room.common.layouts.LayoutDirectorType;
	import tetequ.live.modules.room.common.layouts.UIManager;
	import tetequ.live.modules.room.common.panel.PanelID;
	import tetequ.live.modules.room.common.panel.PanelManager;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 启用主讲界面布局
	 */
	public class StartupMasterLayoutCommand extends Command 
	{
		[Inject]
		public var uiManager:UIManager;
		
		[Inject]
		public var eventDispatcher:IEventDispatcher;
		
		[Inject]
		public var logger:ILogger;
		
		[Inject]
		public var panelManager:PanelManager;
		
		public function StartupMasterLayoutCommand() 
		{
			super();
			
		}
		
		override public function execute():void
		{
			eventDispatcher.dispatchEvent( new LayoutElementsInstallEvent( LayoutElementsInstallEvent.MASTER ) );
			uiManager.startupLayout( LayoutDirectorType.MASTER );
			//panelManager.openPanel( PanelID.USER_LIST );
			//panelManager.openPanel( PanelID.GROUP_CHAT );
			logger.debug( "现在已经是主讲的用户界面了!" );
		}
		
	}

}