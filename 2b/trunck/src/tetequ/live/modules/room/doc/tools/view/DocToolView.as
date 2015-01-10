package tetequ.live.modules.room.doc.tools.view 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import org.flexlite.domUI.components.Button;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Rect;
	import org.flexlite.domUI.components.supportClasses.ButtonBase;
	import org.flexlite.domUI.components.ToggleButton;
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.domUI.layouts.HorizontalLayout;
	import org.flexlite.domUI.layouts.VerticalLayout;
	import org.flexlite.domUI.skins.vector.ButtonSkin;
	import org.flexlite.domUI.skins.vector.ToggleButtonSkin;
	import org.flexlite.skin.BlackButtonSkin;
	import org.flexlite.skin.DisableButtonSkin;
	import org.flexlite.skin.EraserButtonSkin;
	import org.flexlite.skin.GreenButtonSkin;
	import org.flexlite.skin.PencilButtonSkin;
	import org.flexlite.skin.RedButtonSkin;
	import org.flexlite.skin.TextButtonSkin;
	import tetequ.live.core.assets.AssetsFactory;
	import tetequ.live.modules.room.common.drag.DragManagerLite;
	import tetequ.live.modules.room.common.GlobalVars;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 文档工具：铅笔、文本、橡皮擦、画笔粗细、颜色
	 */
	public class DocToolView extends Group 
	{
		private var _bg:Rect;
		private var _btnDummy:UIAsset;
		private var _btnPencil:UIAsset;
		private var _btnText:UIAsset;
		private var _btnEraser:UIAsset;
		private var _btnGroup:Group;
		private var _btnColor1:UIAsset;
		private var _btnColor2:UIAsset;
		private var _btnColor3:UIAsset;
		private var _thickness:int;
		private var _curTool:UIAsset;
		
		public function DocToolView( s:SingletonEnforcer ) 
		{
			if ( !s ) {
				throw new Error( "请不要调用构造函数！获取实例请调用getInstance()!" );
			}
			initComponents();
		}
		
		private static var instance:DocToolView;
		public static function getInstance():DocToolView
		{
			return instance ||= new DocToolView(new SingletonEnforcer());
		}
		
		private function initComponents():void 
		{
			this.left = 10;
			this.bottom = 10;
			
			addElement( _btnGroup = new Group() );
			_btnGroup.layout = new HorizontalLayout();
			HorizontalLayout(_btnGroup.layout).gap = 10;
			
			
			
			_btnDummy = createToggleButton( _btnGroup, "禁用", GlobalVars.language == GlobalVars.LANG_CHINESE ? "禁用画笔工具" : 'disabled the pen', AssetsFactory.getInstance().getAsset('DisableButtonSkin') )
			_btnPencil = createToggleButton( _btnGroup, "铅笔", GlobalVars.language == GlobalVars.LANG_CHINESE ? "铅笔工具" : 'Text tool', AssetsFactory.getInstance().getAsset('PencilButtonSkin') );
			_btnText = createToggleButton( _btnGroup, "文本", GlobalVars.language == GlobalVars.LANG_CHINESE ? "文本工具" : 'Pencil tool', AssetsFactory.getInstance().getAsset('TextButtonSkin') );
			_btnEraser = createToggleButton( _btnGroup, "橡皮",  GlobalVars.language == GlobalVars.LANG_CHINESE ? "擦除工具" : 'Erase tool', AssetsFactory.getInstance().getAsset('EraserButtonSkin') );
			
			//_btnColor1 = createToggleButton( _btnGroup, "红色", "红色铅笔",AssetsFactory.getInstance().getAsset('RedButtonSkin') );
			//_btnColor2 = createToggleButton( _btnGroup, "绿色", "绿色铅笔", AssetsFactory.getInstance().getAsset('GreenButtonSkin') );
			//_btnColor3 = createToggleButton( _btnGroup, "黑色", "黑色铅笔",AssetsFactory.getInstance().getAsset('BlackButtonSkin') );
			//_btnColor3.$selected = true;
			
			_btnDummy.id = "0";
			_btnPencil.id = "1";
			_btnText.id = "2";
			_btnEraser.id = "3";
			
			//_btnColor1.id = "0xFF0000";
			//_btnColor2.id = "0x00FF00";
			//_btnColor3.id = "0x000000";
			
			this.id = "DocToolView.as";
			this.addEventListener(Event.ADDED_TO_STAGE, onStageAdded );
		}
		
		private function onStageAdded(e:Event):void 
		{
			this.visible = true;
		}
		
		private function createToggleButton( parent:Group, label:String = null, toolTip:String = null, skinName:Object = null ):UIAsset
		{
			var btn:UIAsset = new UIAsset();
			return buildButton( parent, btn, label, toolTip, skinName ) as UIAsset;
		}
		
		private function createButton( parent:Group, label:String = null, toolTip:String = null, skinName:Object = null ):UIAsset
		{
			var btn:UIAsset = new UIAsset();
			return buildButton( parent, btn, label, toolTip, skinName ) as UIAsset;
		}
		
		private function buildButton( parent:Group, btn:UIAsset, label:String, toolTip:String, skinName:Object ):UIAsset
		{
			parent.addElement( btn );
			btn.toolTip = toolTip;
			btn.skinName = skinName;
			return btn;
		}
		
		public function get btnPencil():UIAsset 
		{
			return _btnPencil;
		}
		
		public function get btnText():UIAsset 
		{
			return _btnText;
		}
		
		public function get btnEraser():UIAsset 
		{
			return _btnEraser;
		}
		
		public function get curTool():UIAsset 
		{
			return _curTool;
		}
		
		public function set curTool(value:UIAsset):void 
		{
			_curTool = value;
		}
		
		public function get btnDummy():UIAsset 
		{
			return _btnDummy;
		}
		
		//public function get btnColor1():UIAsset 
		//{
			//return _btnColor1;
		//}
		//
		//public function get btnColor2():UIAsset 
		//{
			//return _btnColor2;
		//}
		//
		//public function get btnColor3():UIAsset 
		//{
			//return _btnColor3;
		//}
		
	}

}

class SingletonEnforcer{}