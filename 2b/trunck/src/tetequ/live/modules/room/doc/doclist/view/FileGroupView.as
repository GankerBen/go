package tetequ.live.modules.room.doc.doclist.view 
{
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.components.Rect;
	import org.flexlite.domUI.layouts.HorizontalLayout;
	import org.flexlite.domUI.layouts.TileLayout;
	import org.flexlite.domUI.layouts.VerticalLayout;
	import tetequ.live.modules.room.common.GlobalVars;
	import tetequ.live.modules.room.doc.doclist.model.FileGroupID;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 同一类型文件所在的分组界面
	 * 目前有三组，分别是：文档分、音视频分、图片分组
	 */
	public class FileGroupView extends Group 
	{
		/**
		 * 该分组的类型文本
		 */
		private var _labelTitle:Label;
		
		/**
		 * 该分组的类型
		 */
		private var _title:String;
		
		/**
		 * 文档的数量
		 */
		private var _labelNum:Label;
		
		/**
		 * 标题栏组
		 */
		private var _titleGroup:Group;
		
		/**
		 * 标题栏背景
		 */
		private var _titleBg:Rect;
		
		/**
		 * 文件图标容器
		 */
		private var _fileItems:Group;
		
		private var _line:Rect;
		
		/**
		 * 构造函数
		 * @param	title
		 * @param	id	FileGroupID中的一种
		 */
		public function FileGroupView( title:String, id:String ) 
		{
			super();
			
			_title = title;
			this.id = id;
			
			initComponents();
		}
		
		/**
		 * 初始化
		 */
		private function initComponents():void 
		{
			this.layout = new VerticalLayout();
			
			addElement( _titleGroup = new Group() );
			
			//_titleBg = Global.getVectorSkin( 200, 30, 0xb5b5b5 );
			//_titleBg.percentWidth = 100;
			//_titleBg.verticalCenter = 0;
			//_titleBg.height = 35;
			//_titleGroup.addElement( _titleBg );
			_titleGroup.percentWidth = 100;
			
			_titleGroup.addElement( _labelTitle = new Label() );
			_labelTitle.text = _title;
			_labelTitle.textColor = 0x888888;
			_labelTitle.height = 20;
			_labelTitle.left = 30;
			_labelTitle.top = 30;
			//_labelTitle.verticalCenter = 0;
			_labelTitle.bold = true;
			
			
			_titleGroup.addElement( _labelNum = new Label() );
			
			if (GlobalVars.language == GlobalVars.LANG_ENGLISH)
			{
				//英文
				_labelNum.text = "A total of 0" + _title + "file";
			}else if(GlobalVars.language == GlobalVars.LANG_CHINESE)
			{
				//中文
				_labelNum.text = "一共有0个" + _title + "文件";
			}else
			{
				throw new Error('无法识别的语言！');
			}
			
			_labelNum.textColor = 0x888888;
			_labelNum.height = 20;
			_labelNum.right = 0;
			_labelNum.top = 30;
			//_labelNum.verticalCenter = 0;
			
			
			_titleGroup.addElement(_line = new Rect());
			_line.fillColor = 0xb5b5b5;
			_line.height = 1;
			_line.percentWidth = 100;
			_line.top = 50;
			
			addElement( _fileItems = new Group() );
			_fileItems.layout = new TileLayout();
			
			_fileItems.width = 840;
			TileLayout(_fileItems.layout).horizontalGap = 0;
		}
		
		/**
		 * 添加一个文档元素
		 * @param	item
		 */
		public function addItem( item:Group ):void
		{
			if ( _fileItems.containsElement( item ) ) return;
			
			_fileItems.addElement( item );
			
			if (GlobalVars.language == GlobalVars.LANG_ENGLISH)
			{
				//英文
				_labelNum.text = "A total of " + _fileItems.numChildren + "  a" + _title + "  file";
			}else if(GlobalVars.language == GlobalVars.LANG_CHINESE)
			{
				//中文
				_labelNum.text = "一共有 " + _fileItems.numChildren + " 个" + _title + "文件";
			}else
			{
				throw new Error('无法识别的语言！');
			}
			
			
		}
		
		/**
		 * 移除一个文档元素
		 * @param	item
		 */
		public function removeItem( item:Group ):void
		{
			if ( !_fileItems.containsElement( item ) ) return;
			_fileItems.removeElement( item );
		}
		
		/**
		 * 是否包含指定item
		 * @param	item
		 */
		public function hasItem( item:Group ):Boolean
		{
			return _fileItems.containsElement( item );
		}
		
	}

}