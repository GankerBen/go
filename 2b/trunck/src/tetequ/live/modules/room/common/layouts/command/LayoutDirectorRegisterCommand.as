package tetequ.live.modules.room.common.layouts.command 
{
	import org.flexlite.domCore.Injector;
	import org.flexlite.domUI.core.Theme;
	import org.flexlite.domUI.skins.themes.VectorTheme;
	import robotlegs.bender.bundles.mvcs.Command;
	import robotlegs.bender.framework.api.ILogger;
	import tetequ.live.modules.room.common.layouts.LayoutDirectorType;
	import tetequ.live.modules.room.common.layouts.MasterLayoutDirector;
	import tetequ.live.modules.room.common.layouts.StudentLayoutDirector;
	import tetequ.live.modules.room.common.layouts.UIManager;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 注册界面布局管理器
	 */
	public class LayoutDirectorRegisterCommand extends Command 
	{
		[Inject]
		public var uiManager:UIManager;
		
		[Inject]
		public var mLayoutDirector:MasterLayoutDirector;
		
		[Inject]
		public var sLayoutDirector:StudentLayoutDirector;
		
		[Inject]
		public var logger:ILogger;
		
		public function LayoutDirectorRegisterCommand() 
		{
			super();
			
		}
		
		override public function execute():void
		{
			/**
			 * 启用UI框架默认皮肤
			 */
			Injector.mapClass( Theme, VectorTheme );
			
			/**
			 * 主讲界面布局管理器
			 */
			uiManager.registerLayoutDirector( LayoutDirectorType.MASTER, mLayoutDirector );
			
			/**
			 * 学生界面布局管理器
			 */
			uiManager.registerLayoutDirector( LayoutDirectorType.STUDENT, sLayoutDirector );
			
			
			logger.debug( "注册界面布局管理器完成!");
		}
		
	}

}