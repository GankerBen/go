package tetequ.live.modules.room.avdocument 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.components.ProgressBar;
	import org.flexlite.domUI.components.ProgressBarDirection;
	import org.flexlite.domUI.components.ToggleButton;
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.domUI.layouts.HorizontalLayout;
	import org.flexlite.domUI.layouts.supportClasses.LayoutBase;
	import org.flexlite.domUI.layouts.VerticalAlign;
	import org.flexlite.domUI.skins.vector.ToggleButtonSkin;
	import org.flexlite.skin.EnablebuttonSkin;
	import tetequ.live.core.assets.AssetsFactory;
	import tetequ.live.modules.room.common.button.AssetUnit;
	//import tetequ.live.modules.room.individuation.setup.model.MicItemVo;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 单个麦克风设置(同一台电脑麦克风可能有多个)
	 */
	public class MikeItemSettingsView extends Group 
	{
		private var _microVO:MicroVO;
		private var _aniMic:ProgressBar;//进度增长方向，从下到上_aniMic.direction;
		private var _btnSwitch:AssetUnit;
		private var _txtMicName:Label;
		private var _lastSelected:Boolean;
		private var _group:Group;
		private var _volumeBar:MicroVolumeItemView;
		
		/**
		 * 构造函数
		 * @param	name
		 */
		public function MikeItemSettingsView( vo:MicroVO ) 
		{
			super();
			_microVO = vo;
			initComponents();
		}
		
		private function initComponents():void 
		{
			//this.horizontalCenter = 0;
			this.percentWidth = 100;
			this.addElement( _group = new Group() );
			_group.layout = new HorizontalLayout();
			_group.addElement( _btnSwitch = new AssetUnit('EnablebuttonSkin', true) );
			_btnSwitch.verticalCenter = 0;
			_btnSwitch.selected = _microVO.selected;
			_btnSwitch.addEventListener( MouseEvent.CLICK, onSelected );
			
			_group.addElement( _txtMicName = new Label() );
			_txtMicName.textColor = 0x000000;
			_txtMicName.text = _microVO.name;
			_txtMicName.verticalCenter = 0;
			_txtMicName.size = 15;

			_volumeBar = new MicroVolumeItemView(_microVO.micro);
			_volumeBar.top = 30;
			_volumeBar.percentWidth = 100;
		}
		
		private function onSelected(e:MouseEvent):void 
		{
			if (!_btnSwitch.selected)
				_btnSwitch.selected = true;
				
			if (!_microVO.selected)
			{
				_microVO.selected = true;
				_volumeBar.selected = true;
				dispatchEvent(new Event(Event.SELECT));
			}
		}
		
		/**
		 * 默认设置
		 */
		public function reset():void 
		{
			// TODO
		}
		
		/**
		 * 更新
		 */
		public function update():void
		{
			_volumeBar.selected = _btnSwitch.selected = _lastSelected = _microVO.selected;
			updateVolumeBar(_microVO.selected);
		}
		
		private function updateVolumeBar(selected:Boolean):void
		{
			if (selected)
			{
				addElement(_volumeBar);
			}else
			{
				if (containsElement(_volumeBar))
					removeElement(_volumeBar);
			}
		}
		
		/**
		 * 保存设置
		 * 写入到VO
		 */
		public function save():void
		{
			_volumeBar.selected = false;
		}
		
		private var _clear:Boolean;
		
		/**
		 * 清除操作
		 */
		public function clear():void
		{
			// TODO
		}
		
		public function get selected():Boolean 
		{
			return _btnSwitch.selected;
		}
		
		public function set selected(value:Boolean):void 
		{
			if ( _btnSwitch.selected == value ) return;
			_volumeBar.selected = _btnSwitch.selected = _microVO.selected = _lastSelected = value;
			updateVolumeBar(_microVO.selected);
		}
		
		public function get microVO():MicroVO 
		{
			return _microVO;
		}
		
	}

}
