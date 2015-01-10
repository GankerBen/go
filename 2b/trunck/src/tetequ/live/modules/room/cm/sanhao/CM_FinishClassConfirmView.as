package tetequ.live.modules.room.cm.sanhao 
{
	import flash.events.MouseEvent;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.components.Rect;
	import org.flexlite.domUI.components.TitleWindow;
	import org.flexlite.domUI.layouts.HorizontalLayout;
	import org.flexlite.domUI.layouts.VerticalAlign;
	import tetequ.live.modules.room.common.button.AssetUnit;
	import tetequ.live.modules.room.common.GlobalVars;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 学生端下课确认面板
	 */
	public class CM_FinishClassConfirmView extends TitleWindow 
	{
		private var _message:Label;
		private var _btnSure:AssetUnit;
		private var _group:Group;
		
		public function CM_FinishClassConfirmView(single:SingletonEnforcer) 
		{
			super();
			if (!single)
				throw new Error('please call getInstance');
			initComponents();
		}
		
		private static var instance:CM_FinishClassConfirmView;
		public static function getInstance():CM_FinishClassConfirmView
		{
			return instance = instance || new CM_FinishClassConfirmView(new SingletonEnforcer());
		}
		
		private function initComponents():void 
		{
			this.percentWidth = 100;
			this.percentHeight = 100;
			this.horizontalCenter = 0;
			this.verticalCenter = 0;
			this.showCloseButton = false;
			
			addElement(_group = new Group());
			_group.horizontalCenter = 0;
			_group.verticalCenter = 0;
			_group.layout = new HorizontalLayout();
			
			_group.addElement(_message = new Label());
			_message.text = '课程已结束，感谢您的参与，请点击<确定>按钮:)';
			_message.fontFamily = '微软雅黑';
			
			HorizontalLayout(_group.layout).verticalAlign = VerticalAlign.MIDDLE;

			_group.addElement(_btnSure = new AssetUnit('quedingSkin', true));
			_btnSure.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function onClick(e:MouseEvent):void 
		{
			switch(e.currentTarget)
			{
				case _btnSure:
					// TODO:结账下课
					CM_SANHAO_WebServer.getInstance().finishClassConfirm(GlobalVars.user_session, GlobalVars.room_id);
					break;
				default:
					break;
			}
		}	
	}
}

class SingletonEnforcer
{
	
}