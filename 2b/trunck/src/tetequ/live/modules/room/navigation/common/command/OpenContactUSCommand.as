package tetequ.live.modules.room.navigation.common.command 
{
	import flash.events.IEventDispatcher;
	import org.flexlite.domUI.components.Alert;
	import robotlegs.bender.bundles.mvcs.Command;
	import tetequ.live.core.network.NetworkFacade;
	import tetequ.live.modules.room.common.layouts.events.StartupLayoutEvent;
	import tetequ.live.modules.room.common.panel.PanelID;
	import tetequ.live.modules.room.common.panel.PanelManager;
	import tetequ.live.modules.room.doc.players.common.MasterPlayerManager;
	import tetequ.live.modules.room.doc.players.common.StudentPlayerManager;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 打开’联系我们‘面板命令
	 */
	public class OpenContactUSCommand extends Command 
	{
		[Inject]
		public var panelManager:PanelManager;
		
		[Inject]
		public var eventDispatcher:IEventDispatcher;
		
		[Inject]
		public var networkFacade:NetworkFacade;
		
		[Inject]
		public var mPlayerManager:MasterPlayerManager;
		
		[Inject]
		public var sPlayerManager:StudentPlayerManager;
		
		public function OpenContactUSCommand() 
		{
			super();
			
		}
		
		override public function execute():void
		{
			panelManager.openPanel( PanelID.CONTACT_US );
			//Alert.show( "你被管理员降级为小学生:(" );
			//debug，降级为学生
			
			//mPlayerManager.closeCurPlayer();
			//sPlayerManager.closeCurPlayer();
			//eventDispatcher.dispatchEvent( new StartupLayoutEvent( StartupLayoutEvent.STUDENT ) );
			//
			//networkFacade.changeLevel( 0x70 );
		}
	}

}