package tetequ.live.mutable 
{
	import framework.view.UIRoot;
	import robotlegs.bender.bundles.mvcs.Command;
	import tetequ.live.modules.room.common.panel.PanelFactory;
	import tetequ.live.modules.room.common.panel.PanelID;
	import tetequ.live.modules.room.doc.doclist.view.FileListView;
	//import tetequ.live.modules.room.individuation.setup.view.SystemSettingsView;
	import tetequ.live.modules.room.tools.view.ToolsView;
	import tetequ.live.modules.room.userlist.view.UserListView;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 注册面板类命令
	 */
	public class RegisterPanelCommand extends Command 
	{
		[Inject]
		public var factory:PanelFactory;
		
		[Inject]
		public var uiroot:UIRoot;
		
		public function RegisterPanelCommand() 
		{
			super();
			
		}
		
		override public function execute():void
		{
			//文档列表面板
			factory.registerPanelClass( PanelID.FILE_LIST, FileListView );
			
			//系统设置面板
			//factory.registerPanelClass( PanelID.SYSTEM_SETTINGS, SystemSettingsView );
			
			//用户列表
			//factory.registerPanelClass( PanelID.USER_LIST, UserListView );
		}
		
	}

}