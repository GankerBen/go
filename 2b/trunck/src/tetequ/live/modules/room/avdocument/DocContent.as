package tetequ.live.modules.room.avdocument 
{
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.domUI.layouts.HorizontalLayout;
	import org.flexlite.domUI.layouts.VerticalAlign;
	import tetequ.live.modules.room.common.GlobalVars;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class DocContent extends Group 
	{
		private var _message:Label;
		private var _logo:UIAsset;
		private var _group:Group;
		
		public function DocContent() 
		{
			super();
			initComponents();
		}
		
		private function initComponents():void 
		{
			this.percentWidth = 100;
			this.percentHeight = 100;
			
			addElement(_group = new Group());
			_group.layout = new HorizontalLayout();
			_group.horizontalCenter = 0;
			_group.verticalCenter = 0;
			
			HorizontalLayout(_group.layout).verticalAlign = VerticalAlign.MIDDLE;
			HorizontalLayout(_group.layout).padding = 0;
			HorizontalLayout(_group.layout).gap = 0;
			
			_group.addElement(_logo = new UIAsset());
			_logo.width = _logo.height = 25;
			
			if(GlobalVars.orgLogoUri)
			{
				getLogo(GlobalVars.orgLogoUri, _logo);
			}
			
			_group.addElement(_message = new Label());
			_message.textColor = 0xffffff;
			_message.text = '没有文档';
			_message.verticalCenter = 0;
			_message.horizontalCenter = 0;
		}
		
	}

}