package tetequ.live.modules.loading.view 
{
	import flash.display.Loader;
	import flash.events.Event;
	import framework.view.UIRoot;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.components.ProgressBar;
	import org.flexlite.domUI.components.Rect;
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.domUI.layouts.HorizontalAlign;
	import org.flexlite.domUI.layouts.HorizontalLayout;
	import org.flexlite.domUI.skins.vector.ProgressBarSkin;
	import tetequ.live.modules.room.common.GlobalVars;
	
	/**
	 * ...
	 * @author pandazhong
	 * loading界面
	 */
	public class LoadingView extends Group 
	{
		public var background:Rect;		//loading界面的背景
		public var description:Label;		//loading的素材说明
		private var _logo:UIAsset;
		private var _logoGroup:Group;
		private var _logoLeft:UIAsset;
		private var _logoRight:UIAsset;
		private var _logoAni:UIAsset;
		private var _bg:UIAsset;
		private var _hProgress:ProgressBar
		public function LoadingView() 
		{
			super();
			this.percentWidth = this.percentHeight = 100;
		}
		
		override protected function createChildren():void
        {
            super.createChildren();
        }
		
		public function init(root:UIRoot):void
		{
			root.addElement(this);
			
			addElement(_bg = new UIAsset());
			_bg.percentWidth = 100;
			_bg.percentHeight = 100;
			_bg.skinName = Application.LOADING_BACKGROUND;

			this.addElement(_logoLeft = new UIAsset());
			this.addElement(_logoRight = new UIAsset());
			
			_logoLeft.verticalCenter = 0;
			_logoRight.verticalCenter = 21;
			_logoLeft.horizontalCenter = -100;
			_logoRight.horizontalCenter = 60;
			
			_logoLeft.skinName = Application.LOGO_LEFT;
			_logoRight.skinName = Application.LOGO_RIGHT;
			
			//addElement(_logoAni = new UIAsset());
			//_logoAni.horizontalCenter = 160;
			//_logoAni.verticalCenter = 150;
			addElement(_hProgress = new ProgressBar());
			_hProgress.horizontalCenter = 10;
			_hProgress.verticalCenter = 100;
			_hProgress.width = 300;
			_hProgress.maximum = 100;
			_hProgress.value = 0;
			_hProgress.skinName = ProgressBarSkin;
			
			_aniLoader.loadBytes(new Application.LOGO_ANI());
			_aniLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
		}
		
		private var _total:Number;
		public function onProgress(loaded:Number, total:Number):void
		{
			if (isNaN(_total))
			{
				_total = total;
			}else
			{
				_hProgress.value = (loaded / total) * 100;
			}
		}
		
		private function onComplete(e:Event):void 
		{
			//_logoAni.skinName = _aniLoader.contentLoaderInfo.applicationDomain.getDefinition('Anima') as Class;
			_aniLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
			_aniLoader.unloadAndStop();
			_aniLoader = null;
		}
		
		private var _aniLoader:Loader = new Loader();
		
	}

}