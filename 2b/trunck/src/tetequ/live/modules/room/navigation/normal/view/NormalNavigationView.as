package tetequ.live.modules.room.navigation.normal.view 
{
	import org.flexlite.domUI.components.Rect;
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.domUI.layouts.VerticalLayout;
	import org.flexlite.domUI.skins.vector.ButtonSkin;
	import org.flexlite.skin.ContactButtonUSkin;
	import org.flexlite.skin.HelpBtnSkin;
	import org.flexlite.skin.IncPowerButtonSkin;
	import org.flexlite.domUI.components.Button;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.layouts.HorizontalLayout;
	import org.flexlite.skin.SpeechButtonSkin;
	import org.flexlite.skin.UseListButtonSkin;
	import tetequ.live.core.assets.AssetsFactory;
	import tetequ.live.modules.room.common.layouts.LayoutElementsID;
	import tetequ.live.modules.room.navigation.common.view.BaseNavigation;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 导航区域
	 */
	public class NormalNavigationView extends BaseNavigation 
	{
		private var _btnAVReq:UIAsset;

		public function NormalNavigationView() 
		{
			super();
		}
		
		override protected function initComponents():void 
		{
			super.initComponents();
			
			_btnAVReq = new UIAsset();
			_btnAVReq.maintainAspectRatio = true;
			_btnAVReq.mouseChildren = true;
			_btnAVReq.skinName = AssetsFactory.getInstance().getAsset('RecorButtondingSkin');
			_btnAVReq.left = 6;
			_btnAVReq.top = 86;
			addElement( _btnAVReq );
			
			langTipsConfigure(_btnAVReq, '发言/申请发言', 'publish or request publish');
			
			this.id = LayoutElementsID.STUDENT_NAVIGATION;
		}
		
		public function get btnAVReq():UIAsset 
		{
			return _btnAVReq;
		}

	}

}