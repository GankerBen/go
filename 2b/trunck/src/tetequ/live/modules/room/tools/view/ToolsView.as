package tetequ.live.modules.room.tools.view
{
	import org.flexlite.domUI.components.Button;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Rect;
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.domUI.layouts.TileLayout;
	import org.flexlite.domUI.layouts.VerticalAlign;
	import org.flexlite.domUI.layouts.VerticalLayout;
	import org.flexlite.domUI.skins.vector.ButtonSkin;
	import org.flexlite.domUI.skins.VectorSkin;
	import org.flexlite.skin.SetUpSkin;
	import org.flexlite.skin.SharingButtpmSkin;
	import tetequ.live.core.assets.AssetsFactory;
	import tetequ.live.modules.room.common.GlobalVars;
	import tetequ.live.modules.room.common.panel.BasePanel;
	import tetequ.live.modules.room.common.panel.PanelID;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 工具面板
	 */
	public class ToolsView extends Group 
	{
		private var _btnScreenShare:UIAsset;
		private var _btnRecording:UIAsset;
		private var _itemsGroup:Group;
		private var _bubble:Group;
		
		public function ToolsView( s:SingletonEnforcer ) 
		{
			if (!s)
				throw new Error("单例不允许new！");
			initComponents();
		}
		
		private static var instance:ToolsView;
		public static function getInstance():ToolsView
		{
			return instance ||= new ToolsView(new SingletonEnforcer());
		}

		private function initComponents():void
		{
			var bg:Rect = new Rect();
			bg.width = 260;
			bg.height = 174;
			bg.fillColor = 0xF2F5F7;
			
			var tri:VectorSkin = new VectorSkin();
			tri.graphics.beginFill(0xf2f5f7);
			tri.graphics.moveTo(0, 0);
			tri.graphics.lineTo( 0, 20);
			tri.graphics.lineTo( -10, 10);
			tri.graphics.lineTo( 0, 0);
			tri.graphics.endFill();
			
			addElement(_bubble = new Group());
			_bubble.addElement(bg);
			_bubble.addElement(tri);
			tri.left = 0;
			tri.top = 20;
			
			_btnScreenShare = new UIAsset();
			_btnScreenShare.maintainAspectRatio = true;
			_btnScreenShare.mouseChildren = true;
			_btnScreenShare.skinName = AssetsFactory.getInstance().getAsset('SharingButtpmSkin');
			
			if (GlobalVars.language == GlobalVars.LANG_ENGLISH)
			{
				//英文
				_btnScreenShare.toolTip = "Screen Sharing";
			}else if(GlobalVars.language == GlobalVars.LANG_CHINESE)
			{
				//中文
				_btnScreenShare.toolTip = "屏幕共享";
			}else
			{
				throw new Error('无法识别的语言！');
			}
			
			_btnRecording = new UIAsset();
			_btnRecording.maintainAspectRatio = true;
			_btnRecording.mouseChildren = true;
			_btnRecording.skinName = AssetsFactory.getInstance().getAsset('RecordButtonSkin');
			if (GlobalVars.language == GlobalVars.LANG_ENGLISH)
			{
				//英文
				_btnRecording.toolTip = "Record video";
			}else if(GlobalVars.language == GlobalVars.LANG_CHINESE)
			{
				//中文
				_btnRecording.toolTip = "录制视频";
			}else
			{
				throw new Error('无法识别的语言！');
			}
			
			addElement(_itemsGroup = new Group());
			_itemsGroup.layout = new TileLayout();
			_itemsGroup.percentWidth = 100;
			_itemsGroup.percentHeight = 100;
			_itemsGroup.addElement(_btnScreenShare);
			_itemsGroup.addElement(_btnRecording);
			TileLayout(_itemsGroup.layout).horizontalGap = 30;
			TileLayout(_itemsGroup.layout).verticalGap = 10;
			TileLayout(_itemsGroup.layout).paddingTop = 30;
			TileLayout(_itemsGroup.layout).paddingLeft = 10;
			TileLayout(_itemsGroup.layout).paddingRight = 10;
			TileLayout(_itemsGroup.layout).paddingBottom = 10;
			
			this.right = -271;
		}	

		public function get btnScreenShare():UIAsset 
		{
			return _btnScreenShare;
		}
		
		public function get btnRecording():UIAsset 
		{
			return _btnRecording;
		}
	}
}

class SingletonEnforcer{}