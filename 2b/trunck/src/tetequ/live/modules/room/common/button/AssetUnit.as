package tetequ.live.modules.room.common.button 
{
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.domUI.events.UIEvent;
	import tetequ.live.core.assets.AssetsFactory;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class AssetUnit extends UIAsset 
	{
		private var _assetName:String;
		private var _selected:Boolean;
		private var _type:String;
		public static const TOGGLE_BUTTON:String = 'toggle-button';
		public static const SIMPLE_BUTTON:String = 'simple-button';
		public static const ICON:String = 'icon';
		public static const ANIMATION:String = 'animation';
		
		/**
		 * 构造函数
		 * @param	assetName	对应flash中该素材的导出链接名
		 * @param   mouseChildren 子级是否可以点击
		 */
		public function AssetUnit(assetName:*, mouseChildren:Boolean = false) 
		{
			super();
			_assetName = assetName;
			this.mouseChildren = mouseChildren;
			initComponents();
		}
		
		private function initComponents():void 
		{
			this.addEventListener(UIEvent.SKIN_CHANGED, onSkinChanged);
			this.skinName = AssetsFactory.getInstance().getAsset(_assetName);
		}
		
		private function onSkinChanged(e:UIEvent):void 
		{
			if (this.skin is MovieClip)
			{
				if (MovieClip(this.skin).totalFrames == 2)
				{
					_type = TOGGLE_BUTTON;
					//只是用来改变selected的状态
					this.addEventListener(MouseEvent.CLICK, onClick, false, 10000);
				}else if (MovieClip(this.skin).totalFrames == 1)
				{
					_type = ICON;
				}else
				{
					_type = ANIMATION;
				}
			}else if (this.skin is SimpleButton)
			{
				_type = SIMPLE_BUTTON;
			}
		}
		
		private function onClick(e:MouseEvent):void 
		{
			if (MovieClip(skin).currentFrame == 1)
			{
				MovieClip(skin).nextFrame();
				_selected = true;
			}else
			{
				MovieClip(skin).prevFrame();
				_selected = false;
			}
		}
		
		public function get selected():Boolean 
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void 
		{
			if (_type != TOGGLE_BUTTON)
				throw new Error(_type+' 不是TOGGLE_BUTTON，不能设置该属性！');
			if (_selected == value) return;
			_selected = value;
			_selected ? MovieClip(skin).gotoAndStop(2) : MovieClip(skin).gotoAndStop(1);
		}
		
		public function get type():String 
		{
			return _type;
		}
		
	}

}