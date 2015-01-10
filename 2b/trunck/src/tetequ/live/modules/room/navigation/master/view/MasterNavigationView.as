package tetequ.live.modules.room.navigation.master.view 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import org.flexlite.domUI.components.Rect;
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.domUI.layouts.VerticalLayout;
	import org.flexlite.domUI.skins.vector.ButtonSkin;
	import org.flexlite.skin.ContactButtonUPSsSkin;
	import org.flexlite.skin.ContactButtonUSkin;
	import tetequ.live.modules.room.common.button.AssetUnit;
	import tetequ.live.modules.room.common.GlobalVars;
	//import org.flexlite.skin.DocumentButtons9Skin;
	import org.flexlite.skin.DocumentButtonSkin;
	import org.flexlite.skin.DocumentButtonsSkin;
	import org.flexlite.skin.GetTokenButtonSkin;
	import org.flexlite.skin.HelpBtnSkin;
	import org.flexlite.skin.HelpButtonsSkin;
	import org.flexlite.skin.IncPowerButtonSkin;
	//import org.flexlite.skin.RecorButtonding9Skin;
	import org.flexlite.skin.RecorButtondingSkin;
	import org.flexlite.skin.RecordButtonSkin;
	import org.flexlite.skin.SetUpSkin;
	//import org.flexlite.skin.SpeechButton9Skin;
	import org.flexlite.skin.SpeechButtonSkin;
	import org.flexlite.skin.StopRcordingSkin;
	import org.flexlite.skin.SystemSettingButtonSkin; 
	import org.flexlite.skin.ToolButtonSkin;
	import org.flexlite.skin.ToolsButtonSkin;
	import org.flexlite.domUI.components.Button;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.layouts.HorizontalLayout;
	import org.flexlite.skin.UseListButtonSkin;
	import tetequ.live.core.assets.AssetsFactory;
	import tetequ.live.modules.room.common.layouts.LayoutElementsID;
	import tetequ.live.modules.room.navigation.common.view.BaseNavigation;
	import tetequ.live.modules.room.tools.view.ToolsView;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 导航区域
	 */
	public class MasterNavigationView extends BaseNavigation 
	{
		/**
		 * 文档按钮
		 */
		private var _btnDocument:AssetUnit;

		/**
		 * 抢令牌
		 */
		private var _btnToken:AssetUnit;

		/**
		 * 同时使用摄像头+麦克风发言
		 */
		private var _btnCamPublish:AssetUnit;
		
		/**
		 * 录制
		 */
		private var _btnRecord:AssetUnit;
		
		/**
		 * 上课
		 */
		private var _btnShangKe:AssetUnit;
		
		/**
		 * 下课
		 */
		private var _btnXiaKe:AssetUnit;

		/**
		 * 构造函数
		 */
		public function MasterNavigationView() 
		{
			super();
		}
		
		override protected function initComponents():void 
		{
			super.initComponents();
			
			_btnDocument = new AssetUnit("DocumentButtonsSkin", true);
			_btnCamPublish = new AssetUnit("RecorButtondingSkin", true);
			_btnToken = new AssetUnit("GetTokenButtonSkin", true);
			
			_btnToken.bottom = 116;
			_btnToken.left = 8;
			
			_btnRecord = new AssetUnit("record_button", true);
			_btnShangKe = new AssetUnit('shangke_button', true);
			_btnXiaKe = new AssetUnit('xiake_button', true);
			_btnShangKe.visible = false;
			_btnXiaKe.visible = false;
			
			buttonGroup.addElement( _btnCamPublish );
			buttonGroup.addElement( _btnDocument );
			buttonGroup.addElement( _btnRecord );
			
			/**
			 * 三好机构需要上课下课功能
			 * FIXME:此处需要判断是否是三好机构
			 */
			if (GlobalVars.orgName == '三好网')
			{
				buttonGroup.addElement( _btnShangKe );
				_btnShangKe.addEventListener(MouseEvent.CLICK, onShangKe);
				_btnXiaKe.addEventListener(MouseEvent.CLICK, onXiaKe);
			}

			langTipsConfigure(_btnCamPublish, '发言/申请发言', 'publish or request publish' );
			langTipsConfigure(_btnDocument, '文档', 'documents' );
			langTipsConfigure(_btnRecord, '录制视频', 'record video' );
			langTipsConfigure(_btnToken, '成为主讲', 'be master' );
			langTipsConfigure(_btnShangKe, '开始上课', 'start class' );
			langTipsConfigure(_btnXiaKe, '下课', 'end class' );
			
			addElement ( _btnToken );
			
			this.id = LayoutElementsID.MASTER_NAVIGATION;
		}
		
		private function onXiaKe(e:MouseEvent):void 
		{
			dispatchEvent(new Event('xiake'));
		}
		
		private function onShangKe(e:MouseEvent):void 
		{
			buttonGroup.removeElement(_btnShangKe);
			buttonGroup.addElement(_btnXiaKe);
			dispatchEvent(new Event('shangke'));
		}
		
		public function get btnDocument():UIAsset 
		{
			return _btnDocument;
		}

		public function get btnCamPublish():UIAsset 
		{
			return _btnCamPublish;
		}
		
		public function get btnToken():UIAsset 
		{
			return _btnToken;
		}
		
		public function get btnRecord():UIAsset 
		{
			return _btnRecord;
		}
		
		public function get btnShangKe():AssetUnit 
		{
			return _btnShangKe;
		}
		
		public function get btnXiaKe():AssetUnit 
		{
			return _btnXiaKe;
		}

	}

}