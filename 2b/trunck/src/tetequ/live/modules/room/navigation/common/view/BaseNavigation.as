package tetequ.live.modules.room.navigation.common.view
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import org.flexlite.domUI.components.Button;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.components.Rect;
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.domUI.layouts.HorizontalAlign;
	import org.flexlite.domUI.layouts.VerticalAlign;
	import org.flexlite.domUI.layouts.VerticalLayout;
	import org.flexlite.skin.SharingButtpmSkin;
	import org.flexlite.skin.ToolButtonSkin;
	import org.flexlite.skin.UseListButtonSkin;
	import tetequ.live.core.assets.AssetsFactory;
	import tetequ.live.modules.room.common.GlobalVars;
	import tetequ.live.modules.room.tools.view.ToolsView;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 导航栏基类
	 * 包含背景区域与边线
	 */
	public class BaseNavigation extends Group 
	{
		protected var background:Rect;
		protected var line:Rect;
		protected var buttonGroup:Group;
		
		protected var _logo:UIAsset;
		protected var _orgName:Label;
		protected var _logoGroup:Group;
		
		protected var _topGroup:Group;
		
		protected var _line2:Rect;
		
		/**
		 * 系统设置
		 */
		private var _btnSysSettings:UIAsset;
		
		public function BaseNavigation() 
		{
			super();
			initComponents();
		}
		
		protected function initComponents():void 
		{
			addElement(background = new Rect());
			background.percentWidth = 100;
			background.percentHeight = 100;
			background.fillColor = 0x666666;
			//background.fillColor = 0x002a4c;
			background.fillAlpha = 0.5;
			
			addElement(line = new Rect());
			line.width = 1;
			line.left = 60;
			line.percentHeight = 100;
			line.fillColor = 0x888888;

			addElement(_topGroup = new Group());
			_topGroup.layout = new VerticalLayout();
			_topGroup.horizontalCenter = 0;
			_topGroup.top = 10;
			VerticalLayout(_topGroup.layout).horizontalAlign = HorizontalAlign.CENTER;
			
			_topGroup.addElement(_logoGroup = new Group());
			_logoGroup.horizontalCenter = 0;
			_logoGroup.layout = new VerticalLayout();
			VerticalLayout(_logoGroup.layout).gap = 0;
			VerticalLayout(_logoGroup.layout).horizontalAlign = HorizontalAlign.CENTER;

			_logoGroup.addElement(_logo = new UIAsset());
			_logo.mouseChildren = true;
			_logo.mouseEnabled = true;
			_logo.width = 36;
			_logo.height = 36;
			if(GlobalVars.orgLogoUri)
				getLogo(GlobalVars.orgLogoUri, _logo);
			_logo.addEventListener(MouseEvent.CLICK, changeBg);
			
			_logoGroup.addElement(_orgName = new Label());
			_orgName.textColor = 0xFFFFFF;
			_orgName.text = GlobalVars.orgName;
			
			_logoGroup.addElement(_line2 = new Rect());
			_line2.percentWidth = 100;
			_line2.height = 1;
			_line2.fillColor = 0x888888;
			
			langTipsConfigure(_logo, '换个背景试试', 'change background image');
			
			_topGroup.addElement( buttonGroup = new Group() );
			buttonGroup.horizontalCenter = 0;
			buttonGroup.layout = new VerticalLayout();
			VerticalLayout(buttonGroup.layout).gap = 23;
			
			VerticalLayout(buttonGroup.layout).paddingTop = 13;
			VerticalLayout(buttonGroup.layout).paddingLeft = 4;
			
			_btnSysSettings = new UIAsset();
			_btnSysSettings.maintainAspectRatio = true;
			_btnSysSettings.mouseChildren = true;
			_btnSysSettings.skinName = AssetsFactory.getInstance().getAsset("SetUpSkin");

			
			langTipsConfigure(_btnSysSettings, '系统设置', 'System settings');
			
			_btnSysSettings.bottom = 25;
			_btnSysSettings.left = 8;
			addElement ( _btnSysSettings );
			this.width = 60;
			this.horizontalCenter = 0;
			this.percentHeight = 100;
		}
		
		private var _totalBg:int = 2;
		private var _bgs:Vector.<Class>;
		private var _index:int = 0;
		private function changeBg(e:MouseEvent):void 
		{
			if (!_bgs)
			{
				_index = 0;
				_bgs = new Vector.<Class>;
				while (_totalBg>0)
				{
					trace("bgindex", _totalBg);
					_bgs.push(AssetsFactory.getInstance().getAsset('back' + _totalBg));
					_totalBg--;
				}
				
				_totalBg = 2;
				GlobalVars.scene.skinName = _bgs[_index];
			}else
			{
				_index++;
				if (_index == _totalBg)
					_index = 0;
				trace('_index', _index);
				GlobalVars.scene.skinName = _bgs[_index];
			}
		}
		
		public function get btnSysSettings ():UIAsset
		{
			return _btnSysSettings;
		}
	}
}