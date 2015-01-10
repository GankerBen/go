package tetequ.live.modules.room.remotelogin.command 
{
	import framework.view.UIRoot;
	import robotlegs.bender.bundles.mvcs.Command;
	import tetequ.live.modules.room.remotelogin.view.RemoteLoginWarningView;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class RemoteLoginWarningCommand extends Command 
	{
		[Inject]
		public var uiroot:UIRoot;
		
		public function RemoteLoginWarningCommand() 
		{
			super();
			
		}
		
		override public function execute():void
		{
			uiroot.removeAllElements();
			uiroot.addElement( new RemoteLoginWarningView() );
			//TODO:
		}
	}

}