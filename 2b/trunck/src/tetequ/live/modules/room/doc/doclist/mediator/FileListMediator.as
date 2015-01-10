package tetequ.live.modules.room.doc.doclist.mediator 
{
	import com.e2et.datalogic.Document;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.managers.PopUpManager;
	import org.flexlite.domUI.utils.callLater;
	import tetequ.live.core.network.NetworkFacade;
	import tetequ.live.modules.room.common.GlobalVars;
	import tetequ.live.modules.room.doc.players.common.events.BindDocumentToCanvasEvent;
	import tetequ.live.modules.room.doc.players.common.events.CallPlayerEvent;
	import tetequ.live.modules.room.doc.players.common.MasterPlayerManager;
	import tetequ.live.modules.room.doc.players.common.PlayerManager;
	import flash.events.MouseEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import framework.view.UIRoot;
	import org.flexlite.domUI.components.Alert;
	import org.flexlite.domUI.events.CloseEvent;
	import robotlegs.bender.bundles.mvcs.Mediator;
	import tetequ.live.modules.room.common.panel.PanelManager;
	import tetequ.live.modules.room.doc.common.IFileInfo;
	import tetequ.live.modules.room.doc.common.upload.FileUploadManager;
	import tetequ.live.modules.room.doc.doclist.events.AddItemEvent;
	import tetequ.live.modules.room.doc.doclist.events.AddUploadingItemEvent;
	import tetequ.live.modules.room.doc.doclist.events.FileListInfoResponseEvent;
	import tetequ.live.modules.room.doc.doclist.events.RemoveItemEvent;
	import tetequ.live.modules.room.doc.doclist.events.RemoveUploadingItemEvent;
	import tetequ.live.modules.room.doc.doclist.events.UploadingItemProgressEvent;
	import tetequ.live.modules.room.doc.doclist.model.FileGroupID;
	import tetequ.live.modules.room.doc.doclist.model.FileType;
	import tetequ.live.modules.room.doc.doclist.view.FileItemView;
	import tetequ.live.modules.room.doc.doclist.view.FileListView;
	import tetequ.live.modules.room.doc.doclist.view.UploadingFileItemView;
	import tetequ.live.modules.room.doc.players.common.PlayerID;
	import tetequ.live.modules.room.doc.players.common.PlayerManager;
	import tetequ.live.modules.room.doc.players.media.audio.common.MasterAudioPlayerManager;
	import tetequ.live.modules.room.doc.players.media.video.common.MasterVideoPlayerManager;
	import tetequ.live.modules.room.doc.tools.view.DocToolView;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 文档列表中介者
	 */
	public class FileListMediator extends Mediator 
	{
		[Inject]
		public var view:FileListView;
		
		[Inject]
		public var uiroot:UIRoot;
		
		[Inject]
		public var playerManager:MasterPlayerManager;
		
		[Inject]
		public var audioPlayerManager:MasterAudioPlayerManager;
		
		[Inject]
		public var videoPlayerManager:MasterVideoPlayerManager;
		
		[Inject]
		public var fileUploadManager:FileUploadManager;
		
		[Inject]
		public var networkFacade:NetworkFacade;
		
		/**
		 * 构造函数
		 */
		public function FileListMediator() 
		{
			super();
			
		}
		
		/**
		 * 初始化
		 */
		override public function initialize():void
		{
			super.initialize();
			
			/**
			 * 监听文档列表信息下发事件
			 */
			this.addContextListener( FileListInfoResponseEvent.LIST_INFO_RESPONSE, onListInfoResponse );
			
			/**
			 * 监听添加一个正在上传的文档项目事件
			 */
			this.addContextListener( AddUploadingItemEvent.UPLOADING, onUploadingItemAdded );
			
			/**
			 * 监听添加一个上传完毕的文档项目事件
			 */
			this.addContextListener( AddItemEvent.ADD_UPLOADED_ITEM, onUploadedItemAdded );
			
			/**
			 * 监听删除一个上传完毕的文档项目事件
			 */
			this.addContextListener( RemoveItemEvent.REMOVE_UPLOADED_ITEM, onUploadedItemRemoved );
			
			/**
			 * 监听删除一个正在上传的文档项目事件
			 */
			this.addContextListener( RemoveUploadingItemEvent.REMOVE_UPLOADING_ITEM, onUploadingItemRemoved );
			
			/**
			 * 监听正在上传的文件的上传进度
			 */
			this.addContextListener( UploadingItemProgressEvent.PROGRESS, onUploadingItemProgress );

			/**
			 * 监听关闭文档窗口
			 */
			this.addViewListener( CloseEvent.CLOSE, onWindowClose );
			
			this.view.btnUpload.addEventListener( MouseEvent.CLICK, onClick );
		}
		
		/**
		 * 删除一个正在上传的文档项目
		 * @param	e
		 */
		private function onUploadingItemRemoved(e:RemoveUploadingItemEvent):void 
		{
			view.removeUploadingItem( e.fileName );
		}
		
		/**
		 * 更新正在上传的文件的上传进度文本显示
		 * @param	e
		 */
		private function onUploadingItemProgress(e:UploadingItemProgressEvent):void 
		{
			view.updateUploadingItemProgress( e.fileName, e.bytesLoaded, e.bytesTotal );
		}
		
		/**
		 * 删除一个已经上传完毕的文档项目
		 * @param	e
		 */
		private function onUploadedItemRemoved(e:RemoveItemEvent):void 
		{
			view.removeItem( e.id );
		}
		
		/**
		 * 添加一个已经加载完毕的文档项目
		 * @param	e
		 */
		private function onUploadedItemAdded(e:AddItemEvent):void 
		{
			var item:FileItemView = new FileItemView( e.fileInfo );
			item.addEventListener( MouseEvent.CLICK, onFileSelected );
			view.addItem( item, getUploadedItemGroupId( e.fileInfo.type ) );
		}
		
		/**
		 * 添加一个正在加载的文档项目
		 * @param	e
		 */
		private function onUploadingItemAdded(e:AddUploadingItemEvent):void 
		{
			var item:UploadingFileItemView = new UploadingFileItemView( e.fileName, e.fileType );
			view.addUploadingItem( item, getUploadingItemGroupId( e.fileType ) );
		}
		
		/**
		 * 根据文件类型获取正在上传的文件应该放在哪一个组里面
		 * @param	fileType
		 * @return
		 */
		private function getUploadingItemGroupId( fileType:String ):String
		{
			switch( fileType )
			{
				case ".ttq":case ".swf":case ".doc":case ".docx":case ".ppt":case ".pptx":case ".pdf":
					return FileGroupID.DOCUMENT;
					break;
				case ".JPG":case ".jpg":case ".png":case ".gif":
					return FileGroupID.IMG;
					break;
				case ".flv":case ".mp4":case ".mp3":case ".f4v":case ".aac":
					return FileGroupID.MEDIA;
					break;
				default:
					return FileGroupID.DOCUMENT;//FIXME:可能有其他未识别的文件后缀名
					break;
			}
			return null;
		}
		
		/**
		 * 获取已加载完毕的文档所应该在的组
		 * @param	type
		 * @return
		 */
		private function getUploadedItemGroupId( type:String ):String
		{
			switch( type )
			{
				case "ppt":case "document":
					return FileGroupID.DOCUMENT;
					break;
				case "image":
					return FileGroupID.IMG;
					break;
				case "audio":case "video":
					return FileGroupID.MEDIA;
					break;
				default:
					return FileGroupID.DOCUMENT;
					break;
			}
		}
		
		/**
		 * 收到文档列表的信息
		 * @param	e
		 */
		private function onListInfoResponse(e:FileListInfoResponseEvent):void 
		{
			var info:IFileInfo;
			
			/**
			 * 添加图片组的文档信息到文档列表
			 */
			for each( info in e.imgGroupInfo )
			{
				var item:FileItemView = new FileItemView( info );
				item.addEventListener( MouseEvent.CLICK, onFileSelected );
				view.addItem( item, FileGroupID.IMG );
			}
			
			/**
			 * 添加文档组的文档信息到文档列表
			 */
			for each( info in e.documentGroupInfo )
			{
				item = new FileItemView( info );
				item.addEventListener( MouseEvent.CLICK, onFileSelected );
				view.addItem( item, FileGroupID.DOCUMENT );
			}
			
			/**
			 * 添加媒体组的文档信息到文档列表
			 */
			for each( info in e.mediaGroupInfo )
			{
				item = new FileItemView( info );
				item.addEventListener( MouseEvent.CLICK, onFileSelected );
				view.addItem( item, FileGroupID.MEDIA );
			}

			/**
			 * 标记已经请求过文档列表信息
			 */
			view.hasInfo = true;
		}
		
		/**
		 * 选中并打开文档
		 * @param	e
		 */
		private function onFileSelected(e:MouseEvent):void 
		{
			if ( !networkFacade.hasToken )
			{
				
				if (GlobalVars.language == GlobalVars.LANG_ENGLISH)
				{
					//英文
					Alert.show( "Sorry, you do not have permission, you can not open the document!" );
				}else if(GlobalVars.language == GlobalVars.LANG_CHINESE)
				{
					//中文
					Alert.show( "对不起，您没有权限，不能打开文档!" );
				}else
				{
					throw new Error('无法识别的语言！');
				}
				return;
			}
			
			var item:FileItemView = e.currentTarget as FileItemView;
			
			trace(item.itemVo.path);
			
			switch( item.itemVo.type )
			{
				case FileType.DOCUMENT:
					
					/**
					 * 透传数据，会被同步到各个客户端，
					 * 远端根据此处的字段约定逐一解析
					 * 数据。
					 */
					var docInfo:* = { };
					var doc:Document;

					playerManager.closeCurPlayer();
					playerManager.openPlayerById( PlayerID.MASTER_DOCX_PLAYER );
					dispatch( new CallPlayerEvent( item.itemVo, CallPlayerEvent.MASTER_DOCX ) );
					
					docInfo['master'] = PlayerID.MASTER_DOCX_PLAYER;
					docInfo['normal'] = PlayerID.MASTER_DOCX_PLAYER;
					docInfo['pages'] = item.itemVo.pages;
					docInfo['pageNo'] = 1;
					docInfo['id'] = item.itemVo.id;
					docInfo['type'] = item.itemVo.type;

					networkFacade.closePrevDoc();
					doc = networkFacade.openDocument( item.itemVo.name, item.itemVo.path, docInfo );
					
					/**
					 * 文档播放器显示的页码比底层文档数据结构中的页码大1
					 * 比如，播放器要显示文档第1页的内容，则应该传0给底层文档
					 */
					networkFacade.gotoPage( 0 );
					
					/**
					 * 绑定文档到绘图层
					 */
					dispatch( new BindDocumentToCanvasEvent( doc ) );
					break;
				case FileType.IMAGE:
					
					if ( item.itemVo.path.indexOf( ".gif" ) >= 0 )
					{
						Alert.show( "对不起，系统已经不再支持对gif类型的图片进行浏览了!" );
						return;
					}
					
					playerManager.closeCurPlayer();
					playerManager.openPlayerById( PlayerID.MASTER_IMAGE_PLAYER );
					dispatch( new CallPlayerEvent( item.itemVo, CallPlayerEvent.MASTER_IMAGE ) );
					
					var picInfo:* = { };
					picInfo['master'] = PlayerID.MASTER_IMAGE_PLAYER;
					picInfo['normal'] = PlayerID.MASTER_IMAGE_PLAYER;
					picInfo['id'] = item.itemVo.id;
					picInfo['type'] = item.itemVo.type;
					picInfo['name'] = item.itemVo.name;
					
					networkFacade.closePrevMedia( PlayerID.MASTER_VIDEO_PLAYER );
					networkFacade.closePrevDoc();
					networkFacade.openDocument( item.itemVo.name, item.itemVo.path, picInfo );
					break;
				case FileType.PPT:
					playerManager.closeCurPlayer();
					playerManager.openPlayerById( PlayerID.MASTER_PPT_PLAYER );
					dispatch( new CallPlayerEvent( item.itemVo, CallPlayerEvent.MASTER_PPT ) );
					
					docInfo = { };
					docInfo['master'] = PlayerID.MASTER_PPT_PLAYER;
					docInfo['normal'] = PlayerID.MASTER_PPT_PLAYER;
					docInfo['pages'] = item.itemVo.pages;
					docInfo['pageNo'] = 1;
					docInfo['id'] = item.itemVo.id;
					docInfo['type'] = item.itemVo.type;

					networkFacade.closePrevDoc();
					doc = networkFacade.openDocument( item.itemVo.name, item.itemVo.path, docInfo );
					networkFacade.gotoPage( 0 );
					
					dispatch( new BindDocumentToCanvasEvent( doc ) );
					break;
				case FileType.VIDEO:
					videoPlayerManager.closeCurPlayer();
					uiroot.addElement( videoPlayerManager.playerLayout );
					videoPlayerManager.openPlayerById( PlayerID.MASTER_VIDEO_PLAYER );
					dispatch( new CallPlayerEvent( item.itemVo, CallPlayerEvent.MASTER_VIDEO ) );
					
					var mediaInfo:* = { };
					mediaInfo['master'] = PlayerID.MASTER_VIDEO_PLAYER;
					mediaInfo['normal'] = PlayerID.MASTER_VIDEO_PLAYER;
					mediaInfo['id'] = item.itemVo.id;
					mediaInfo['type'] = item.itemVo.type;
					mediaInfo['name'] = item.itemVo.name;
					
					networkFacade.closePrevMedia( PlayerID.MASTER_VIDEO_PLAYER );
					networkFacade.openMediaPlayer( item.itemVo.path, mediaInfo );
					break;
				case FileType.AUDIO:
					audioPlayerManager.closeCurPlayer();
					uiroot.addElement( audioPlayerManager.playerLayout );
					audioPlayerManager.playerLayout.horizontalCenter = 0;
					audioPlayerManager.playerLayout.verticalCenter = 0;
					audioPlayerManager.openPlayerById( PlayerID.MASTER_AUDIO_PLAYER );
					dispatch( new CallPlayerEvent( item.itemVo, CallPlayerEvent.MASTER_AUDIO ) );
					
					mediaInfo = { };
					mediaInfo['master'] = PlayerID.MASTER_AUDIO_PLAYER;
					mediaInfo['normal'] = PlayerID.MASTER_AUDIO_PLAYER;
					mediaInfo['id'] = item.itemVo.id;
					mediaInfo['type'] = item.itemVo.type;
					mediaInfo['name'] = item.itemVo.name;
					
					networkFacade.closePrevMedia( PlayerID.MASTER_AUDIO_PLAYER );
					networkFacade.openMediaPlayer( item.itemVo.path, mediaInfo );
					break;
				default:
					break;
			}
			
			PanelManager.getInstance().closePanel( view.panelId );
		}
		
		/**
		 * 关闭窗口
		 * 此处需要策略性处理，如果当前正在上传文件，
		 * 则只需要把面板隐藏了即可，不必从舞台移除，
		 * 因为从舞台移除后，mediator也会随之销毁，
		 * 从而无法持续跟踪各个文件的上传进度。
		 * @param	e
		 */
		private function onWindowClose(e:CloseEvent):void 
		{
			if ( fileUploadManager.isUploading )
			{
				view.visible = false;
			}
			else {
				PanelManager.getInstance().closePanel( view.panelId );
			}
		}
		
		private function onClick(e:MouseEvent):void 
		{
			switch( e.currentTarget )
			{
				case this.view.btnUpload:
					fileUploadManager.startup();
					break;
				default:
					break;
			}
		}
		
		override public function destroy():void
		{
			super.destroy();
			
			this.removeContextListener( FileListInfoResponseEvent.LIST_INFO_RESPONSE, onListInfoResponse );
			this.removeContextListener( AddUploadingItemEvent.UPLOADING, onUploadingItemAdded );
			this.removeContextListener( AddItemEvent.ADD_UPLOADED_ITEM, onUploadedItemAdded );
			this.removeContextListener( RemoveItemEvent.REMOVE_UPLOADED_ITEM, onUploadedItemRemoved );
			this.removeContextListener( RemoveUploadingItemEvent.REMOVE_UPLOADING_ITEM, onUploadingItemRemoved );
			this.removeContextListener( UploadingItemProgressEvent.PROGRESS, onUploadingItemProgress );
			this.removeContextListener( FileListInfoResponseEvent.LIST_INFO_RESPONSE, onListInfoResponse );
			this.view.search.btnUpload.removeEventListener( MouseEvent.CLICK, onClick );
			this.removeViewListener( CloseEvent.CLOSE, onWindowClose );
		}
	}

}