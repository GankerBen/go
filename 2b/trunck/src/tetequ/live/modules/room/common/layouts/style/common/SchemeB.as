package tetequ.live.modules.room.common.layouts.style.common 
{
	import flash.events.Event;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Rect;
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.domUI.layouts.HorizontalLayout;
	import tetequ.live.core.assets.AssetsFactory;
	import tetequ.live.modules.room.avdocument.AVDocumentManager;
	import tetequ.live.modules.room.chat.privates.view.PrivateChatManager;
	import tetequ.live.utils.HashMap;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 布局样式B(启用)
	 */
	public class SchemeB extends BaseScheme 
	{
		protected var sceneLayer:UIAsset;
		protected var contentLayer:Group;
		protected var popupLayer:Group;
		protected var pChatLayer:Group;
		protected var avReqLayer:Group;
		
		/**
		 * 构造函数
		 * @param	components 包含了一组UI元素，通过components.getValue(ui.key)获得ui实例的引用
		 */
		public function SchemeB(components:HashMap) 
		{
			super(components);
			initComponents();
		}
		
		protected function initComponents():void 
		{
			addElement( sceneLayer = new UIAsset() );
			sceneLayer.percentWidth = 100;
			sceneLayer.percentHeight = 100;
			
			addElement(contentLayer = new Group());
			contentLayer.percentWidth = 100;
			contentLayer.percentHeight = 100;
			contentLayer.layout = new HorizontalLayout();
			HorizontalLayout(contentLayer.layout).paddingLeft = 0;
			HorizontalLayout(contentLayer.layout).paddingRight = 0;
			HorizontalLayout(contentLayer.layout).paddingBottom = 0;
			HorizontalLayout(contentLayer.layout).paddingTop = 0;
			HorizontalLayout(contentLayer.layout).gap = 5;
			
			addElement(popupLayer = new Group());
			popupLayer.percentWidth = 100;
			popupLayer.percentHeight = 100;

			addElement(pChatLayer = new Group());
			pChatLayer.bottom = 10;
			pChatLayer.left = 70;
	
			addElement( avReqLayer = new Group() );
			avReqLayer.bottom = 5;
			avReqLayer.right = 10;
			avReqLayer.width = 350;
			
			this.percentWidth = 100;
			this.percentHeight = 100;
		}
		
		override public function layoutElements():void
		{
			pChatLayer.addElement(PrivateChatManager.getInstance());
			sceneLayer.skinName = AssetsFactory.getInstance().getAsset('back1');
		}
		
	}

}