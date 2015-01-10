package tetequ.live.modules.room.doc.doclist.view 
{
	import org.flexlite.domUI.components.Button;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Rect;
	import org.flexlite.domUI.components.TextInput;
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.domUI.layouts.HorizontalLayout;
	import org.flexlite.domUI.skins.vector.ButtonSkin;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 文档搜索UI
	 */
	public class FileSearchView extends Group 
	{
		/**
		 * 上传按钮
		 */
		private var _btnUpload:Button;
		
		/**
		 * 输入框
		 */
		private var _input:TextInput;
		
		/**
		 * 放大镜图标
		 */
		private var _img:UIAsset;
		
		/**
		 * 构造函数
		 */
		public function FileSearchView() 
		{
			super();
			initComponents();
		}
		
		/**
		 * 初始化
		 */
		private function initComponents():void 
		{
			this.layout = new HorizontalLayout();
			
			this.addElement( _btnUpload = new Button() );
			_btnUpload.skinName = ButtonSkin;
			_btnUpload.label = "上传";
			_btnUpload.left = 0;
			_btnUpload.verticalCenter = 0;
			
			this.addElement( _input = new TextInput() );
			_input.prompt = "在这里搜索您的文档";
			_input.verticalCenter = 0;
			_input.percentWidth = 100;
			_input.horizontalCenter = 0;
			
			this.addElement( _img = new UIAsset() );
			//_img.skinName = Global.getVectorSkin( 25, 25, 0xff0000 );
			_img.verticalCenter = 0;
			_img.horizontalCenter = 0;
			
			this.percentWidth = 100;
			this.height = 100;
		}
		
		public function get btnUpload():Button 
		{
			return _btnUpload;
		}
		
		public function get input():TextInput 
		{
			return _input;
		}
		
	}

}