package tetequ.live.modules.room.doc.common.upload 
{
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.FileReferenceList;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import framework.view.UIRoot;
	import org.flexlite.domUI.components.Alert;
	import tetequ.live.modules.room.common.GlobalVars;
	import tetequ.live.modules.room.doc.common.FileInfoVo;
	import tetequ.live.modules.room.doc.common.IFileInfo;
	import tetequ.live.modules.room.doc.doclist.events.AddItemEvent;
	import tetequ.live.modules.room.doc.doclist.events.AddUploadingItemEvent;
	import tetequ.live.modules.room.doc.doclist.events.RemoveUploadingItemEvent;
	import tetequ.live.modules.room.doc.doclist.events.UploadingItemProgressEvent;
	import tetequ.live.modules.room.doc.doclist.model.WebServerConfig;
	import tetequ.live.modules.room.error.FrozenLayer;
	/**
	 * ...
	 * @author Pandazhong
	 * 文件上传管理器
	 */
	public class FileUploadManager 
	{
		/**
		 * 文件列表
		 */
		private var _fileList:FileReferenceList;
		
		/**
		 * 一组已经上传成功的文件
		 */
		private var _uploadedFiles:Vector.<IFileInfo>;
		
		/**
		 * 一组准备上传的文件引用
		 */
		private var _prepareUploadingFiles:Vector.<FileReference>;
		
		/**
		 * 文件过滤器
		 */
		private static const filter:FileFilter = new FileFilter("上传文件 (*.ttq,*.txt,*.flv,*.mp4,*.mp3,*.doc,*.docx,*.ppt, *.pptx, *.pdf,*.JPG, *.jpg, *.png, *.f4v)", "*.ttq;*.txt;*.flv;*.mp4;*.mp3;*.aac;*.doc;*.docx;*.ppt;*.pptx;*.pdf;*.JPG;*.jpg;*.png;*.f4v");
		
		[Inject]
		public var frozenLayer:FrozenLayer;
		
		[Inject]
		public var container:UIRoot;
		
		[Inject]
		public var eventDispatcher:IEventDispatcher;
		
		/**
		 * 是否已经打开了文件浏览窗口
		 */
		private var _isBrowsing:Boolean;
		
		/**
		 * 构造函数
		 */
		public function FileUploadManager() 
		{
			
		}
		
		/**
		 * 打开文件浏览窗口
		 */
		public function startup():void
		{
			if ( _isBrowsing ) return;
			_isBrowsing = true;
			
			if ( !_fileList )
			{
				_fileList = new FileReferenceList();
			}
			
			if ( !_uploadedFiles )
			{
				_uploadedFiles = new Vector.<IFileInfo>;
			}
			
			if ( !_prepareUploadingFiles )
			{
				_prepareUploadingFiles = new Vector.<FileReference>;
			}else {
				_prepareUploadingFiles.length = 0;//FIXME:可能需要保留上一次没有上传完的文件引用，此处不保留
			}
			
			_fileList.addEventListener( Event.SELECT, onFilesSelected );
			_fileList.addEventListener( Event.CANCEL, onBrowseCancel );
			_fileList.browse( [filter] );
		}
		
		/**
		 * 取消浏览
		 * @param	e
		 */
		private function onBrowseCancel(e:Event):void 
		{
			_isBrowsing = false;
		}
		
		/**
		 * 是否正在上传文件
		 * @return
		 */
		public function get isUploading():Boolean
		{
			if ( !_prepareUploadingFiles ) return false;
			return _prepareUploadingFiles.length != 0;
		}
		
		/**
		 * 选择了文件
		 * @param	e
		 */
		private function onFilesSelected(e:Event):void 
		{
			_isBrowsing = false;
			_fileList.removeEventListener( Event.SELECT, onFilesSelected );
			
			for each( var file:FileReference in _fileList.fileList )
			{
				if ( file.type == ".lnk" ) continue;//过滤掉快捷方式文件
				
				_prepareUploadingFiles.push( file );
				eventDispatcher.dispatchEvent( new AddUploadingItemEvent( file.name, file.type ) );
			}
			
			uploadAllFilesSelected();
		}
		
		/**
		 * 上传选中的文件队列
		 * FIXME:暂时采用的队列上传的形式，
		 * 没有采取并发上传。
		 * @param	f
		 */
		private function uploadAllFilesSelected():void
		{
			var file:FileReference = _prepareUploadingFiles.shift();
			
			if ( !file ) return;
			
			file.addEventListener( Event.COMPLETE, onFileOpened );
			file.addEventListener( IOErrorEvent.IO_ERROR, onIOError );
			file.addEventListener( ProgressEvent.PROGRESS, onProgress );
			file.addEventListener( DataEvent.UPLOAD_COMPLETE_DATA, onUploadComplete );
			
			var request:URLRequest = new URLRequest( WebServerConfig.CONNECT_WEB_URL + 
													 WebServerConfig.FILES_UPLOAD_URL3 + 
													 GlobalVars.DOC_UPLOAD_KEY);//FIXME:此处用临时userId代替
			
			request.method = URLRequestMethod.POST;
			file.upload( request );
		}
		
		/**
		 * 文件上传完毕
		 * @param	e
		 */
		private function onUploadComplete(e:DataEvent):void 
		{
			/**
			 * 移除文件的事件监听器
			 */
			var file:FileReference = e.currentTarget as FileReference;
			removeEventListeners( file );
			
			/**
			 * 解析数据
			 */
			var data:Object = JSON.parse( e.data );
			var errorCode:int = data['code'];
			
			/**
			 * 移除文件的临时图标
			 */
			eventDispatcher.dispatchEvent( new RemoveUploadingItemEvent( file.name ) );
			
			if ( errorCode != 0 )
			{
				/**
				 * FIXME:此处可能需要弹出警告框或者其他的能够提示用户的东西
				 */
				Alert.show("上传文档失败！");
			}else {
				/**
				 * 文件上传成功
				 */
				var fileInfo:IFileInfo = new FileInfoVo();
				fileInfo.id = data['id'];
				fileInfo.name = data['name'];
				fileInfo.pages = data['pages'];
				fileInfo.path = WebServerConfig.CONNECT_WEB_URL + data['path'];
				fileInfo.type = data['type'];
				
				eventDispatcher.dispatchEvent( new AddItemEvent( fileInfo ) );
			}
			
			/**
			 * 继续上传
			 */
			uploadAllFilesSelected();
		}
		
		/**
		 * 文件上传进度
		 * @param	e
		 */
		private function onProgress(e:ProgressEvent):void 
		{
			var file:FileReference = e.currentTarget as FileReference;
			eventDispatcher.dispatchEvent( new UploadingItemProgressEvent( file.name, e.bytesLoaded, e.bytesTotal ) );
			
			if ( e.bytesLoaded == e.bytesTotal )
			{
				file.removeEventListener( Event.COMPLETE, onFileOpened );
				file.removeEventListener( IOErrorEvent.IO_ERROR, onIOError );
				file.removeEventListener( ProgressEvent.PROGRESS, onProgress );

				/**
				* 继续上传
				*/
				uploadAllFilesSelected();
			}
		}
		
		/**
		 * 文件上传过程中遇到IO错误
		 * @param	e
		 */
		private function onIOError(e:IOErrorEvent):void 
		{
			var file:FileReference = e.currentTarget as FileReference;
			removeEventListeners( file );//FIXME:此处可能还需要做其他处理
			file.cancel();
			
			uploadAllFilesSelected();
		}
		
		/**
		 * 文件已经打开，开始上传
		 * 通知文档列表
		 * @param	e
		 */
		private function onFileOpened(e:Event):void 
		{
			//TODO:此处可能需要做处理
		}
		
		/**
		 * 移除指定文件的事件监听器
		 * @param	file
		 */
		private function removeEventListeners( file:FileReference ):void
		{
			file.removeEventListener( Event.COMPLETE, onFileOpened );
			file.removeEventListener( IOErrorEvent.IO_ERROR, onIOError );
			file.removeEventListener( ProgressEvent.PROGRESS, onProgress );
			file.removeEventListener( DataEvent.UPLOAD_COMPLETE_DATA, onUploadComplete );
		}
		
	}

}