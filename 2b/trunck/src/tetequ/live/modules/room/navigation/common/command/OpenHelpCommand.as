package tetequ.live.modules.room.navigation.common.command 
{
	import org.flexlite.domUI.components.Alert;
	import robotlegs.bender.bundles.mvcs.Command;
	import tetequ.live.modules.room.common.panel.PanelID;
	import tetequ.live.modules.room.common.panel.PanelManager;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 打开帮助面板命令
	 */
	public class OpenHelpCommand extends Command 
	{
		[Inject]
		public var panelManager:PanelManager;
		
		public function OpenHelpCommand() 
		{
			super();
			
		}
		
		override public function execute():void
		{
			//panelManager.openPanel( PanelID.HELP );//FIXME:
			Alert.show( "该功能暂未开启，敬请期待!" );
		}
	}

}