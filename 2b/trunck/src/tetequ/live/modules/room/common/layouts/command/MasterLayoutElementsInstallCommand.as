package tetequ.live.modules.room.common.layouts.command 
{
	import robotlegs.bender.bundles.mvcs.Command;
	import robotlegs.bender.framework.api.ILogger;
	import tetequ.live.modules.room.chat.input.view.GroupChatInputView;
	import tetequ.live.modules.room.common.layouts.LayoutDirectorType;
	import tetequ.live.modules.room.common.layouts.LayoutElementsID;
	import tetequ.live.modules.room.common.layouts.MasterLayoutDirector;
	import tetequ.live.modules.room.doc.players.common.MasterPlayerLayout;
	import tetequ.live.modules.room.navigation.master.view.MasterNavigationView;
	import tetequ.live.mutable.LayoutElementsFactory;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 主讲界面布局元素注册
	 */
	public class MasterLayoutElementsInstallCommand extends Command 
	{
		[Inject]
		public var masterLayoutDirector:MasterLayoutDirector;
		
		[Inject]
		public var masterPlayerLayout:MasterPlayerLayout;
		
		[Inject]
		public var logger:ILogger;
		
		[Inject]
		public var factory:LayoutElementsFactory;
		
		public function MasterLayoutElementsInstallCommand() 
		{
			super();
			
		}
		
		override public function execute():void
		{
			if ( !factory.initialized )
				factory.registerAll();
			masterLayoutDirector.registerElement( LayoutElementsID.MASTER_NAVIGATION, factory.getInstance( LayoutElementsID.MASTER_NAVIGATION ) );
			//masterLayoutDirector.registerElement( LayoutElementsID.MASTER_MEDIA, factory.getInstance( LayoutElementsID.MASTER_MEDIA ) );
			masterLayoutDirector.registerElement( LayoutElementsID.GROUP_CHAT_INPUT, factory.getInstance( LayoutElementsID.GROUP_CHAT_INPUT ) );
			//masterLayoutDirector.registerElement( LayoutElementsID.USER_LIST, factory.getInstance( LayoutElementsID.USER_LIST ) );
			masterLayoutDirector.registerElement( LayoutElementsID.GROUP_MESSAGE, factory.getInstance( LayoutElementsID.GROUP_MESSAGE ) );
			masterLayoutDirector.registerElement( LayoutElementsID.MASTER_DOCUMENT, masterPlayerLayout );
			//masterLayoutDirector.registerElement( LayoutElementsID.MASTER_AD, factory.getInstance( LayoutElementsID.MASTER_AD ) );
			masterLayoutDirector.registerElement( LayoutElementsID.AV_REQ, factory.getInstance( LayoutElementsID.AV_REQ ) );
			//masterLayoutDirector.registerElement( LayoutElementsID.AV_FULLSCREEN, factory.getInstance( LayoutElementsID.AV_FULLSCREEN ) );
			masterLayoutDirector.layoutElements();
			logger.debug( "主讲界面布局元素已安装完成!" );
		}
		
	}

}