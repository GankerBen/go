package tetequ.live.modules.login.command 
{
	import framework.view.UIRoot;
	import robotlegs.bender.bundles.mvcs.Command;
	import tetequ.live.modules.login.view.LoginView;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class ShowLoginCommand extends Command 
	{
		[Inject]
		public var uiroot:UIRoot;
		
		public function ShowLoginCommand() 
		{
			super();
			
		}
		
		override public function execute():void
		{
			uiroot.removeAllElements();
			uiroot.addElement( new LoginView() );
		}
	}

}