package tetequ.live.modules.room.avdocument 
{
	import flash.events.Event;
	import flash.media.Camera;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.components.Rect;
	import org.flexlite.domUI.layouts.VerticalLayout;
	import tetequ.live.modules.room.common.GlobalVars;
	//import tetequ.live.modules.room.individuation.setup.model.CameraItemVo;
	import tetequ.live.utils.HashMap;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 摄像头设置界面
	 */
	public class CameraSettingsView extends Group 
	{
		private var _camGroup:Group;
		private var _camVos:HashMap;
		private var _camViews:HashMap;
		
		private var _titleGroup:Group;
		private var _titleBg:Rect;
		private var _titleMsg:String;
		private var _txtTitle:Label;
		
		private var _txtMessage:Label;
		
		private var _initialized:Boolean;
		
		public function CameraSettingsView() 
		{
			super();
			initComponents();
		}
		
		private function initComponents():void 
		{
			this.percentWidth = 100;
			this.horizontalCenter = 0;
			this.addElement( _titleGroup = new Group() );
			_titleGroup.addElement( _titleBg = new Rect() );
			_titleBg.fillColor = 0xffffff;
			_titleBg.fillAlpha = 0;
			_titleBg.height = 30;
			_titleBg.percentWidth = 100;
			_titleGroup.percentWidth = 100;
			_titleGroup.addElement( _txtTitle = new Label() );
			Label.showEmbedFontsOnly = true;
			if (GlobalVars.language == GlobalVars.LANG_ENGLISH)
			{
				//英文
				_txtTitle.text = "Video Equipment";
			}else if(GlobalVars.language == GlobalVars.LANG_CHINESE)
			{
				//中文
				_txtTitle.text = "视频设备";
			}else
			{
				throw new Error('无法识别的语言！');
			}
		
			_txtTitle.size = 20;
			_txtTitle.bold = true;
			_txtTitle.fontFamily = "微软雅黑";
			_txtTitle.textColor = 0x000000;
			_txtTitle.horizontalCenter = 0;
			_txtTitle.verticalCenter = 0;
			
			this.addElement( _txtMessage = new Label() );
			
			
			if (GlobalVars.language == GlobalVars.LANG_ENGLISH)
			{
				//英文
				_txtMessage.text = "You do not have to install the camera!";
			}else if(GlobalVars.language == GlobalVars.LANG_CHINESE)
			{
				//中文
				_txtMessage.text = "您没有安装摄像头!";
			}else
			{
				throw new Error('无法识别的语言！');
			}
			
			_txtMessage.textColor = 0x000000;
			_txtMessage.horizontalCenter = 0;
			_txtMessage.top = 30;
		}
		
		/**
		 * 添加摄像头
		 * @param	cams
		 */
		public function setCams( cams:HashMap ):void
		{
			_camVos = cams;
			
			if ( !_initialized )
			{
				_initialized = true;
				this.addElement( _camGroup = new Group() );
				_camViews = new HashMap();
				_camGroup.layout = new VerticalLayout();
				_camGroup.top = 48;
				_camGroup.horizontalCenter = 0;
				VerticalLayout(_camGroup.layout).gap = 10;
			}
			
			if ( containsElement( _txtMessage ) )
			{
				removeElement( _txtMessage );
			}
			
			updateCamViews();
		}
		
		/**
		 * 刷新摄像头列表
		 */
		private function updateCamViews():void
		{
			_camGroup.removeAllElements();
			
			var arr:Array = _camViews.getValues();
			for each(var view:CameraItemSettingsView in arr)
			{
				if (!_camVos.containsKey(view.cameraVO.id))
				{
					view.removeEventListener(Event.SELECT, onSelectedSwitch);
					_camViews.remove(view.cameraVO.id);
				}
			}
			
			arr = _camVos.getValues();
			for each(var vo:CameraVO in arr)
			{
				if (!_camViews.containsKey(vo.id))
				{
					view = new CameraItemSettingsView(vo);
					_camViews.put(vo.id, view);
				}
			}
			
			arr = _camViews.getValues();
			for each( view in arr )
			{
				_camGroup.addElement( view );
				view.update();
				view.addEventListener( Event.SELECT, onSelectedSwitch );
			}
		}
		
		/**
		 * 可以选两个摄像头
		 * @param	e
		 */
		private function onSelectedSwitch(e:Event):void 
		{
			var arr:Array = _camViews.getValues();
			var target:CameraItemSettingsView = e.currentTarget as CameraItemSettingsView;
			var numSelected:int;
			
			if ( target.selected )
			{
				for each( var view:CameraItemSettingsView in arr )
				{
					if (view.selected)
					{
						numSelected++;
					}
				}
			}
			
			if (numSelected > GlobalVars.per_actor_av_num)
			{
				for each(view in arr)
				{
					if (view != target && view.selected)
					{
						view.selected = false; 
						break;
					}
				}
			}
		}
		
		/**
		 * 保存当前设置
		 */
		public function save():void
		{
			var arr:Array = _camViews.getValues();
			for each( var view:CameraItemSettingsView in arr )
			{
				view.save();
			}
		}
		
		/**
		 * 清除操作
		 */
		public function clear():void
		{
			if ( !_camViews ) return;
			var arr:Array = _camViews.getValues();
			for each( var view:CameraItemSettingsView in arr )
			{
				view.clear();
			}
		}
		
		/**
		 * 重置到默认设置
		 * 默认选择第一个
		 */
		public function reset():void
		{
			if (!_camViews) return;
			var arr:Array = _camViews.getValues();
			for each( var view:CameraItemSettingsView in arr )
			{
				view.reset();
			}
			
			if ( arr.length > 0 )
			{
				CameraItemSettingsView(arr[0]).selected = true;
			}
		}
	}

}