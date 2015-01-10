package tetequ.live.modules.room.doc.players.media.audio.common 
{
	import org.flexlite.domUI.components.Button;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.HSlider;
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.components.Rect;
	import org.flexlite.domUI.components.TitleWindow;
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.domUI.layouts.HorizontalLayout;
	import org.flexlite.domUI.layouts.VerticalLayout;
	import org.flexlite.domUI.skins.vector.ButtonSkin;
	import org.flexlite.domUI.skins.vector.HSliderSkin;
	import org.flexlite.skin.CloseButtonSkin;
	import org.flexlite.skin.MuteButtonSkin;
	import org.flexlite.skin.PlayButtonsSkin;
	import org.flexlite.skin.PronunciationButtonSkin;
	import org.flexlite.skin.SptopButtonsSkin;
	import tetequ.live.core.assets.AssetsFactory;
	import tetequ.live.modules.room.common.GlobalVars;
	import tetequ.live.modules.room.doc.players.common.interfaces.IContent;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class AudioPlayer extends TitleWindow 
	{
		
		protected var _slider:HSlider;				//水平滑动控件
		protected var _btnPlay:UIAsset;				//播放按钮
		protected var _btnStop:UIAsset;				//停止按钮
		protected var _btnMute:UIAsset;				//静音按钮
		protected var _btnVoice:UIAsset;				//发音按钮
		protected var _btnClose:UIAsset;				//关闭按钮
		protected var contentTitle:Label;				//标题文本
		protected var labelCurTime:Label;			//当前时间文本
		protected var labelTotalTime:Label;			//总的时间文本
		protected var labelSlash:Label;				//斜线文本，用于分割时间文本
		protected var controllerBackground:Rect;			//背景
		protected var controllerContainer:Group;	//如上控件的容器
		protected var txtGroup:Group;				//文本所在容器
		protected var titleGroup:Group;
		protected var txtBg:Rect;
		
		protected var content:IContent;
		protected var totalTime:int;
		
		protected var titleBg :Rect ;
		
		protected const TITLE_HEIGHT :int = 30;
		
		//标题栏logo
		private var _titieLogo:UIAsset;
		
		public function AudioPlayer() 
		{
			super();
			initComponents();
		}
		/**
		 * 初始化组件
		 */
		protected function initComponents():void
		{
			this.layout = new VerticalLayout();
			VerticalLayout(this.layout).gap = 0;
			initTxtGroup();
			initTxtBG();
			initControllerBackground();
			initSlider();
			initBtnPlay();
			initBtnStop();
			initBtnMute();
			initBtnVoice();
			initBtnClose();
			initLabelTitle();
			initLabelCurTime();
			initLabelTotalTime();
			initLabelSlash();
			initControllerContainer();

			layoutComponents();
			
			this.horizontalCenter = 0;
			this.filters = [GlobalVars.LAYOUT_ELEMENT_FILTERS];
			this.width = 390;
			this.height = 110;
		}
		
		public function setContent( content:IContent ):void
		{
			this.content = content;
		}
		
		public function getContent():IContent
		{
			return this.content;
		}
		
		//文本背景呢
		protected function initTxtBG():void 
		{
			txtBg = new Rect();
			txtBg.fillColor = 0xcccccc;
			txtBg.percentWidth = 100;
			txtBg.percentHeight = 100;
		}
		
		//初始化文本容器
		protected function initTxtGroup():void 
		{
			addElement( txtGroup = new Group() );
			txtGroup.bottom = 10;
			txtGroup.percentWidth = 100;
		}
		
		/**
		 * 将控件放入控件容器
		 */
		protected function layoutComponents():void 
		{
			controllerContainer.addElement( controllerBackground );
			controllerContainer.addElement( _btnStop );
			controllerContainer.addElement( _btnPlay );
			controllerContainer.addElement( _btnMute );
			controllerContainer.addElement( _btnVoice );
			controllerContainer.addElement( _slider );
			controllerContainer.bottom = 0;
			controllerContainer.horizontalCenter = 0;
			controllerContainer.percentWidth = 100;
			controllerContainer.addElement( labelCurTime );
			controllerContainer.addElement( labelTotalTime );
			
			labelCurTime.left = 36;
			labelCurTime.bottom = 48;
			
			labelTotalTime.right = 36;
			labelTotalTime.bottom = 48;
			
			_slider.left = 75;
			_slider.right = 75;
			_slider.bottom = 50;
			
			this.btnPlay.bottom = 50;
			this.btnPlay.left = 5;
			
			this.btnStop.bottom = 50;
			this.btnStop.left = 10;
			
			this.btnVoice.bottom = 50;
			this.btnVoice.right = 10;
			this.btnMute.bottom = 50;
			this.btnMute.right = 10;
		}
		
		/**
		 * 初始化控件容器
		 */
		protected function initControllerContainer():void 
		{
			addElement( controllerContainer = new Group() );
			controllerContainer.bottom = 10;
			controllerContainer.percentWidth = 100;
		}
		
		/**
		 * 初始化背景
		 */
		protected function initControllerBackground():void
		{
			controllerBackground = new Rect();
			controllerBackground.height = 110;
			controllerBackground.fillColor = 0xcccccc;
			controllerBackground.percentWidth = 100;
		}
		
		/**
		 * 初始化斜线文本
		 */
		protected function initLabelSlash():void
		{

		}
		
		/**
		 * 初始化总时间文本
		 */
		protected function initLabelTotalTime():void 
		{
			labelTotalTime = new Label();
			labelTotalTime.text = "00:00";
			labelTotalTime.size = 12;
			labelTotalTime.textColor = 0x93A0A4;
			labelTotalTime.right = 10;
			labelTotalTime.bottom = 37;
		}
		
		/**
		 * 初始化当前时间文本
		 */
		protected function initLabelCurTime():void 
		{
			labelCurTime = new Label();
			labelCurTime.text = "00:00";
			labelCurTime.size = 12;
			labelCurTime.textColor = 0x93A0A4;
		}
		
		/**
		 * 初始化标题文本
		 */
		protected function initLabelTitle():void 
		{
			contentTitle = new Label();
			contentTitle.text = "";
			contentTitle.textColor = 0x4E595C;
		}

		/**
		 * 初始化关闭按钮
		 */
		protected function initBtnClose():void 
		{
			
		}
		
		/**
		 * 初始化发音按钮
		 */
		protected function initBtnVoice():void 
		{
			_btnVoice = new UIAsset();
			_btnVoice.maintainAspectRatio = true;
			_btnVoice.mouseChildren = true;
			_btnVoice.skinName = AssetsFactory.getInstance().getAsset('MuteButtonSkin' );
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
			_btnMute.skinName = AssetsFactory.getInstance().getAsset('PronunciationButtonSkin' );
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
			_btnStop.skinName = AssetsFactory.getInstance().getAsset('SptopButtonsSkin' );
			_btnStop.bottom = 20;
		}
		
		/**
		 * 初始化播放按钮
		 */
		protected function initBtnPlay():void 
		{
			_btnPlay = new Button();
			_btnPlay.maintainAspectRatio = true;
			_btnPlay.mouseChildren = true;
			_btnPlay.skinName = AssetsFactory.getInstance().getAsset('PlayButtonsSkin' );
			_btnPlay.bottom = 20;
		}
		
		/**
		 * 初始化滑动条
		 */
		protected function initSlider():void 
		{
			_slider = new HSlider();
			_slider.skinName = HSliderSkin;
			_slider.bottom = 20;
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
		
		public function get btnClose():UIAsset 
		{
			return _btnClose;
		}
		
		public function get slider():HSlider 
		{
			return _slider;
		}
		
		public function setContentTitle( value:String ):void
		{
			contentTitle.text = value;
		}
		
		public function setTotalTime( value:int ):void
		{
			if ( value == totalTime ) return;
			labelTotalTime.text = convertTimeToString( value );
			_slider.maximum = value;
		}
		
		/**
		 * 毫秒转换为时分秒字符串
		 * @param	ms
		 * @return
		 */
		protected static function convertTimeToString( ms:int ):String
		{
			var h:int = int(ms / (1000 * 3600));
			var m:int = int((ms - h * 1000 * 3600) / (60 * 1000) );
			var s:int = int( (ms - m * 60 * 1000 - h * 3600 * 1000 ) / 1000 );
			return convertUnit( m ) + ":" + convertUnit( s );
		}
		
		protected static function convertUnit( u:int ):String
		{
			return u >= 10 ? u.toString() : "0" + u.toString();
		}
		
		public function setCurrentTime( value:int ):void
		{
			labelCurTime.text = convertTimeToString( value );
		}
	}

}