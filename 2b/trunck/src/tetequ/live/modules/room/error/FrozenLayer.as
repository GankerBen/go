package tetequ.live.modules.room.error 
{
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.components.Rect;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 冻结界面，提示响应文字
	 */
	public class FrozenLayer extends Group 
	{
		/**
		 * 背景
		 */
		private var _background:Rect;
		
		/**
		 * 显示消息的文本
		 */
		private var _labelMessage:Label;
		
		/**
		 * 所在容器
		 */
		private var _container:Group;
		
		/**
		 * 构造函数
		 */
		public function FrozenLayer() 
		{
			super();
			initComponents();
		}
		
		/**
		 * 初始化组件
		 */
		private function initComponents():void 
		{
			addElement( _background = new Rect() );
			_background.fillColor = 0x000000;
			_background.alpha = 0.5;
			_background.percentWidth = 100;
			_background.percentHeight = 100;
			
			addElement( _labelMessage = new Label() );
			_labelMessage.horizontalCenter = 0;
			_labelMessage.verticalCenter = 0;
			_labelMessage.textColor = 0xffffff;
			
			this.percentWidth = 100;
			this.percentHeight = 100;
		}
		
		/**
		 * 显示信息
		 * @param	msg
		 */
		public function show( msg:String, container:Group ):void
		{
			_labelMessage.text = msg;
			_container = container;
			_container.addElement( this );
		}
		
		/**
		 * 隐藏
		 */
		public function hide():void
		{
			if ( _container )
			{
				if ( _container.containsElement( this ) )
				{
					_container.removeElement( this );
				}
			}
		}
		
	}

}