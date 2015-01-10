package tetequ.live.modules.room.common.layouts.style.master 
{
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Rect;
	import tetequ.live.modules.room.avdocument.AVDocumentManager;
	import tetequ.live.modules.room.common.GlobalVars;
	import tetequ.live.modules.room.common.layouts.LayoutElementsID;
	import tetequ.live.modules.room.common.layouts.style.common.SchemeB;
	import tetequ.live.modules.room.recording.view.RecordingView;
	import tetequ.live.modules.room.userlist.view.UserListView;
	import tetequ.live.utils.HashMap;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 主讲界面布局样式B
	 */
	public class MasterSchemeB extends SchemeB 
	{
		
		public function MasterSchemeB(components:HashMap) 
		{
			super(components);
			
		}
		
		override public function layoutElements():void
		{
			super.layoutElements();
			GlobalVars.document = components.getValue(LayoutElementsID.MASTER_DOCUMENT);
			GlobalVars.document.percentWidth = 100;
			GlobalVars.document.percentHeight = 100;
			GlobalVars.document.horizontalCenter = 0;
			GlobalVars.document.verticalCenter = 0;
			this.contentLayer.addElement(components.getValue(LayoutElementsID.MASTER_NAVIGATION));
			this.contentLayer.addElement(AVDocumentManager.getInstance());
			if(hasChat())
				this.contentLayer.addElement( components.getValue( LayoutElementsID.GROUP_MESSAGE ) );
			this.avReqLayer.addElement( components.getValue( LayoutElementsID.AV_REQ ) );
			this.popupLayer.addElement(UserListView.getInstance());
		}
		
	}

}