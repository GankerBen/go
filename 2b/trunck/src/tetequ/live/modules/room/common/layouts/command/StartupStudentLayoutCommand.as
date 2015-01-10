package tetequ.live.modules.room.common.layouts.command 
{
	import flash.events.IEventDispatcher;
	import robotlegs.bender.bundles.mvcs.Command;
	import robotlegs.bender.framework.api.ILogger;
	import tetequ.live.modules.room.common.layouts.events.LayoutElementsInstallEvent;
	import tetequ.live.modules.room.common.layouts.LayoutDirectorType;
	import tetequ.live.modules.room.common.layouts.UIManager;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 启用学生界面布局
	 */
	public class StartupStudentLayoutCommand extends Command 
	{
		[Inject]
		public var uiManager:UIManager;
		
		[Inject]
		public var eventDispatcher:IEventDispatcher;
		
		[Inject]
		public var logger:ILogger;
		
		public function StartupStudentLayoutCommand() 
		{
			super();
			
		}
		
		override public function execute():void
		{
			eventDispatcher.dispatchEvent( new LayoutElementsInstallEvent( LayoutElementsInstallEvent.STUDENT ) );
			uiManager.startupLayout( LayoutDirectorType.STUDENT );
			logger.debug( "现在已经是学生的用户界面了!" );
		}
		
	}

}