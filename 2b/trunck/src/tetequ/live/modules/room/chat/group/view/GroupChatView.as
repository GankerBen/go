package tetequ.live.modules.room.chat.group.view 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import org.flexlite.domUI.components.Button;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.components.Panel;
	import org.flexlite.domUI.components.Rect;
	import org.flexlite.domUI.components.RectangularDropShadow;
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.domUI.components.VScrollBar;
	import org.flexlite.domUI.layouts.HorizontalLayout;
	import org.flexlite.domUI.layouts.VerticalLayout;
	import org.flexlite.domUI.utils.callLater;
	import org.flexlite.skin.UserButtonSkin;
	import tetequ.live.core.assets.AssetsFactory;
	import tetequ.live.modules.room.chat.common.message.ChatMessageItemView;
	import tetequ.live.modules.room.chat.input.view.GroupChatInputView;
	import tetequ.live.modules.room.common.GlobalVars;
	import tetequ.live.modules.room.common.layouts.LayoutElementsID;
	import tetequ.live.modules.room.common.panel.BasePanel;
	import tetequ.live.modules.room.common.panel.PanelID;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 群聊消息显示界面UI
	 */
	
	public class GroupChatView extends Group
	{
		/**
		 * 垂直滑动条
		 */
		private var _scroller:VScrollBar;
		
		/**
		 * 消息显示面板
		 */
		private var _messagePanel:Group;
		
		/**
		 * 背景区域
		 */
		
		private var _bg:Rect;
		
		/**
		 * 背景区域左边的线条
		 */
		private var _line:Rect;
		
		/**
		 * 上面的条
		 */
		private var _article:Rect;
		
		/**
		 * 在线用户
		 */
		private var _onlineUsers:Label;
		private var _numUsers:Label;
		private var _labels:Group;
		private var _line2:Rect;
		private var _line3:Rect;
		
		/**
		 * 用户
		 */
		
		private var _btnUser:UIAsset;
		
		private const FILTERS:Array = [new DropShadowFilter( 1, 90, 0, 0.1 )];
		
		/**
		 * 输入框
		 */
		private var _input:GroupChatInputView;
		
		private static const MAX_MESSAGE:int = 500;//目前最多支持500条消息
		
		/**
		 * 构造函数
		 */
		
		public function GroupChatView() 
		{
			super();
			init();
		}
		
		/**
		 * 初始化
		 */
		private function init():void 
		{
			addElement( _bg = new Rect() );
			_bg.percentWidth = 100;
			_bg.percentHeight = 100;
			_bg.left = 1;
			_bg.filters = [GlobalVars.LAYOUT_ELEMENT_FILTERS];
			_bg.fillColor = 0x666666;
			//_bg.fillColor = 0x002a47;
			_bg.visible = true;
			_bg.alpha = 0.5;
			
			addElement ( _article = new Rect ());
			_article.percentWidth = 100;
			_article.height = 40;
			_article.fillColor = 0x222222;
			_article.alpha = 0.5;
			
			addElement(_line = new Rect());
			_line.percentHeight = 100;
			_line.width = 1;
			_line.fillColor = 0x888888;
			
			addElement(_labels = new Group());
			//_labels.horizontalCenter = 0;
			_labels.top = 10;
			_labels.layout = new HorizontalLayout();
			_labels.left = 10;
			
			addElement(_line2 = new Rect());
			_line2.percentWidth = 100;
			_line2.height = 1;
			_line2.fillColor = 0x888888;
			_line2.top = 41;
			
			//addElement(_line3 = new Rect());
			//_line3.percentWidth = 100;
			//_line3.height = 1;
			//_line3.fillColor = 0x888888;
			//_line3.bottom = 54;
			
			_labels.addElement (_numUsers = new Label ());
			_numUsers.text = "0";
			_numUsers.textColor = 0xff3300;
			_numUsers.size = 14;
			
			_labels.addElement (_onlineUsers = new Label ());
			//if (isVisitor(GlobalVars.networkFacade.user))
			//{
				//_onlineUsers.visible = false;
				//_numUsers.visible = false;
			//}
			
			if (GlobalVars.language == GlobalVars.LANG_ENGLISH)
			{
				//英文
				_onlineUsers.text = "Online";
			}else if(GlobalVars.language == GlobalVars.LANG_CHINESE)
			{
				//中文
				_onlineUsers.text = "人在线";

			}else
			{
				throw new Error('无法识别的语言！');
			}
			
			
			_onlineUsers.width = 100;
			_onlineUsers.textColor = 0xaaaaaa;
			_onlineUsers.size = 14;
			_onlineUsers.right = 10;
			
			addElement ( _btnUser = new UIAsset ());
			_btnUser.maintainAspectRatio = true;
			_btnUser.mouseChildren = true;
			_btnUser.skinName = AssetsFactory.getInstance().getAsset('UserButtonSkin');
			_btnUser.horizontalCenter = 10;
			_btnUser.top = 2;
			langTipsConfigure(_btnUser, '用户列表', 'user list');
			
			addElement( _messagePanel = new Group() );
			
			_messagePanel.layout = new VerticalLayout();
			VerticalLayout(_messagePanel.layout).paddingTop = 10;
			VerticalLayout(_messagePanel.layout).gap = 20;
			VerticalLayout(_messagePanel.layout).paddingBottom = 15;
			_messagePanel.top = 50;
			_messagePanel.left = 10;
			_messagePanel.right = 10;
			_messagePanel.bottom = 65;
			_messagePanel.visible = true;
			
			this.addElement( _scroller = new VScrollBar() );
			_scroller.viewport = _messagePanel;
			_scroller.top = 50;
			_scroller.bottom = 65;
			_scroller.right = 0;
			_scroller.visible = true;
			_scroller.alpha = 0;
			
			this.minWidth = 100;
			this.width = 255;
			this.percentHeight = 100;
			this.id = LayoutElementsID.GROUP_MESSAGE;
			
			addElement( _input = new GroupChatInputView() );
			_input.bottom = 13;
		}
		
		/**
		 * 添加一条聊天消息
		 * FIXME:目前消息理论上支持无限添加，但随着发言数增加，势必会造成性能问题。
		 * @param	msg
		 */
		public function addMessage( msg:ChatMessageItemView ):void
		{
			if ( _messagePanel.numChildren >= MAX_MESSAGE )
			{
				_messagePanel.removeElementAt(0);
			}
			
			_messagePanel.addElement( msg );
			_messagePanel.addEventListener( Event.ENTER_FRAME, onEnterFrame );
		}
		
		/**
		 * 延迟调用
		 * @param	e
		 */
		private function onEnterFrame(e:Event):void 
		{
			_messagePanel.removeEventListener( Event.ENTER_FRAME, onEnterFrame );
			_messagePanel.verticalScrollPosition = _messagePanel.contentHeight - _messagePanel.height;
		}
		
		/**
		 * 刷新在线人数
		 * @param	num
		 */
		public function refreshUserNum( num:uint ):void
		{
			_numUsers.text = num.toString ();
		}
		
		public function get scroller():VScrollBar 
		{
			return _scroller;
		}
		public function get btnUser ():UIAsset 
		{
			return _btnUser;
		}
	}
}