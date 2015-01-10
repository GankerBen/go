package tetequ.live.modules.room.chat.input.command 
{
	import org.flexlite.domUI.components.Alert;
	import robotlegs.bender.bundles.mvcs.Command;
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class OpenFacePanelCommand extends Command
	{
		
		public function OpenFacePanelCommand() 
		{
			super();
		}
		
		override public function execute():void
		{
			//FIXME:
			Alert.show( "该功能暂未开启，敬请期待!" );
		}
		
	}

}