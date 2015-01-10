package tetequ.live.modules.room.avdocument 
{
	import com.e2et.net.media.video.IPreview;
	import com.e2et.net.media.video.IVideoCapture;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.media.VideoStreamSettings;
	import flash.utils.describeType;
	import org.flexlite.domUI.components.Button;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.components.Rect;
	import org.flexlite.domUI.components.ToggleButton;
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.domUI.layouts.HorizontalLayout;
	import org.flexlite.domUI.layouts.VerticalLayout;
	import org.flexlite.domUI.skins.vector.ToggleButtonSkin;
	import org.flexlite.skin.EnablebuttonSkin;
	import org.flexlite.skin.ResolutiionButton16Skin;
	import org.flexlite.skin.ResolutionButtonSkin;
	import org.flexlite.skin.ToggleBUuttonSkin;
	import tetequ.live.core.assets.AssetsFactory;
	import tetequ.live.modules.room.common.button.AssetUnit;
	import tetequ.live.modules.room.common.GlobalVars;
	//import tetequ.live.modules.room.individuation.setup.model.CameraItemVo;
	//import tetequ.live.modules.room.individuation.setup.model.CameraMode;
	//import tetequ.live.modules.room.individuation.setup.model.DeviceConfiguration;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 单个摄像头配置界面
	 */
	public class CameraItemSettingsView extends Group 
	{
		private var _cameraVO:CameraVO;
		private var _video:Video;
		private var _videoWrapper:UIAsset;
		
		private var _btnSwitch:AssetUnit;
		private var _lastSelected:Boolean;
		
		private var _fpsGroup:Group;
		private var _hdGroup:FPSGroup;
		private var _sdGroup:FPSGroup;
		private var _smGroup:FPSGroup;
		private var _lastFPS:FPSGroup;
		
		private var _resolution:Group;
		private var _btn_4_3:AssetUnit;
		private var _btn_16_9:AssetUnit;
		private var _lastRes:AssetUnit;
		
		//包含video+btnSwitch
		private var _group1:Group;
		
		//包含fpsGroup+resolution
		private var _group2:Group;
		
		private var _previewCamera:Camera;
		private var _btnRefresh:UIAsset;
		
		private var _tipMessage:Label;
		private var _previewBg:Rect;
		
		//ip摄像头
		private var _ipCamCapture:IVideoCapture;
		
		/**
		 * 构造函数
		 * @param	name
		 */
		public function CameraItemSettingsView( vo:CameraVO ) 
		{
			super();
			_cameraVO = vo;
			initComponents();
		}
		
		private function initComponents():void 
		{
			this.horizontalCenter = 0;
			
			this.layout = new VerticalLayout();
			VerticalLayout(this.layout).gap = 20;
			this.addElement( _group1 = new Group() );
			this.addElement( _group2 = new Group() );
			
			_group1.addElement(_previewBg = drawRect(NaN, NaN, 320, 240, 0, 0, 0, 0, 0));
			_group1.addElement(_tipMessage = new Label());
			_tipMessage.text = '这个摄像头好像有点问题~';
			_tipMessage.horizontalCenter = 0;
			_tipMessage.verticalCenter = 0;
			_tipMessage.fontFamily = '微软雅黑';
			_tipMessage.textColor = 0xffffff;
			_tipMessage.size = 15;
			_tipMessage.bold = true;
			
			_group1.addElement(_videoWrapper = new UIAsset() );
			_videoWrapper.skinName = _video = new Video( 320, 240 );
			
			_group1.addElement( _btnSwitch = new AssetUnit('EnablebuttonSkin', true) );
			_btnSwitch.bottom = 0;
			_btnSwitch.right = 0;
			_btnSwitch.addEventListener( MouseEvent.CLICK, onSelectedSwitch );
			
			_group2.layout = new HorizontalLayout();
			HorizontalLayout(_group2.layout).gap = 35;
			_group2.addElement( _fpsGroup = new Group() );
			_group2.addElement( _resolution = new Group() );
			
			_fpsGroup.layout = new HorizontalLayout();
			_resolution.layout = new HorizontalLayout();
			HorizontalLayout(_resolution.layout).gap = 10;
			HorizontalLayout(_fpsGroup.layout).gap = 20;
			
			_fpsGroup.addElement( _hdGroup = new FPSGroup( DeviceConfig.HD, GlobalVars.language == GlobalVars.LANG_CHINESE ? "高清" : 'HD', 'ToggleBUuttonSkin' ) );
			_fpsGroup.addElement( _sdGroup = new FPSGroup( DeviceConfig.SD, GlobalVars.language == GlobalVars.LANG_CHINESE ? "标清" : 'SD', 'ToggleBUuttonSkin' ) );
			_fpsGroup.addElement( _smGroup = new FPSGroup( DeviceConfig.SM, GlobalVars.language == GlobalVars.LANG_CHINESE ? "顺畅" : 'Smooth', 'ToggleBUuttonSkin' ) );
			
			_hdGroup.addEventListener( Event.CHANGE, onFPSChanged );
			_sdGroup.addEventListener( Event.CHANGE, onFPSChanged );
			_smGroup.addEventListener( Event.CHANGE, onFPSChanged );

			_resolution.addElement(_btn_4_3 = new AssetUnit('ResolutionButtonSkin', true));
			_btn_4_3.addEventListener( MouseEvent.CLICK, onResolutionChanged );
			_btn_4_3.id = DeviceConfig.KEY_RES_4_3;
			_btn_4_3.verticalCenter = 0;

			_resolution.addElement(_btn_16_9 = new AssetUnit('ResolutiionButton16Skin', true));
			_btn_16_9.addEventListener( MouseEvent.CLICK, onResolutionChanged );
			_btn_16_9.id = DeviceConfig.KEY_RES_16_9;
			_btn_16_9.verticalCenter = 0;
		}
		
		/**
		 * 启用或禁用
		 * @param	e
		 */
		private function onSelectedSwitch(e:MouseEvent):void 
		{
			_btnSwitch.selected = !_btnSwitch.selected;
			
			if (_btnSwitch.selected && !_cameraVO.selected)
			{
				_cameraVO.selected = true;
				dispatchEvent(new Event(Event.SELECT));
			}else
			{
				_cameraVO.selected = false;
			}
		}
		
		/**
		 * 设置分辨率
		 * @param	e
		 */
		private function onResolutionChanged(e:MouseEvent):void 
		{
			var resolution:String = AssetUnit(e.currentTarget).id;
			AssetUnit(e.currentTarget).selected = true;
			if (_lastRes.id == resolution)
			{
				trace('resolution not changed', resolution);
				return;
			}
			trace('resolution changed', resolution);
			_cameraVO.resolution = resolution;
			_lastRes.selected = false;
			_lastRes = AssetUnit(e.currentTarget);
		}
		
		/**
		 * fps改变
		 * @param	e
		 */
		private function onFPSChanged(e:Event):void 
		{
			var fps:Number = FPSGroup(e.currentTarget).fps;
			FPSGroup(e.currentTarget).selected = true;
			if (_lastFPS.fps == fps)
			{
				trace('fps not changed', fps);
				return;
			}
			_cameraVO.fps = fps;
			trace('fps changed', fps);
			_lastFPS.selected = false;
			_lastFPS = FPSGroup(e.currentTarget);
			trace('describe', describe(_cameraVO));
		}
		
		/**
		 * 更新预览效果
		 */
		private function updatePreview():void 
		{
			// TODO
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
			var arr:Array = [_hdGroup, _sdGroup, _smGroup];
			
			//更新FPS按钮选择状态
			for each( var fpsG:FPSGroup in arr )
			{
				if ( fpsG.fps == _cameraVO.fps )
				{
					fpsG.selected = true;
					_lastFPS = fpsG;
				}else 
				{
					fpsG.selected = false;
				}
			}
			
			//更新分辨率按钮选择状态
			arr = [_btn_4_3, _btn_16_9];
			for each( var res:AssetUnit in arr )
			{
				if ( res.id == _cameraVO.resolution )
				{
					res.selected = true;
					_lastRes = res;
				}else
				{
					res.selected = false;
				}
			}
			
			_videoWrapper.skinName = _video = new Video( 320, 240 )
			
			//更新选中按钮状态
			_btnSwitch.selected = _cameraVO.selected;
			
			//如果不是ip摄像头，则显示摄像头预览
			if(!_cameraVO.isIpCam)
				_video.attachCamera( _cameraVO.camera );
		}
		
		/**
		 * 保存设置
		 */
		public function save():void
		{
			_video.attachCamera(null);
			_video.clear();
		}

		/**
		 * 清除操作
		 */
		public function clear():void
		{
			if (_ipCamCapture)
				IPreview(_ipCamCapture).stopPreview(_video);
			_video.attachCamera( null );
			_video.clear();
			trace('已解除摄像头占用');
		}
		
		public function get selected():Boolean 
		{
			return _btnSwitch.selected;
		}
		
		public function set selected(value:Boolean):void 
		{
			if ( _btnSwitch.selected == value ) return;
			_btnSwitch.selected = _cameraVO.selected = _lastSelected = value;
			trace(_cameraVO.name, 'set selected', _cameraVO.selected);
		}
		
		public function get cameraVO():CameraVO 
		{
			return _cameraVO;
		}
		
	}

}
import flash.events.Event;
import flash.events.MouseEvent;
import org.flexlite.domUI.components.Group;
import org.flexlite.domUI.components.Label;
import org.flexlite.domUI.components.ToggleButton;
import org.flexlite.domUI.components.UIAsset;
import org.flexlite.domUI.layouts.HorizontalLayout;
import org.flexlite.domUI.skins.vector.ToggleButtonSkin;
import tetequ.live.modules.room.common.button.AssetUnit;

class FPSGroup extends Group
{
	private var _msg:String;
	private var _btn:AssetUnit;
	private var _txt:Label;
	private var _skin:Object;
	private var _fps:Number;
	
	public function FPSGroup( fps:Number, msg:String, skinName:Object = null )
	{
		_msg = msg;
		_fps = fps;
		if ( skinName )
			_skin = skinName;
		initComponents();
	}
	
	private function initComponents():void 
	{
		this.buttonMode = true;
		this.layout = new HorizontalLayout();
		HorizontalLayout(this.layout).gap = 1;
		this.addElement( _btn = new AssetUnit(_skin, true) );
		_btn.verticalCenter = 0;
		this.addEventListener( MouseEvent.CLICK, onClick );
		
		this.addElement( _txt = new Label() );
		_txt.verticalCenter = 0;
		_txt.textColor = 0x000000;
		_txt.text = _msg;
	}
	
	private function onClick(e:MouseEvent):void 
	{
		dispatchEvent( new Event( Event.CHANGE ) );
	}
	
	public function get fps():Number 
	{
		return _fps;
	}
	
	public function get selected():Boolean 
	{
		return _btn.selected;
	}
	
	public function set selected(value:Boolean):void 
	{
		if ( _btn.selected == value ) return;
		_btn.selected = value;
	}
}