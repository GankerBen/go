package tetequ.live.modules.room.doc.doclist.network 
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.Timer;
	import framework.view.UIRoot;
	import org.flexlite.domUI.components.Alert;
	import tetequ.live.core.network.NetworkFacade;
	import tetequ.live.modules.room.common.GlobalVars;
	import tetequ.live.modules.room.common.panel.BasePanel;
	import tetequ.live.modules.room.common.panel.PanelID;
	import tetequ.live.modules.room.common.panel.PanelManager;
	import tetequ.live.modules.room.doc.common.upload.FileUploadManager;
	import tetequ.live.modules.room.doc.doclist.events.FileListInfoResponseEvent;
	import tetequ.live.modules.room.doc.doclist.model.WebServerConfig;
	import tetequ.live.modules.room.error.FrozenLayer;
	import tetequ.live.utils.HashMap;
	/**
	 * ...
	 * @author Pandazhong
	 * web通信管理器
	 */
	public class WebServerManager 
	{
		[Inject]
		public var eventDispatcher:IEventDispatcher;
		
		[Inject]
		public var panelManager:PanelManager;
		
		[Inject]
		public var frozenLayer:FrozenLayer;
		
		[Inject]
		public var uiroot:UIRoot;
		
		[Inject]
		public var upLoadManager:FileUploadManager;

		/**
		 * 文档信息解析器
		 */
		private var _parser:FileListDataParser;
		
		/**
		 * 加载文档超时处理
		 */
		private var _timeout:Timer;
		
		private var _loader:URLLoader;
		
		/**
		 * 构造函数
		 */
		public function WebServerManager() 
		{
			GlobalVars.webServer = this;
		}
		
		/**
		 * 向web服务器请求用户的文档列表信息
		 */
		public function reqDocsInfo():void
		{
			if ( _parser )
			{
				if(!panelManager.isOpened(PanelID.FILE_LIST))
				{
					trace( "已经请求过文档信息了，直接打开文档列表！" );
					panelManager.openPanel( PanelID.FILE_LIST );
					BasePanel(panelManager.getPanel(PanelID.FILE_LIST)).visible = true;
				}else
				{
					if ( upLoadManager.isUploading )
					{
						trace( "有文档正在上传中，只隐藏面板！" );
						BasePanel(panelManager.getPanel(PanelID.FILE_LIST)).visible = false;
					}else
					{
						trace( "关闭面板！" );
						panelManager.closePanel( PanelID.FILE_LIST );
					}
				}
				
				return;
			}
			
			trace( "开始请求文档信息！~~~" );
			frozenLayer.show( "正在加载文档列表信息，请稍候...", uiroot );
			
			if (!_timeout)
			{
				_timeout = new Timer(20000, 1);
			}
			
			_timeout.addEventListener( TimerEvent.TIMER, onTimeoutChecking );
			_timeout.reset();
			_timeout.start();
			
			_loader = new URLLoader();
			var request:URLRequest = new URLRequest( WebServerConfig.CONNECT_WEB_URL + WebServerConfig.FILES_LIST_URL );
			var vars:URLVariables = new URLVariables();
			
			vars['roomNO'] = GlobalVars.DOC_UPLOAD_KEY;
			request.data = vars;
			
			_loader.addEventListener( Event.COMPLETE, onFilesInfoResponse );
			_loader.addEventListener( IOErrorEvent.IO_ERROR, onFilesInfoIOError );
			_loader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onFilesInfoSecurityError );
			
			_loader.load( request );
		}
		
		//删除文件
		private var _deleteLoader:URLLoader;
		private var _request:URLRequest;
		private var _vars:Object;
		private var _args:Object;
		private var _key:String;
		private var _deleteCallbacks:HashMap;
		private var _deleteLoaders:HashMap;
		/**
		 * 删除指定文件
		 * @param	fileId
		 * @param	callback	删除结果回调
		 */
		public function deleteFile(fileId:String, callback:Function):void
		{
			if (!_deleteCallbacks)
			{
				_deleteCallbacks = new HashMap;
				_deleteLoaders = new HashMap;
			}
			
			if (_deleteCallbacks.containsKey(fileId))
			{
				Alert.show('该文件正在删除中，请稍后...');
			}
			
			_deleteLoader = new URLLoader();
			_deleteLoader.addEventListener(Event.COMPLETE, onDeleteComplete);
			_deleteLoader.addEventListener(IOErrorEvent.IO_ERROR, onDeleteIOError);
			_deleteLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onDeleteSecurityError);
			
			_deleteCallbacks.put(fileId, callback);
			_deleteLoaders.put(fileId, _deleteLoader);
			
            _request = new URLRequest(WebServerConfig.CONNECT_WEB_URL + WebServerConfig.FILES_DELETE_URL);
            _vars = new URLVariables();
			_args = { id:fileId };
			
			for(_key in _args){
				_vars[_key] = _args[_key];
			}
			
            _request.method = URLRequestMethod.POST;
            _request.data = _args;

			_deleteLoader.load(_request);
			_deleteLoader = null;
		}
		
		/**
		 * 删除文件时发生安全错误
		 * @param	e
		 */
		private function onDeleteSecurityError(e:SecurityErrorEvent):void 
		{
			_deleteLoader = URLLoader(e.currentTarget);
			_deleteLoader.removeEventListener(Event.COMPLETE, onDeleteComplete);
			_deleteLoader.removeEventListener(IOErrorEvent.IO_ERROR, onDeleteIOError);
			_deleteLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onDeleteSecurityError);
			_deleteLoader = null;
			Alert.show('删除失败，请稍候再试！');
		}
		
		/**
		 * 删除文件时发生错误
		 * @param	e
		 */
		private function onDeleteIOError(e:IOErrorEvent):void 
		{
			_deleteLoader = URLLoader(e.currentTarget);
			_deleteLoader.removeEventListener(Event.COMPLETE, onDeleteComplete);
			_deleteLoader.removeEventListener(IOErrorEvent.IO_ERROR, onDeleteIOError);
			_deleteLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onDeleteSecurityError);
			_deleteLoader = null;
			Alert.show('删除失败，请稍候再试！')
		}
		
		/**
		 * 文件删除完毕
		 * @param	e
		 */
		private function onDeleteComplete(e:Event):void 
		{
			_deleteLoader = URLLoader(e.currentTarget);
			_deleteLoader.removeEventListener(Event.COMPLETE, onDeleteComplete);
			_deleteLoader.removeEventListener(IOErrorEvent.IO_ERROR, onDeleteIOError);
			_deleteLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onDeleteSecurityError);
			_deleteLoader = null;
			trace('删除完毕！');
			var loader:URLLoader = URLLoader(e.currentTarget);
			var keys:Array = _deleteLoaders.getKeys();
			var callback:Function;
			
			for each(var id:String in keys)
			{
				if (_deleteLoaders.getValue(id) == loader)
				{
					callback = _deleteCallbacks.getValue(id);
					_deleteLoaders.remove(id);
					if (callback != null)
					{
						callback.apply(null, [id]);
						callback = null;
						_deleteCallbacks.remove(id);
					}
					
					return;
				}
			}
		}
		
		private function onTimeoutChecking(e:TimerEvent):void 
		{
			frozenLayer.hide();
			Alert.show( "加载文档超时，请稍后再试！" );
			_timeout.removeEventListener(TimerEvent.TIMER, onTimeoutChecking);
			_timeout.stop();
			
			if (_loader)
			{
				_loader.removeEventListener( Event.COMPLETE, onFilesInfoResponse );
				_loader.removeEventListener( IOErrorEvent.IO_ERROR, onFilesInfoIOError );
				_loader.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, onFilesInfoSecurityError );
			}
		}
		
		/**
		 * 获取文件列表信息时发生安全沙箱错误
		 * @param	e
		 */
		private function onFilesInfoSecurityError(e:SecurityErrorEvent):void 
		{
			var loader:URLLoader = e.currentTarget as URLLoader;
			loader.removeEventListener( Event.COMPLETE, onFilesInfoResponse );
			loader.removeEventListener( IOErrorEvent.IO_ERROR, onFilesInfoIOError );
			loader.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, onFilesInfoSecurityError );
			loader.close();
			Alert.show("加载文档过程中出现安全(Security)错误，请稍后再试！");
		}
		
		/**
		 * 获取文件列表信息时发生IO错误
		 * @param	e
		 */
		private function onFilesInfoIOError(e:IOErrorEvent):void 
		{
			var loader:URLLoader = e.currentTarget as URLLoader;
			loader.removeEventListener( Event.COMPLETE, onFilesInfoResponse );
			loader.removeEventListener( IOErrorEvent.IO_ERROR, onFilesInfoIOError );
			loader.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, onFilesInfoSecurityError );
			loader.close();
			Alert.show("加载文档过程中出现IO错误，请稍后再试！");
		}
		
		/**
		 * 获取文档列表信息完成
		 * @param	e
		 */
		private function onFilesInfoResponse(e:Event):void 
		{
			_timeout.removeEventListener(TimerEvent.TIMER, onTimeoutChecking);
			_timeout.stop();
			
			var loader:URLLoader = e.currentTarget as URLLoader;
			loader.removeEventListener( Event.COMPLETE, onFilesInfoResponse );
			loader.removeEventListener( IOErrorEvent.IO_ERROR, onFilesInfoIOError );
			loader.removeEventListener( SecurityErrorEvent.SECURITY_ERROR, onFilesInfoSecurityError );
			
			try
			{
				var rawData:Object = JSON.parse( loader.data );
			}catch ( e:Error )
			{
				
			}
			
			if ( !_parser )
			{
				_parser = new FileListDataParser( rawData );
				_parser.parse();
			}else {
				_parser.reset();
				_parser.rawData = rawData;
				_parser.parse();
			}
			
			trace( "文档信息下载完毕！现在打开文档列表~~~" );
			frozenLayer.hide();
			panelManager.openPanel( PanelID.FILE_LIST );
			BasePanel(panelManager.getPanel(PanelID.FILE_LIST)).visible = true;
			eventDispatcher.dispatchEvent( new FileListInfoResponseEvent( _parser.imgGroup, _parser.documentGroup, _parser.mediaGroup ) );
		}
		
		/**
		 * 获取文档列表信息解析器
		 */
		public function get parser():FileListDataParser 
		{
			return _parser;
		}
		
	}

}