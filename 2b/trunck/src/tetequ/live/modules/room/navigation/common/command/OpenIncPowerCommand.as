package tetequ.live.modules.room.navigation.common.command 
{
	import org.flexlite.domUI.components.Alert;
	import robotlegs.bender.bundles.mvcs.Command;
	import tetequ.live.core.network.NetworkFacade;
	import tetequ.live.modules.room.common.panel.PanelID;
	import tetequ.live.modules.room.common.panel.PanelManager;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 提升权限
	 */
	public class OpenIncPowerCommand extends Command 
	{
		[Inject]
		public var networkFacade:NetworkFacade;
		
		[Inject]
		public var panelManager:PanelManager;
		
		public function OpenIncPowerCommand() 
		{
			super();
			
		}
		
		override public function execute():void
		{
			//Alert.show( "该功能正在内测中，敬请期待..." ); return;//FIXME:学生升级主讲后，相关界面变化比较复杂，暂时不实现该功能。
			panelManager.openPanel( PanelID.INC_POWER );
		}
	}

}