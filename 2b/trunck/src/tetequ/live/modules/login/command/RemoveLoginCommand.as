package tetequ.live.modules.login.command 
{
	import framework.view.UIRoot;
	import robotlegs.bender.bundles.mvcs.Command;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class RemoveLoginCommand extends Command 
	{
		[Inject]
		public var uiroot:UIRoot;
		
		public function RemoveLoginCommand() 
		{
			super();
			
		}
		
		override public function execute():void
		{
			uiroot.removeAllElements();
		}
		
	}

}