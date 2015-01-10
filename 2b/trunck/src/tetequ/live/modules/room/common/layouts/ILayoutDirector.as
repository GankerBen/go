package tetequ.live.modules.room.common.layouts 
{
	import org.flexlite.domUI.core.IVisualElement;
	import tetequ.live.modules.room.common.layouts.style.common.IScheme;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 软件界面布局管理器接口
	 */
	public interface ILayoutDirector extends IScheme
	{
		/**
		 * 注册布局元素
		 * @param	id	UI的id
		 * @param	element	UI的实例
		 */
		function registerElement( id:String, element:IVisualElement ):void;
	}
	
}