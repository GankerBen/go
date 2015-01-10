package tetequ.live.modules.room.common.layouts.style.common 
{
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Rect;
	import tetequ.live.utils.HashMap;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 布局样式风格基类
	 */
	public class BaseScheme extends Group implements IScheme
	{
		/**
		 * 布局元素组件集合
		 */
		protected var components:HashMap;
		
		/**
		 * 构造函数
		 * @param	components	需要布局的组件
		 */
		public function BaseScheme( components:HashMap )
		{
			super();
			this.components = components;
		}
		
		/**
		 * 布局
		 * 供子类重写
		 */
		public function layoutElements():void
		{
			throw new Error( "抽象方法不能直接调用!" );
		}
		
	}

}