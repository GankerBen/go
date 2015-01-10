package tetequ.live.modules.room.userlist.view 
{
	import flash.events.Event;
	import org.flexlite.domUI.components.Button;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.components.Rect;
	import org.flexlite.domUI.components.ToggleButton;
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.domUI.components.VScrollBar;
	import org.flexlite.domUI.layouts.HorizontalLayout;
	import org.flexlite.domUI.layouts.VerticalLayout;
	import org.flexlite.domUI.skins.vector.ButtonSkin;
	import org.flexlite.domUI.skins.vector.ToggleButtonSkin;
	import tetequ.live.modules.room.common.layouts.LayoutElementsID;
	import tetequ.live.modules.room.common.panel.BasePanel;
	import tetequ.live.modules.room.common.panel.PanelID;
	import tetequ.live.utils.HashMap;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 用户列表界面UI
	 */
	public class UserListView extends BasePanel 
	{
		/**
		 * 用户列表组
		 */
		private var _itemsGroup:Group;
		
		/**
		 * 垂直滑动条
		 */
		private var _vscroller:VScrollBar;
		
		/**
		 * 存储用户与显示条目的映射关系
		 * 方便操作指定用户的显示条目
		 */
		private var _itemsHash:HashMap;
		
		/**
		 * 背景区域
		 */
		private var _background:Rect;
		
		//标题栏
		private var _titleGroup:Group;
		
		//标题背景
		private var _titleBg:Rect;
		
		//标题栏logo
		private var _titieLogo:UIAsset;
		
		private const TITLE_HEIGHT:int = 30;
		
		//主背景用于添加滤镜
		private var _bg:Rect;
		
		//用户数量
		public static var _userNum:uint;
		private var _txtUserNum:Label;
		
		private var _line:Rect;
		private var _contentBg:Rect;
		
		/**
		 * 构造函数
		 */
		public function UserListView(single:SingletonEnforcer) 
		{
			super();
			if (!single)
				throw new Error('please call getInstance');
			init();
		}
		
		private static var instance:UserListView;
		public static function getInstance():UserListView
		{
			return instance = instance || new UserListView(new SingletonEnforcer());
		}
		
		/**
		 * 初始化组件
		 */
		private function init():void 
		{
			this.width = 350;
			this.height = 450;
			
			_itemsHash = new HashMap();
			trace ( _userNum +"=====================================");
			addElement( _bg = new Rect() );
			_bg.percentWidth = 100;
			_bg.percentHeight = 100;
			_bg.fillColor = 0xffffff;
			_bg.fillAlpha = 0;
			
			this.addElement(_line = new Rect());
			_line.height = 1;
			_line.percentWidth = 100;
			_line.fillColor = 0xaaaaaa;
			_line.top = 6;
			
			this.addElement(_contentBg = new Rect());
			_contentBg.percentWidth = 100;
			_contentBg.top = 7;
			_contentBg.bottom = 0;
			_contentBg.fillColor = 0xbbbbbb;

			this.title = "";

			addElement( _itemsGroup = new Group() );
			_itemsGroup.layout = new VerticalLayout();
			_itemsGroup.top = 20;
			_itemsGroup.left = 0;
			_itemsGroup.bottom = 0;
			_itemsGroup.percentWidth = 100;
			
			VerticalLayout(_itemsGroup.layout).gap = 10;
			VerticalLayout(_itemsGroup.layout).paddingTop = 10;
			
			addElement( _vscroller = new VScrollBar() );
			_vscroller.viewport = _itemsGroup;
			_vscroller.top = 20;
			_vscroller.bottom = 0;
			_vscroller.right = 0;
			
			this.id = LayoutElementsID.USER_LIST;
			this.horizontalCenter = 0;
			this.verticalCenter = 0;
			this.visible = false;
		}
		
		/**
		 * 向用户列表添加一个用户项目
		 * @param	item
		 */
		public function addUserItem( item:UserInfoItemView ):void
		{
			if ( _itemsHash.containsKey( item.vo.userid ) ) return;
			_itemsHash.put( item.vo.userid, item );
			_itemsGroup.addElement( item );
			_userNum++;
			invalidate();
		}
		
		/**
		 * 根据用户id获取用户显示对象
		 * @param	userId
		 * @return
		 */
		public function getUseItem( userId:String ):UserInfoItemView
		{
			return _itemsHash.getValue( userId );
		}
		
		/**
		 * 根据用户id删除一条用户栏目
		 * @param	userId
		 */
		public function removeUserItem( userId:String ):void
		{
			if ( !_itemsHash.containsKey( userId ) )
				throw new Error( "不存在id为 " + userId + " 的用户!" );
			
			var item:UserInfoItemView = _itemsHash.getValue( userId );
			_itemsGroup.removeElement( item );
			_itemsHash.remove( userId );
			_userNum--;
			invalidate();
		}
		
		/**
		 * 显示列表中是否存在指定用户
		 * @param	userId
		 * @return
		 */
		public function hasUser( userId:String ):Boolean
		{
			return _itemsHash.containsKey( userId );
		}
		
		/**
		 * 延迟刷新
		 */
		private function invalidate():void
		{
			_itemsGroup.addEventListener( Event.ENTER_FRAME, onInvalidate );
		}
		
		/**
		 * 延迟刷新滑块位置
		 * @param	e
		 */
		private function onInvalidate(e:Event):void 
		{
			_itemsGroup.removeEventListener( Event.ENTER_FRAME, onInvalidate );
			_itemsGroup.verticalScrollPosition = _itemsGroup.contentHeight - _itemsGroup.height;
			//this.title = "在线用户 " + _userNum + " 人";
			
		}
		
		public function get vscroller():VScrollBar 
		{
			return _vscroller;
		}
		
		public function get itemsHash():HashMap 
		{
			return _itemsHash;
		}
		
		override public function get panelId():int
		{
			return PanelID.USER_LIST;
		}	
	}
}

class SingletonEnforcer
{
	
}