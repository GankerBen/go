package tetequ.live.modules.loading.view 
{
	import flash.display.Loader;
	import flash.events.Event;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.components.ProgressBar;
	import org.flexlite.domUI.components.Rect;
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.domUI.events.UIEvent;
	import org.flexlite.domUI.layouts.HorizontalAlign;
	import org.flexlite.domUI.layouts.HorizontalLayout;
	import org.flexlite.domUI.skins.vector.ProgressBarSkin;
	import tetequ.live.core.assets.AssetsFactory;
	import tetequ.live.modules.room.common.GlobalVars;
	
	/**
	 * ...
	 * @author pandazhong
	 * loading界面
	 */
	public class LoadingView2 extends Group 
	{
		public var background:Rect;
		public var description:Label;
		private var _logo:UIAsset;
		private var _logoGroup:Group;
		private var _logoLeft:UIAsset;
		private var _logoRight:UIAsset;
		private var _logoAni:UIAsset;
		
		public function LoadingView2() 
		{
			super();
			this.percentWidth = this.percentHeight = 100;
		}
		
		override protected function createChildren():void
        {
            super.createChildren();
        }
		
		public function init():void
		{
			addElement( background = new Rect() );
			background.width = 300;
			background.percentWidth = 100;
			background.percentHeight = 100;
			background.fillColor = 0xffffff;
			background.alpha = 0.5;
			
			
			addElement(_logoAni = new UIAsset());
			_logoAni.horizontalCenter = 50;
			_logoAni.verticalCenter = 50;
			_logoAni.skinName = AssetsFactory.getInstance().getAsset('LoadingIcon');
		}
	}
}