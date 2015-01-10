package tetequ.live.modules.room.cm.sanhao 
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
	import org.flexlite.domUI.layouts.VerticalAlign;
	import org.flexlite.domUI.layouts.VerticalLayout;
	import org.flexlite.domUI.skins.VectorSkin;
	import tetequ.live.core.assets.AssetsFactory;
	import tetequ.live.modules.room.common.button.AssetUnit;
	import tetequ.live.modules.room.common.GlobalVars;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 上课时，屏幕周围有一圈绿色
	 */
	public class CM_ClassRunningView extends Group 
	{
		private var _topLine:Rect;
		private var _bottomLine:Rect;
		private var _leftLine:Rect;
		private var _rightLine:Rect;
		private var _tips:Label;
		private var _group:Group;
		private var _leftTime:int;//毫秒
		private var _message:Label;
		private var _timer:Timer;
		
		public function CM_ClassRunningView(s:SingletonEnforcer) 
		{
			super();
			if (!s)
				throw new Error("单例不允许new！");
			initComponents();
		}
		
		private static var instance:CM_ClassRunningView;
		public static function getInstance():CM_ClassRunningView
		{
			return instance ||= new CM_ClassRunningView(new SingletonEnforcer());
		}
		
		private function initComponents():void 
		{
			percentWidth = 100;
			percentHeight = 100;
			horizontalCenter = 0;
			verticalCenter = 0;
			
			addElement(_topLine = drawRect(100,NaN,100,2,0,0,0,NaN,0x00ff00));
			addElement(_bottomLine = drawRect(100,NaN,100,2,0,0,NaN,0,0x00ff00));
			addElement(_leftLine = drawRect(NaN,100,2,100,0,NaN,0,0,0x00ff00));
			addElement(_rightLine = drawRect(NaN, 100, 2, 100, NaN, 0, 0, 0, 0x00ff00));
			addElement(_group = new Group());
			
			_group.addElement(_message=new Label());
			_group.addElement(_tips = new Label());
			_group.layout = new HorizontalLayout();
			_group.horizontalCenter = 0;
			HorizontalLayout(_group.layout).verticalAlign = VerticalAlign.MIDDLE;
			_group.bottom = 5;

			_message.text = '距离下课时间: ';
			_message.textColor = 0xffffff;
			_message.fontFamily = "微软雅黑";
			_message.size = 15;
			
			_tips.text = '00:00:00';
			_tips.textColor = 0xffffff;
			_tips.fontFamily = "微软雅黑";
			_tips.size = 20;
		}
		
		public function set leftTime(value:int):void
		{
			_leftTime = value;
		}
		
		/**
		 * 上课开始了
		 */
		public function handleClassAttend():void
		{
			_leftTime = getTimer();
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
			_tips.text = convertTimeToString(_leftTime-=1000);
		}
		
		/**
		 * 下课了
		 */
		public function handleClassFinished():void
		{
			if (stage)
			{
				Group(parent).removeElement(this);
			}
			
			stopTimer();
		}
	}
}

class SingletonEnforcer{}