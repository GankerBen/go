package tetequ.live.modules.room.recording.view 
{
	import com.e2et.ISession;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import org.flexlite.domUI.components.Alert;
	import org.flexlite.domUI.components.Button;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.components.Rect;
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.domUI.events.CloseEvent;
	import org.flexlite.domUI.layouts.HorizontalAlign;
	import org.flexlite.domUI.layouts.HorizontalLayout;
	import org.flexlite.domUI.layouts.VerticalLayout;
	import org.flexlite.domUI.skins.VectorSkin;
	import tetequ.live.core.assets.AssetsFactory;
	import tetequ.live.modules.room.common.GlobalVars;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 录制时，屏幕周围有一圈绿色
	 */
	public class RecordingView extends Group 
	{
		private var _topLine:Rect;
		private var _bottomLine:Rect;
		private var _leftLine:Rect;
		private var _rightLine:Rect;
		private var _tips:Label;
		private var _stopRecord:UIAsset;
		private var _group:Group;
		private var _startTime:int;
		private var _timer:Timer;
		
		public function RecordingView(s:SingletonEnforcer) 
		{
			super();
			if (!s)
				throw new Error("单例不允许new！");
			initComponents();
		}
		
		private static var instance:RecordingView;
		public static function getInstance():RecordingView
		{
			return instance ||= new RecordingView(new SingletonEnforcer());
		}
		
		private function initComponents():void 
		{
			this.percentWidth = 100;
			this.percentHeight = 100;
			
			addElement(_topLine = drawLine(100,NaN,100,2,0,0,0,NaN,0x00ff00));
			addElement(_bottomLine = drawLine(100,NaN,100,2,0,0,NaN,0,0x00ff00));
			addElement(_leftLine = drawLine(NaN,100,2,100,0,NaN,0,0,0x00ff00));
			addElement(_rightLine = drawLine(NaN, 100, 2, 100, NaN, 0, 0, 0, 0x00ff00));
			addElement(_group = new Group());
			
			_group.addElement(_stopRecord = new UIAsset());
			_group.addElement(_tips = new Label());
			_group.layout = new HorizontalLayout();
			_group.horizontalCenter = 0;
			_group.top = 5;

			_tips.text = '00:00:00';
			_tips.textColor = 0xffffff;
			_tips.fontFamily = "微软雅黑";
			_tips.horizontalCenter = 0;
			_tips.size = 20;
	
			_stopRecord.skinName = AssetsFactory.getInstance().getAsset('tingzhiluzhiSkin');
			_stopRecord.mouseChildren = true;
			_stopRecord.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onClick(e:MouseEvent):void 
		{
			
			
			if (GlobalVars.language == GlobalVars.LANG_ENGLISH)
			{
				//英文
				Alert.show( "Are you sure you want to stop recording it?", "", onClose, "确定", "取消"  );
			}else if(GlobalVars.language == GlobalVars.LANG_CHINESE)
			{
				//中文
				Alert.show( "您确定要停止录制吗?", "", onClose, "确定", "取消"  );
			}else
			{
				throw new Error('无法识别的语言！');
			}
			

			function onClose( e:CloseEvent ):void
			{
				switch( CloseEvent(e).detail )
				{
					case Alert.FIRST_BUTTON:
						dispatchEvent(new Event(Event.CANCEL));
						break;
					case Alert.SECOND_BUTTON:case Alert.CLOSE_BUTTON:
						break;
					default:
						break;
				}
			}
		}
		
		/**
		 * 录制开始了
		 * @param	$
		 * @param	videoId
		 */
		public function handleRecordStarted ($:ISession, videoId:String):void
		{
			_startTime = getTimer();
			startTimer();
		}
		
		private function startTimer():void
		{
			if (!_timer)
			{
				_timer = new Timer(1000);
			}
			
			_timer.reset();
			_timer.addEventListener(TimerEvent.TIMER, onTimer);
			_timer.start();
		}
		
		private function stopTimer():void
		{
			_timer.removeEventListener(TimerEvent.TIMER, onTimer);
			_timer.stop();
		}
		
		private function onTimer(e:TimerEvent):void 
		{
			_tips.text = convertTimeToString(getTimer()-_startTime);
		}
		
		/**
		 * 录制结束了
		 * @param	$
		 */
		public function handleRecordStopped ($:ISession):void
		{
			_startTime = 0;
			stopTimer();
			if (GlobalVars.language == GlobalVars.LANG_ENGLISH)
			{
				//英文
				Alert.show( "Recording has ended!", "", null, "确定"  );
			}else if(GlobalVars.language == GlobalVars.LANG_CHINESE)
			{
				//中文
				Alert.show( "录制已经结束了！", "", null, "确定"  );
			}else
			{
				throw new Error('无法识别的语言！');
			}
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
			return convertUnit( h ) + ":" + convertUnit( m ) + ":" + convertUnit( s );
		}
		
		protected static function convertUnit( u:int ):String
		{
			return u >= 10 ? u.toString() : "0" + u.toString();
		}
		
		private function drawLine(percentWidth:Number, percentHeight:Number, width:Number, height:Number, left:Number, right:Number, top:Number, bottom:Number, color:uint):Rect
		{
			var rect:Rect = new Rect();
			rect.percentWidth = percentWidth;
			rect.percentHeight = percentHeight;
			rect.width = width;
			rect.height = height;
			rect.fillColor = color;
			rect.left = left;
			rect.right = right;
			rect.top = top;
			rect.bottom = bottom;
			return rect;
		}
	}

}

class SingletonEnforcer{}