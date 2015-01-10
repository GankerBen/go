package tetequ.live.modules.room.doc.doclist.view 
{
	import flash.events.Event;
	import org.flexlite.domUI.components.Button;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.components.TextInput;
	import org.flexlite.domUI.components.TitleWindow;
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.domUI.components.VScrollBar;
	import org.flexlite.domUI.layouts.VerticalLayout;
	import org.flexlite.domUI.skins.vector.ButtonSkin;
	import tetequ.live.core.assets.AssetsFactory;
	import tetequ.live.modules.room.common.GlobalVars;
	import tetequ.live.modules.room.common.panel.BasePanel;
	import tetequ.live.modules.room.common.panel.PanelID;
	import tetequ.live.modules.room.doc.doclist.model.FileGroupID;
	import tetequ.live.utils.HashMap;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 文档列表-面板
	 */
	public class FileListView extends BasePanel
	{
		/**
		 * 是否有文档列表信息
		 */
		private var _hasInfo:Boolean;
		
		/**
		 * 文档区域
		 */
		private var _documentGroup:FileGroupView;
		
		/**
		 * 音视频区域
		 */
		private var _mediaGroup:FileGroupView;
		
		/**
		 * 图片区域
		 */
		private var _imgGroup:FileGroupView;
		
		/**
		 * 包含文档+音视频+图片的区域
		 */
		private var _group:Group;
		
		/**
		 * 垂直滚动条
		 */
		private var _vscroller:VScrollBar;
		
		/**
		 * 根据文档组的id映射对应的文档组，方便查找
		 */
		private var _groups:HashMap;
		
		/**
		 * 存储了每一个文档信息，方便查找
		 */
		private var _fileItems:HashMap;
		
		/**
		 * 文档id与所在分组的映射
		 */
		private var _groupIds:HashMap;
		
		/**
		 * 包含上传+搜索条等
		 */
		private var _search:FileSearchView;
		
		/**
		 * 正在上传的文档项目
		 */
		private var _uploadingItems:HashMap;
		
		/**
		 * 正在上传的文档名与所在分组的映射
		 */
		private var _groupUploadingFileNames:HashMap;
		
		/**
		 * 上传文档按钮
		 */
		private var _btnUpload:UIAsset;
		
		/**
		 * 构造函数
		 */
		public function FileListView() 
		{
			super();
		}
		
		/**
		 * 初始化组件
		 */
		override protected function initComponents():void 
		{
			super.initComponents();
			
			_search = new FileSearchView();
			_search.top = 10;
			_search.horizontalCenter = 0;
			
			addElement( _btnUpload = new UIAsset() );
			_btnUpload.mouseChildren = true;
			_btnUpload.mouseEnabled = true;
			_btnUpload.skinName = AssetsFactory.getInstance().getAsset('shangchuanSkin');
			_btnUpload.top = 5;
			_btnUpload.left = 10;

			this.width = 855;
			this.percentHeight = 75;
			this.title = "";
			
			
			this.addElement( _group = new Group() );
			_group.layout = new VerticalLayout();
			
			VerticalLayout( _group.layout ).gap = 0;
			VerticalLayout( _group.layout ).paddingBottom = 0;
			VerticalLayout( _group.layout ).paddingTop = -20;

			_group.addElement( _documentGroup = new FileGroupView( GlobalVars.language == GlobalVars.LANG_CHINESE ? "文档" : 'Documentation', FileGroupID.DOCUMENT ) );
			_group.addElement( _mediaGroup = new FileGroupView(GlobalVars.language == GlobalVars.LANG_CHINESE ? "音视频" : 'Audio and video', FileGroupID.MEDIA ) );
			_group.addElement( _imgGroup = new FileGroupView(GlobalVars.LANG_CHINESE ? "图片" : 'Pictures', FileGroupID.IMG ) );
			
			_groups = new HashMap();
			_groups.put( _documentGroup.id, _documentGroup );
			_groups.put( _mediaGroup.id, _mediaGroup );
			_groups.put( _imgGroup.id, _imgGroup );
			
			_fileItems = new HashMap();
			_groupIds = new HashMap();
			_uploadingItems = new HashMap();
			_groupUploadingFileNames = new HashMap();
			
			this.addElement( _vscroller = new VScrollBar() );
			_vscroller.viewport = _group;
			_vscroller.right = 0;
			_vscroller.top = 20;
			_vscroller.bottom = 10;
			_vscroller.alpha = 0;
			
			_group.width = 855;
			_group.top = 40;
			_group.bottom = 10;
			_group.left = 10;
			_group.right = 0;
		}
		
		/**
		 * 向文档列表添加一个文档图标
		 * 之后委托给对应的文档组。
		 * @param	item
		 * @param	group
		 */
		public function addItem( item:FileItemView, groupId:String ):void
		{
			if ( !_groups.containsKey( groupId ) )
			{
				throw new Error( "非法的文档组id:" + groupId + "!" );
			}
			
			if ( _fileItems.containsKey( item.id ) )
			{
				throw new Error( "id已经存在!" );
				return;
			}
			
			_fileItems.put( item.id, item );
			_groupIds.put( item.id, groupId );
			
			var group:FileGroupView = _groups.getValue( groupId );
			group.addItem( item );
		}
		
		/**
		 * 添加一个正在上传的文档项目
		 * @param	item
		 * @param	groupId
		 */
		public function addUploadingItem( item:UploadingFileItemView, groupId:String ):void
		{
			if ( _uploadingItems.containsKey( item.fileName ) ) return;
			_uploadingItems.put( item.fileName, item );
			_groupUploadingFileNames.put( item.fileName, groupId );
			
			var group:FileGroupView = _groups.getValue( groupId );
			group.addItem( item );
		}
		
		/**
		 * 移除正在上传的文件项目
		 * @param	name
		 */
		public function removeUploadingItem( fileName:String ):void
		{
			if ( !_uploadingItems.containsKey( fileName ) ) return;
			var item:UploadingFileItemView = _uploadingItems.getValue( fileName );
			var groupId:String = _groupUploadingFileNames.getValue( fileName );
			var group:FileGroupView = _groups.getValue( groupId );
			group.removeItem( item );
			_uploadingItems.remove( fileName );
			_groupUploadingFileNames.remove( fileName );
		}
		
		/**
		 * 更新正在上传的文件的上传进度
		 * @param	fileName
		 * @param	bytesLoaded
		 * @param	bytesTotal
		 */
		public function updateUploadingItemProgress( fileName:String, bytesLoaded:Number, bytesTotal:Number ):void
		{
			if ( !_uploadingItems.containsKey( fileName ) ) return;
			var item:UploadingFileItemView = _uploadingItems.getValue( fileName );
			if ( item )
			{
				item.updateProgress( bytesLoaded, bytesTotal );
			}
		}
		
		/**
		 * 根据文档id移除一个文档
		 * @param	itemId
		 */
		public function removeItem( itemId:String ):void
		{
			if ( !_fileItems.containsKey( itemId ) ) return;
			var item:FileItemView = _fileItems.getValue( itemId );
			var groupId:String = _groupIds.getValue( itemId );
			var group:FileGroupView = _groups.getValue( groupId );
			group.removeItem( item );
			_fileItems.remove( itemId );
			_groupIds.remove( itemId );
		}
		
		/**
		 * 获取查找文档组件
		 */
		public function get search():FileSearchView 
		{
			return _search;
		}
		
		/**
		 * 是否已经有文档信息
		 */
		public function get hasInfo():Boolean 
		{
			return _hasInfo;
		}
		
		public function set hasInfo(value:Boolean):void 
		{
			_hasInfo = value;
		}
		
		/* 实现接口 */
		override public function get panelId():int
		{
			return PanelID.FILE_LIST;
		}
		
		public function get btnUpload():UIAsset 
		{
			return _btnUpload;
		}
		
		public function get vscroller():VScrollBar 
		{
			return _vscroller;
		}
		
	}

}