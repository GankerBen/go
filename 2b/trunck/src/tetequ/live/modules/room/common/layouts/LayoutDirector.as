package tetequ.live.modules.room.common.layouts 
{
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.core.IVisualElement;
	import org.flexlite.domUI.core.UIComponent;
	import tetequ.live.modules.room.common.layouts.style.common.IScheme;
	import tetequ.live.utils.HashMap;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 界面布局管理器实现
	 */
	public class LayoutDirector extends Group implements ILayoutDirector 
	{
		/**
		 * 组件id与组件实例的映射
		 * example:elementsInstances.put(ui.id, ui);
		 */
		protected var elementInstances:HashMap;
		
		protected var _scheme:IScheme;
		
		/**
		 * 构造函数
		 */
		public function LayoutDirector() 
		{
			super();
			init();
		}
		
		/**
		 * 初始化
		 * 子类若要重写该方法，
		 * 请首先调用super.init();
		 */
		protected function init():void 
		{
			elementInstances = new HashMap();
			this.percentWidth = 100;
			this.percentHeight = 100;
		}
		
		/**
		 * 注册布局元素
		 * @param	id
		 * @param	element
		 */
		public final function registerElement(id:String, element:IVisualElement):void 
		{
			if ( !elementInstances.containsKey( id ) )
			{
				elementInstances.put( id, element );
			}
		}

		/**
		 * 启动布局
		 */
		public final function layoutElements():void 
		{
			this.scheme.layoutElements();
		}
		
		/**
		 * 获取布局样式
		 * hook
		 * @return
		 */
		protected function get scheme():IScheme
		{
			return this._scheme;
		}
		
	}

}