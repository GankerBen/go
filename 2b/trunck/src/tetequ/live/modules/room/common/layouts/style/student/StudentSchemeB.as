package tetequ.live.modules.room.common.layouts.style.student 
{
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Rect;
	import tetequ.live.modules.room.avdocument.AVDocumentManager;
	import tetequ.live.modules.room.common.GlobalVars;
	import tetequ.live.modules.room.common.layouts.LayoutElementsID;
	import tetequ.live.modules.room.common.layouts.style.common.SchemeB;
	import tetequ.live.modules.room.userlist.view.UserListView;
	import tetequ.live.utils.HashMap;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class StudentSchemeB extends SchemeB 
	{
		
		public function StudentSchemeB(components:HashMap) 
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
			this.contentLayer.addElement(components.getValue(LayoutElementsID.STUDENT_NAVIGATION));
			this.contentLayer.addElement(AVDocumentManager.getInstance());
			if(hasChat())
				this.contentLayer.addElement( components.getValue( LayoutElementsID.GROUP_MESSAGE ) );
			this.popupLayer.addElement(UserListView.getInstance());
		}
		
	}

}