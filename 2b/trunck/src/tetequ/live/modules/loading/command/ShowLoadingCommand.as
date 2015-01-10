package tetequ.live.modules.loading.command 
{
	import framework.view.UIRoot;
	import robotlegs.bender.bundles.mvcs.Command;
	import robotlegs.bender.framework.api.ILogger;
	import tetequ.live.modules.loading.view.LoadingView;
	
	/**
	 * ...
	 * @author pandazhong
	 * 显示loading界面
	 */
	public class ShowLoadingCommand extends Command 
	{
		[Inject]
		public var logger:ILogger;
		
		[Inject]
		public var loadingView:LoadingView;
		
		[Inject]
		public var uiContainer:UIRoot;
		
		public function ShowLoadingCommand() 
		{
			super();	
		}
		
		override public function execute():void
		{
			logger.debug( "显示loading界面" );
			uiContainer.addElement( loadingView );
		}
		
	}

}