package tetequ.live.modules.login.view 
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import org.flexlite.domCore.Injector;
	import org.flexlite.domUI.collections.ArrayCollection;
	import org.flexlite.domUI.components.Button;
	import org.flexlite.domUI.components.ComboBox;
	import org.flexlite.domUI.components.DropDownList;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Rect;
	import org.flexlite.domUI.components.TextInput;
	import org.flexlite.domUI.components.ToggleButton;
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.domUI.core.DomGlobals;
	import org.flexlite.domUI.core.Theme;
	import org.flexlite.domUI.events.UIEvent;
	import org.flexlite.domUI.layouts.HorizontalLayout;
	import org.flexlite.domUI.skins.themes.VectorTheme;
	import org.flexlite.domUI.skins.vector.ButtonSkin;
	import org.flexlite.domUI.skins.vector.ComboBoxSkin;
	import org.flexlite.domUI.skins.vector.DropDownListSkin;
	import org.flexlite.domUI.skins.vector.TextInputSkin;
	import org.flexlite.domUI.skins.vector.ToggleButtonSkin;
	import org.flexlite.domUI.skins.vector.TreeDisclosureButtonSkin;
	import org.flexlite.domUI.utils.callLater;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class LoginView extends Group 
	{
		private var _bg:Rect;
		private var _inputName:TextInput;
		private var _inputGroup:Group;
		private var _btnEnter:Button;
		private var _group:Group;
		private var _list:DropDownList;
		private var _roomIdList:DropDownList;
		
		public function LoginView() 
		{
			super();
			initComponents();
		}
		
		private function initComponents():void 
		{
			addElement( _bg = new Rect() );
			_bg.percentWidth = 100;
			_bg.percentHeight = 100;
			_bg.fillColor = 0x000000;
			
			addElement( _group = new Group() );
			_group.horizontalCenter = 0;
			_group.verticalCenter = 0;
			_group.layout = new HorizontalLayout();
			
			Injector.mapClass( Theme, VectorTheme );
			var p:ArrayCollection = new ArrayCollection( [ "主讲", "学生" ] );
			_group.addElement( _list = new DropDownList() );
			_list.skinName = DropDownListSkin;
			_list.dataProvider = p;
			_list.prompt = "权限";
			_list.verticalCenter = 0;
			_list.height = 23;
			
			_group.addElement( _roomIdList = new DropDownList() );
			_roomIdList.skinName = DropDownListSkin;
			var p2:ArrayCollection = new ArrayCollection(['za', 'zb', 'zc', 'dummy']);
			_roomIdList.dataProvider = p2;
			_roomIdList.prompt = "房间号";
			_list.verticalCenter = 0;
			_roomIdList.height = 23;
			
			
			_group.addElement(_inputGroup = new Group());
			var bg:Rect = new Rect();
			bg.fillColor = 0x555555;
			bg.percentWidth = 100;
			bg.height = 23;
			_inputGroup.addElement(bg);
			
			_inputGroup.addElement( _inputName = new TextInput() );
			_inputName.skinName = TextInputSkin;
			_inputName.verticalCenter = 0;
			_inputName.prompt = "用户名";
			_inputName.maxChars = 20;
			_inputName.width = 100;
			_inputName.textColor = 0xffffff;
			//_inputName.restrict = "abcdefghijklmnopqrstuvwxyz0123456789";
			
			_group.addElement( _btnEnter = new Button() );
			_btnEnter.skinName = ButtonSkin;
			_btnEnter.label = "确定";
			_btnEnter.verticalCenter = 0;
			
			this.percentWidth = 100;
			this.percentHeight = 100;
			this.horizontalCenter = 0;
			this.verticalCenter = 0;
			
			//_ldr = new Loader();
			//_ldr.load(new URLRequest("app/web/assets/uilib/logo_animation.swf"));
			//_ldr.contentLoaderInfo.addEventListener( Event.COMPLETE, onLoaded );
		}
		
		//private var _ldr:Loader;
		//private var skin:UIAsset;
		//private function onLoaded(e:Event):void 
		//{
			//_ldr.contentLoaderInfo.removeEventListener( Event.COMPLETE, onLoaded );
			//skin = new UIAsset();
			//skin.skinName = _ldr;
			//skin.maintainAspectRatio = true;
			//skin.width = 50;
			//DomGlobals.stage.addEventListener( Event.RESIZE, onResize );
			//this.addElement( skin );
			//callLater(onResize,[null]);
		//}
		
		//private function onResize(e:Event):void 
		//{
			//skin.x = ((DomGlobals.stage.stageWidth - skin.width) >> 1) - 120;
			//skin.y = ((DomGlobals.stage.stageHeight - skin.height) >> 1) - 150;
		//}
		
		public function get input():String
		{
			return _inputName.text;
		}
		
		public function get btnEnter():Button 
		{
			return _btnEnter;
		}
		
		public function get list():DropDownList 
		{
			return _list;
		}
		
		public function get roomIdList():DropDownList 
		{
			return _roomIdList;
		}
		
	}

}