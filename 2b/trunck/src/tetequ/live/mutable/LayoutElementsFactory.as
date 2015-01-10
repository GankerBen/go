package tetequ.live.mutable 
{
	import org.flexlite.domUI.core.IVisualElement;
	//import tetequ.live.modules.room.avfullscreen.view.AVFullScreenView;
	import tetequ.live.modules.room.avreq.view.AVReqView;
	import tetequ.live.modules.room.chat.group.view.GroupChatView;
	import tetequ.live.modules.room.chat.input.view.GroupChatInputView;
	import tetequ.live.modules.room.common.layouts.LayoutElementsID;
	import tetequ.live.modules.room.navigation.master.view.MasterNavigationView;
	import tetequ.live.modules.room.navigation.normal.view.NormalNavigationView;
	//import tetequ.live.modules.room.stream.video.master.view.MultiAVView;
	import tetequ.live.modules.room.userlist.view.UserListView;
	import tetequ.live.utils.HashMap;
	/**
	 * ...
	 * @author Pandazhong
	 * 布局元素工厂
	 */
	public class LayoutElementsFactory 
	{
		private var _classMapper:HashMap;
		private var _instanceMapper:HashMap;
		private var _initialized:Boolean;
		
		/**
		 * 构造函数
		 */
		public function LayoutElementsFactory() 
		{
			init();
		}
		
		private function init():void 
		{
			_classMapper = new HashMap();
			_instanceMapper = new HashMap();
		}
		
		public function registerAll():void
		{
			_classMapper.put( LayoutElementsID.GROUP_CHAT_INPUT, GroupChatInputView );
			//_classMapper.put( LayoutElementsID.MASTER_MEDIA, MultiAVView );
			_classMapper.put( LayoutElementsID.MASTER_NAVIGATION, MasterNavigationView );
			//_classMapper.put( LayoutElementsID.STUDENT_MEDIA, MultiAVView );
			_classMapper.put( LayoutElementsID.STUDENT_NAVIGATION, NormalNavigationView );
			_classMapper.put( LayoutElementsID.USER_LIST, UserListView );
			_classMapper.put( LayoutElementsID.GROUP_MESSAGE, GroupChatView );
			//_classMapper.put( LayoutElementsID.MASTER_AD, MasterADView );
			//_classMapper.put( LayoutElementsID.STUDENT_AD, StudentADView );
			_classMapper.put( LayoutElementsID.AV_REQ, AVReqView );
			//_classMapper.put( LayoutElementsID.AV_FULLSCREEN, AVFullScreenView );
			
			_initialized = true;
		}
		
		public function getInstance( id:String ):IVisualElement
		{
			if ( !_classMapper.containsKey( id ) )
				throw new Error( "获取布局元素实例失败,未知的布局元素类型!id:" + id );
			var instance:IVisualElement = _instanceMapper.getValue( id );
			if ( !instance )
				_instanceMapper.put( id, instance = IVisualElement( new ( _classMapper.getValue( id ) as Class ) ) );
			return instance;
		}
		
		public function get initialized():Boolean 
		{
			return _initialized;
		}
		
	}

}