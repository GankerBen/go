package tetequ.live.modules.room.chat.privates.view 
{
	import com.e2et.datalogic.User;
	import flash.events.MouseEvent;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Rect;
	import org.flexlite.domUI.components.UIAsset;
	import tetequ.live.core.assets.AssetsFactory;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 私聊界面
	 */
	public class PrivateChatView extends Group 
	{
		private var _btnClose:UIAsset;
		private var _toUser:User;//跟谁私聊
		private var _msgPanel:PrivateMessagePanel;
		
		public function PrivateChatView(toUser:User, msgPanel:PrivateMessagePanel) 
		{
			super();
			_toUser = toUser;
			_msgPanel = msgPanel;
			initComponents();
		}
		
		private function initComponents():void 
		{
			addElement(_msgPanel);
			
			addElement(_btnClose = new UIAsset());
			_btnClose.mouseChildren = true;
			_btnClose.skinName = AssetsFactory.getInstance().getAsset('CloseButtonSkin');
			_btnClose.top = 10;
			_btnClose.right = 10;
			var ths:PrivateChatView = this;
			_btnClose.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
			{
				if (stage)
					Group(parent).removeElement(ths);
			});
			this.height = 500;
			this.width = 300;
		}
		
	}

}