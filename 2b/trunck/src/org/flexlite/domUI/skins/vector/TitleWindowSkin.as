package org.flexlite.domUI.skins.vector
{
	import org.flexlite.domUI.components.Button;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.components.UIAsset;
	import tetequ.live.core.assets.AssetsFactory;
	
	use namespace dx_internal;
	
	/**
	 * TitleWindow默认皮肤
	 * @author DOM
	 */
	public class TitleWindowSkin extends PanelSkin
	{
		/**
		 * 构造函数
		 */		
		public function TitleWindowSkin()
		{
			super();
		}
		
		public var closeButton:UIAsset;
		
		public var moveArea:Group;
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			moveArea = new Group();
			moveArea.left = 0;
			moveArea.right = 0;
			moveArea.top = 0;
			moveArea.height = 30;
			addElement(moveArea);
			
			closeButton = new UIAsset();
			closeButton.mouseEnabled = true;
			closeButton.mouseChildren = true;
			closeButton.skinName = AssetsFactory.getInstance().getAsset('CloseButtonSkin');
			closeButton.right = 5;
			closeButton.top = 5;
			addElement(closeButton);
		}
	}
}