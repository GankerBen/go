package tetequ.live.modules.loading.command 
{
	import framework.view.UIRoot;
	import robotlegs.bender.bundles.mvcs.Command;
	import tetequ.live.modules.loading.view.LoadingView;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 移除loading界面
	 */
	public class RemoveLoadingCommand extends Command 
	{
		[Inject]
		public var container:UIRoot;
		
		[Inject]
		public var loadingView:LoadingView;
		
		public function RemoveLoadingCommand() 
		{
			super();
			
		}
		
		override public function execute():void
		{
			if ( container.containsElement( loadingView ) )
			{
				container.removeElement( loadingView );
			}
		}
		
	}

}