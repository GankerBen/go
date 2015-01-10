package tetequ.live.modules.room.common.keyboard.command 
{
	import robotlegs.bender.bundles.mvcs.Command;
	import robotlegs.bender.extensions.contextView.ContextView;
	import tetequ.live.modules.room.common.keyboard.KeyboardManager;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class KeyboardManagerInitCommand extends Command 
	{
		[Inject]
		public var cv:ContextView;
		
		[Inject]
		public var km:KeyboardManager;
		
		public function KeyboardManagerInitCommand() 
		{
			super();
			
		}
		
		override public function execute():void
		{
			km.initStage( cv.view.stage );
		}
		
	}

}