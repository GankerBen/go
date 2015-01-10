package tetequ.live.modules.room.navigation.common.command 
{
	import org.flexlite.domUI.components.Alert;
	import robotlegs.bender.bundles.mvcs.Command;
	import tetequ.live.modules.room.common.panel.PanelID;
	import tetequ.live.modules.room.common.panel.PanelManager;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 打开工具面板命令
	 */
	public class OpenToolsCommand extends Command 
	{
		[Inject]
		public var panelManager:PanelManager;
		
		public function OpenToolsCommand() 
		{
			super();
			
		}
		
		override public function execute():void
		{
			//panelManager.openPanel( PanelID.TOOLS );//FIXME:
			Alert.show( "该功能暂未开启，敬请期待!" );
		}
		
	}

}