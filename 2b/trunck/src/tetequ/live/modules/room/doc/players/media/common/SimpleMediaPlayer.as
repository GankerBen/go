package tetequ.live.modules.room.doc.players.media.common 
{
	import flash.display.Sprite;
	import org.flexlite.domUI.components.Button;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.HSlider;
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.components.Rect;
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.domUI.skins.vector.ButtonSkin;
	import org.flexlite.domUI.skins.vector.HSliderSkin;
	import org.flexlite.domUI.skins.vector.TitleWindowCloseButtonSkin;
	import org.flexlite.skin.CloseButtonSkin;
	import org.flexlite.skin.MuteButtonSkin;
	import org.flexlite.skin.PlayButtonsSkin;
	import org.flexlite.skin.PronunciationButtonSkin;
	import org.flexlite.skin.SptopButtonsSkin;
	import tetequ.live.core.assets.AssetsFactory;
	import tetequ.live.modules.room.doc.players.common.view.VisualPlayer;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 简单的媒体播放器，包含基本的组件：Slider组件、播放与停止按钮、静音按钮、关闭按钮、标题文本、当前时间文本、总时间文本
	 */
	public class SimpleMediaPlayer extends VisualPlayer 
	{
		protected var _slider:HSlider;				//水平滑动控件
		protected var _btnPlay:UIAsset;				//播放按钮
		protected var _btnStop:UIAsset;				//停止按钮
		protected var _btnMute:UIAsset;				//静音按钮
		protected var _btnVoice:UIAsset;				//发音按钮
		//protected var btnClose:Button;				//关闭按钮
		protected var contentTitle:Label;				//标题文本
		protected var labelCurTime:Label;			//当前时间文本
		protected var labelTotalTime:Label;			//总的时间文本
		protected var labelSlash:Label;				//斜线文本，用于分割时间文本
		protected var controllerBackground:Rect;			//背景
		protected var controllerContainer:Group;	//如上控件的容器
		
		public function SimpleMediaPlayer() 
		{
			super();
			this.horizontalCenter = 0;
			this.verticalCenter = 0;
		}
		
		/**
		 * 初始化组件
		 */
		override protected function initComponents():void
		{
			super.initComponents();
			
			initControllerBackground();
			initSlider();
			initBtnPlay();
			initBtnStop();
			initBtnMute();
			initBtnVoice();
			//initBtnClose();
			initLabelTitle();
			initLabelCurTime();
			initLabelTotalTime();
			initLabelSlash();
			initControllerContainer();
			
			layoutComponents();
		}
		
		/**
		 * 将控件放入控件容器
		 */
		protected function layoutComponents():void 
		{
			controllerContainer.addElement( _btnStop );
			controllerContainer.addElement( _btnPlay );
			controllerContainer.addElement( _btnMute );
			controllerContainer.addElement( _btnVoice );
			//controllerContainer.addElement( btnClose );
			controllerContainer.addElement( labelCurTime );
			controllerContainer.addElement( _slider );
			controllerContainer.addElement( labelTotalTime );
			controllerContainer.addElement( labelSlash );
			controllerContainer.bottom = 0;
			controllerContainer.horizontalCenter = 0;
			controllerContainer.percentWidth = 100;
			
			labelCurTime.left = 36;
			labelCurTime.bottom =18;
			
			labelTotalTime.right = 36;
			labelTotalTime.bottom = 18;
			
			_slider.left = 90;
			_slider.right =90;
			_slider.bottom = 20;
			
			this.btnPlay.bottom = 20;
			this.btnPlay.left = 10;
			
			this.btnStop.bottom = 20;
			this.btnStop.left = 10;
			
			this.btnVoice.bottom = 20;
			this.btnVoice.right = 6;
			this.btnMute.bottom = 20;
			this.btnMute.right = 10;
			trace("layout components..");
		}
		
		/**
		 * 初始化控件容器
		 */
		protected function initControllerContainer():void 
		{
			addElement( controllerContainer = new Group() );
		}
		
		/**
		 * 初始化背景
		 */
		protected function initControllerBackground():void
		{
			controllerBackground = new Rect();
			controllerBackground.height = 150;
			controllerBackground.fillColor = 0xf5f5f5;
			controllerBackground.percentWidth = 100;
		}
		
		/**
		 * 初始化斜线文本
		 */
		protected function initLabelSlash():void
		{
			labelSlash = new Label();
			labelSlash.text = "/";
			labelSlash.textColor = 0x000000;
			labelSlash.horizontalCenter = 0;
			labelSlash.verticalCenter = 0;
		}
		
		/**
		 * 初始化总时间文本
		 */
		protected function initLabelTotalTime():void 
		{
			labelTotalTime = new Label();
			labelTotalTime.text = "00:00:00";
			labelTotalTime.textColor = 0x93A0A4;
			labelTotalTime.size = 12;
		}
		
		/**
		 * 初始化当前时间文本
		 */
		protected function initLabelCurTime():void 
		{
			labelCurTime = new Label();
			labelCurTime.text = "00:00:00";
			labelCurTime.textColor = 0x93A0A4;
			labelCurTime.size = 12;
		}
		
		/**
		 * 初始化标题文本
		 */  
		protected function initLabelTitle():void 
		{
			contentTitle = new Label();
			contentTitle.text = "x.mp3";
			contentTitle.textColor = 0x4E595C;
			contentTitle.left = 50
			contentTitle.top = 10;
		}
		
		/**
		 * 初始化关闭按钮
		 */
		protected function initBtnClose():void 
		{
			//btnClose = new Button();
			//btnClose.skinName = TitleWindowCloseButtonSkin;
		}
		
		/**
		 * 初始化发音按钮
		 */
		protected function initBtnVoice():void 
		{
			_btnVoice = new Button();
			_btnVoice.maintainAspectRatio = true;
			_btnVoice.mouseChildren = true;
			_btnVoice.skinName = AssetsFactory.getInstance().getAsset('MuteButtonSkin');
			_btnVoice.bottom = 20;
		}
		
		/**
		 * 初始化静音按钮
		 */
		protected function initBtnMute():void 
		{
			_btnMute = new UIAsset();
			_btnMute.maintainAspectRatio = true;
			_btnMute.mouseChildren = true;
			_btnMute.skinName = AssetsFactory.getInstance().getAsset('PronunciationButtonSkin');
			_btnMute.bottom = 20;
		}
		
		/**
		 * 初始化停止按钮
		 */
		protected function initBtnStop():void 
		{
			_btnStop = new UIAsset();
			_btnStop.maintainAspectRatio = true;
			_btnStop.mouseChildren = true;
			_btnStop.skinName = AssetsFactory.getInstance().getAsset('SptopButtonsSkin');
		}
		
		/**
		 * 初始化播放按钮
		 */
		protected function initBtnPlay():void 
		{
			_btnPlay = new UIAsset();
			_btnPlay.maintainAspectRatio = true;
			_btnPlay.mouseChildren = true;
			_btnPlay.skinName = AssetsFactory.getInstance().getAsset('PlayButtonsSkin');
		}
		
		/**
		 * 初始化滑动条
		 */
		protected function initSlider():void 
		{
			_slider = new HSlider();
			_slider.skinName = HSliderSkin;
		}
		
		public function get slider():HSlider 
		{
			return _slider;
		}
		
		public function get btnPlay():UIAsset 
		{
			return _btnPlay;
		}
		
		public function get btnStop():UIAsset 
		{
			return _btnStop;
		}
		
		public function get btnMute():UIAsset 
		{
			return _btnMute;
		}
		
		public function get btnVoice():UIAsset 
		{
			return _btnVoice;
		}
		
	}

}