package tetequ.live.modules.room.common.panel 
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import framework.view.UIRoot;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.TitleWindow;
	import org.flexlite.domUI.core.DomGlobals;
	import org.flexlite.domUI.core.IVisualElement;
	import org.flexlite.domUI.events.PopUpEvent;
	import org.flexlite.domUI.managers.PopUpManager;
	import tetequ.live.utils.HashMap;
	/**
	 * ...
	 * @author Pandazhong
	 * 面板管理者
	 */
	public class PanelManager 
	{
		[Inject]
		public var ui:UIRoot;
		
		[Inject]
		public var factory:PanelFactory;
		
		/**
		 * 包含所有面板
		 */
		private var _panels:HashMap;
		
		/**
		 * 单例
		 */
		private static var instance:PanelManager;
		
		/**
		 * 构造函数
		 */
		public function PanelManager( singletonEnforcer:SingletonEnforcer ) 
		{
			if ( !singletonEnforcer ) throw new Error( "单例不允许直接调用构造函数，请调用getInstance()!" );
			init();
		}
		
		/**
		 * 获取单例
		 * @return
		 */
		public static function getInstance():PanelManager
		{
			return instance ||= new PanelManager( new SingletonEnforcer() );
		}

		/**
		 * 初始化
		 */
		private function init():void 
		{
			_panels = new HashMap();
		}
		
		/**
		 * 注册面板
		 * @param	panel
		 */
		private function registerPanel( panel:IPanel ):void
		{
			if ( !_panels.containsKey( panel.panelId ) )
			{
				_panels.put( panel.panelId, panel );
			}else {
				throw new Error( "ID为 " + panel.panelId + " 的面板已经注册了!" );
			}
		}
		
		/**
		 * 根据指定id打开对应面板
		 * @param	id
		 */
		public function openPanel( id:int ):void
		{
			var panel:TitleWindow = TitleWindow(getPanel( id ));//面板都必须是Group的子类

			if ( isOpened( id ) ) {
				return;
			}
			PopUpManager.addPopUp( panel, false, false, ui );
			panel.horizontalCenter = 0;
			panel.verticalCenter = 0;
		}
		
		/**
		 * 关闭指定id对应的面板
		 * @param	id
		 */
		public function closePanel( id:int ):void
		{
			if ( !_panels.containsKey( id ) )
			{
				throw new Error( "关闭面板失败!错误原因:面板id " + id + " 不存在!" );
			}
			if ( !isOpened( id ) ) {
				return;
			}
			var panel:TitleWindow = TitleWindow(getPanel( id ));
			if ( !panel ) return;
			PopUpManager.removePopUp( panel );
		}
		
		/**
		 * 根据id获取面板
		 * @param	id
		 * @return
		 */
		public function getPanel( id:int ):IPanel
		{
			if ( !_panels.containsKey( id ) )
			{
				_panels.put( id, factory.getPanelInstance( id ) );
			}
			return _panels.getValue( id );
		}
		
		/**
		 * 指定id的面板是否已经注册
		 * @param	id
		 * @return
		 */
		public function containsPanel( id:int ):Boolean
		{
			return _panels.containsKey( id );
		}
		
		/**
		 * 指定id对应的面板是否已打开
		 * @param	id
		 * @return
		 */
		public function isOpened( id:int ):Boolean
		{
			return Boolean(IVisualElement( getPanel( id ) ).parent);
		}
	}

}

class SingletonEnforcer{}