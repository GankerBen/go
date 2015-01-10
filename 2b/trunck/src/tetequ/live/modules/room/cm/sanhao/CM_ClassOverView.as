package tetequ.live.modules.room.cm.sanhao 
{
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.components.Rect;
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.domUI.layouts.HorizontalLayout;
	import org.flexlite.domUI.layouts.VerticalAlign;
	import tetequ.live.modules.room.common.GlobalVars;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 下课界面
	 */
	public class CM_ClassOverView extends Group 
	{
		private var _bg:Rect;
		private var _msg:Label;
		private var _logo:UIAsset;
		private var _group:Group;
		
		public function CM_ClassOverView(single:SingtonEnforcer) 
		{
			super();
			if (!single)
				throw new Error('please call getInstance');
			initComponents();
		}
		
		private function initComponents():void 
		{
			addElement(_bg = new Rect());
			_bg.fillColor = 0;
			_bg.percentWidth = 100;
			_bg.percentHeight = 100;
			
			addElement(_group = new Group());
			_group.horizontalCenter = 0;
			_group.verticalCenter = 0;
			_group.layout = new HorizontalLayout();
			HorizontalLayout(_group.layout).verticalAlign = VerticalAlign.MIDDLE;
			
			_group.addElement(_logo = new UIAsset());
			_logo.width = 36;
			_logo.height = 36;
			_logo.skinName = GlobalVars.orgLogoUri;
			
			_group.addElement(_msg = new Label());
			_msg.text = '课程已结束，感谢您的参与，请关注我们的最新课程。';
			_msg.textColor = 0xffffff;
			_msg.fontFamily = '微软雅黑';
			
			percentWidth = 100;
			percentHeight = 100;
		}
		
		private static var instance:CM_ClassOverView;
		public static function getInstance():CM_ClassOverView
		{
			return instance = instance || new CM_ClassOverView(new SingtonEnforcer());
		}
		
	}

}

class SingtonEnforcer
{
	
}