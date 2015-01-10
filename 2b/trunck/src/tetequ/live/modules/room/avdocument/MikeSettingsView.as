package tetequ.live.modules.room.avdocument 
{
	import flash.events.Event;
	import flash.media.Camera;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.components.Rect;
	import org.flexlite.domUI.layouts.HorizontalAlign;
	import org.flexlite.domUI.layouts.VerticalAlign;
	import org.flexlite.domUI.layouts.VerticalLayout;
	import tetequ.live.modules.room.common.GlobalVars;
	//import tetequ.live.modules.room.individuation.setup.model.CameraItemVo;
	//import tetequ.live.modules.room.individuation.setup.model.MicItemVo;
	import tetequ.live.utils.HashMap;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 麦克风设置界面
	 */
	public class MikeSettingsView extends Group 
	{
		private var _micGroup:Group;
		private var _micVos:HashMap;
		private var _micViews:HashMap;
		
		private var _titleGroup:Group;
		private var _titleBg:Rect;
		private var _txtTitle:Label;
		private var _txtNotice:Label;
		
		private var _txtMessage:Label;
		
		private var _initialized:Boolean;

		public function MikeSettingsView() 
		{
			super();
			initComponents();
		}
		
		private function initComponents():void 
		{
			this.horizontalCenter = 0;
			this.percentWidth = 100;
			
			this.addElement( _titleGroup = new Group() );
			_titleGroup.addElement( _titleBg = new Rect() );
			_titleBg.fillColor = 0xffffff;
			_titleBg.fillAlpha = 0;
			_titleBg.height = 30;
			_titleBg.percentWidth = 100;
			_titleGroup.percentWidth = 100;
			_titleGroup.addElement( _txtTitle = new Label() );
			
			_titleGroup.addElement(_txtNotice = new Label());
			_txtNotice.fontFamily = '微软雅黑';
			_txtNotice.textColor = 0x555555;
			_txtNotice.text = '(提示:请对着麦克风说话，进行试听测试)';
			_txtNotice.horizontalCenter = 0;
			_txtNotice.top = 40;
		
			if (GlobalVars.language == GlobalVars.LANG_ENGLISH)
			{
				//英文
				_txtTitle.text = "Audio Equipment";
			}else if(GlobalVars.language == GlobalVars.LANG_CHINESE)
			{
				//中文
				_txtTitle.text = "音频设备";

			}else
			{
				throw new Error('无法识别的语言！');
			}
			
			_txtTitle.textColor = 0x000000;
			_txtTitle.size = 20;
			_txtTitle.fontFamily = "微软雅黑";
			_txtTitle.bold = true;
			_txtTitle.horizontalCenter = 0;
			_txtTitle.verticalCenter = 0;
			
			this.addElement( _txtMessage = new Label() );
			
			if (GlobalVars.language == GlobalVars.LANG_ENGLISH)
			{
				//英文
				_txtMessage.text = "You do not have to install a microphone!";
			}else if(GlobalVars.language == GlobalVars.LANG_CHINESE)
			{
				//中文
				_txtMessage.text = "您没有安装麦克风!";

			}else
			{
				throw new Error('无法识别的语言！');
			}
			
			_txtMessage.textColor = 0x888888;
			_txtMessage.horizontalCenter = 0;
			_txtMessage.top = 30;
		}
		
		/**
		 * 添加麦克风
		 * @param	mics
		 */
		public function setMics( mics:HashMap ):void
		{
			_micVos = mics;
			
			var vos:Array = _micVos.getKeys();
			if ( vos.length == 0 ) return;
			
			if ( containsElement( _txtMessage ) )
			{
				removeElement( _txtMessage );
			}
			
			if ( !_initialized )
			{
				_initialized = true;
				
				_micViews = new HashMap();
				this.addElement( _micGroup = new Group() );
				_micGroup.top = 68;
				_micGroup.layout = new VerticalLayout();
				_micGroup.horizontalCenter = 0;
				VerticalLayout(_micGroup.layout).gap = 10;
				VerticalLayout(_micGroup.layout).paddingBottom = 2;
				VerticalLayout(_micGroup.layout).horizontalAlign = HorizontalAlign.LEFT;
			}
			
			updateMicViews();
		}
		
		/**
		 * FIXME：目前只允许用户选择一个摄像头一个麦克风
		 * @param	e
		 */
		private function onSelectedSwitch(e:Event):void 
		{
			var arr:Array = _micViews.getValues();
			var target:MikeItemSettingsView = e.currentTarget as MikeItemSettingsView;
			
			if ( target.selected )
			{
				for each( var view:MikeItemSettingsView in arr )
				{
					if ( view == target ) continue;
					view.selected = false;
				}
			}
		}
		
		/**
		 * 刷新麦克风列表
		 */
		private function updateMicViews():void
		{
			_micGroup.removeAllElements();
			
			var arr:Array = _micViews.getValues();
			for each( var view:MikeItemSettingsView in arr )
			{
				if ( !_micVos.containsKey(view.microVO.id) )
				{
					_micViews.remove(view.microVO.id);
					view.removeEventListener( Event.SELECT, onSelectedSwitch );
				}
			}
			
			arr = _micVos.getValues();
			for each( var vo:MicroVO in arr )
			{
				if ( !_micViews.containsKey(vo.id) )
				{
					view = new MikeItemSettingsView( vo );
					_micViews.put(vo.id, view);
				}
			}
			
			arr = _micViews.getValues();
			for each( view in arr )
			{
				_micGroup.addElement( view );
				view.update();
				view.addEventListener( Event.SELECT, onSelectedSwitch );
			}
		}
		
		/**
		 * 保存当前设置
		 */
		public function save():void
		{
			if ( !_micViews ) return;
			var arr:Array = _micViews.getValues();
			for each( var view:MikeItemSettingsView in arr )
			{
				view.save();
			}
		}
		
		/**
		 * 清除
		 */
		public function clear():void
		{
			if ( !_micViews ) return;
			var arr:Array = _micViews.getValues();
			for each( var view:MikeItemSettingsView in arr )
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
			if (!_micViews) return;
			var arr:Array = _micViews.getValues();
			for each( var view:MikeItemSettingsView in arr )
			{
				view.reset();
			}
			
			if ( arr.length > 0 )
			{
				MikeItemSettingsView(arr[0]).selected = true;
			}
		}
	}

}