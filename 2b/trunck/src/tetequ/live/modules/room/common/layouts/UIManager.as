package tetequ.live.modules.room.common.layouts 
{
	import flash.events.IEventDispatcher;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import framework.view.UIRoot;
	import org.flexlite.domUI.core.IVisualElement;
	import tetequ.live.modules.room.common.layouts.events.StartupLayoutEvent;
	import tetequ.live.utils.HashMap;
	/**
	 * ...
	 * @author Pandazhong
	 * 负责切换界面布局
	 */
	public class UIManager 
	{	
		/**
		 * UI顶层容器
		 */
		[Inject]
		public var uiRoot:UIRoot;
		
		[Inject]
		public var eventDispatcher:IEventDispatcher;
		
		/**
		 * 当前的界面类型
		 */
		private var _curType:String;
		
		/**
		 * 布局管理器集合
		 */
		private var _layoutDirectors:HashMap;
		
		/**
		 * 构造函数
		 */
		public function UIManager() 
		{
			init();
		}
		
		/**
		 * 初始化
		 */
		private function init():void 
		{
			_layoutDirectors = new HashMap();
		}
		
		/**
		 * 注册布局管理器
		 * @param	type	布局管理器类型
		 * @param	layoutDirector	布局管理器实例
		 */
		public function registerLayoutDirector( type:String, layoutDirector:ILayoutDirector ):void
		{
			if ( !_layoutDirectors.containsKey( type ) )
			{
				_layoutDirectors.put( type, layoutDirector );
			}
		}
		
		/**
		 * 获取当前正在使用的布局管理器
		 * @return
		 */
		public final function getCurLayoutDirector():ILayoutDirector
		{
			return _layoutDirectors.getValue( _curType );
		}
		
		/**
		 * 启动指定类型的界面布局
		 * @param	type
		 */
		public function startupLayout( type:String ):void
		{
			if ( !_layoutDirectors.containsKey( type ) )
				throw new Error( "指定类型的布局管理器不存在!type:" + type );
				
			if ( _curType == type ) return;
			
			var director:IVisualElement = _layoutDirectors.getValue( _curType );
			
			if ( director )
			{
				if ( uiRoot.containsElement( director ) )
				{
					uiRoot.removeElement( director );
				}
			}
			
			uiRoot.addElement( _layoutDirectors.getValue( _curType = type ) );
		}
		
	}

}