package tetequ.live.modules.room.common.layouts.command 
{
	import robotlegs.bender.bundles.mvcs.Command;
	import robotlegs.bender.framework.api.ILogger;
	import tetequ.live.modules.room.chat.input.view.GroupChatInputView;
	import tetequ.live.modules.room.common.layouts.LayoutDirectorType;
	import tetequ.live.modules.room.common.layouts.LayoutElementsID;
	import tetequ.live.modules.room.common.layouts.StudentLayoutDirector;
	import tetequ.live.modules.room.doc.players.common.MasterPlayerLayout;
	import tetequ.live.modules.room.doc.players.common.StudentPlayerLayout;
	import tetequ.live.modules.room.navigation.normal.view.NormalNavigationView;
	import tetequ.live.mutable.LayoutElementsFactory;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 学生界面布局元素注册
	 */
	public class StudentLayoutElementsInstallCommand extends Command 
	{
		[Inject]
		public var studentLayoutDirector:StudentLayoutDirector;
		
		[Inject]
		public var studentPlayerLayout:StudentPlayerLayout;
		
		[Inject]
		public var masterPlayerLayout:MasterPlayerLayout;
		
		[Inject]
		public var logger:ILogger;
		
		[Inject]
		public var factory:LayoutElementsFactory;
		
		public function StudentLayoutElementsInstallCommand() 
		{
			super();
			
		}
		
		override public function execute():void
		{
			if ( !factory.initialized )
				factory.registerAll();
			studentLayoutDirector.registerElement( LayoutElementsID.GROUP_CHAT_INPUT, factory.getInstance( LayoutElementsID.GROUP_CHAT_INPUT ) );
			//studentLayoutDirector.registerElement( LayoutElementsID.USER_LIST, factory.getInstance( LayoutElementsID.USER_LIST ) );
			studentLayoutDirector.registerElement( LayoutElementsID.GROUP_MESSAGE, factory.getInstance( LayoutElementsID.GROUP_MESSAGE ) );
			//studentLayoutDirector.registerElement( LayoutElementsID.MASTER_MEDIA, factory.getInstance( LayoutElementsID.MASTER_MEDIA ) );
			studentLayoutDirector.registerElement( LayoutElementsID.STUDENT_NAVIGATION, factory.getInstance( LayoutElementsID.STUDENT_NAVIGATION ) );
			studentLayoutDirector.registerElement( LayoutElementsID.MASTER_DOCUMENT, masterPlayerLayout );
			//studentLayoutDirector.registerElement( LayoutElementsID.STUDENT_AD, factory.getInstance( LayoutElementsID.STUDENT_AD ) );
			//studentLayoutDirector.registerElement( LayoutElementsID.AV_FULLSCREEN, factory.getInstance( LayoutElementsID.AV_FULLSCREEN ) );
			studentLayoutDirector.layoutElements();
			logger.debug( "学生界面布局元素安装完成!" );

		}
		
	}

}