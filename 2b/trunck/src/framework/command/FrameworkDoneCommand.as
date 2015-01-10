package framework.command 
{
	import flash.events.IEventDispatcher;
	import framework.events.FrameworkEvent;
	import robotlegs.bender.bundles.mvcs.Command;
	
	/**
	 * ...
	 * @author pandazhong
	 */
	public class FrameworkDoneCommand extends Command 
	{
		[Inject]
		public var eventDispatcher:IEventDispatcher;
		
		public function FrameworkDoneCommand() 
		{
			super();	
		}
		
		override public function execute():void
		{
			eventDispatcher.dispatchEvent( new FrameworkEvent( FrameworkEvent.APPLICATION_STARTUP ) );
		}
		
	}

}