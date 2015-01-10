package tetequ.live.modules.room.doc.doclist.network 
{
	import tetequ.live.modules.room.doc.common.FileInfoVo;
	import tetequ.live.modules.room.doc.common.IFileInfo;
	import tetequ.live.modules.room.doc.doclist.model.FileGroupID;
	import tetequ.live.modules.room.doc.doclist.model.FileType;
	import tetequ.live.modules.room.doc.doclist.model.WebServerConfig;
	import tetequ.live.utils.HashMap;
	/**
	 * ...
	 * @author Pandazhong
	 * 解析从web server返回的文档列表数据
	 */
	public class FileListDataParser 
	{
		/**
		 * 图片组的文档信息
		 */
		private var _imgGroup:Vector.<IFileInfo>;
		
		/**
		 * 文档组的文档信息
		 */
		private var _documentGroup:Vector.<IFileInfo>;
		
		/**
		 * 媒体组的文档信息
		 */
		private var _mediaGroup:Vector.<IFileInfo>;
		
		/**
		 * 包含所有组的文档信息
		 */
		private var _groupInfo:HashMap;
		
		/**
		 * 未解析的文档列表数据
		 */
		private var _rawData:Object;
		
		/**
		 * 构造函数
		 * @param	rawData
		 */
		public function FileListDataParser( rawData:Object ) 
		{
			_rawData = rawData;
			_documentGroup = new Vector.<IFileInfo>;
			_mediaGroup = new Vector.<IFileInfo>;
			_imgGroup = new Vector.<IFileInfo>;
			
			_groupInfo = new HashMap();
			_groupInfo.put( FileGroupID.DOCUMENT, _documentGroup );
			_groupInfo.put( FileGroupID.IMG, _imgGroup );
			_groupInfo.put( FileGroupID.MEDIA, _mediaGroup );
		}
		
		/**
		 * 开始解析
		 */
		public function parse():void
		{
			if ( !_rawData ) return;
			
			for each( var obj:Object in _rawData )
			{
				var info:IFileInfo = new FileInfoVo();
				info.id = obj['id'];
				info.name = obj['name'];
				info.pages = int(obj['pages']);
				info.path = WebServerConfig.CONNECT_WEB_URL + obj['path'];
				info.type = obj['type'];
				
				trace('info.id', info.id );
				trace('info.name', info.name );
				trace('info.pages', info.pages );
				trace('info.path', info.path );
				trace('info.type', info.type );
				
				var group:Vector.<IFileInfo> = _groupInfo.getValue( getGroupType( info.type ) );
				
				if ( group )
				{
					group.push( info );
				}else 
				{
					//throw new Error( "未知格式的文档类型! type:" + info.type );
				}
			}
		}
		
		/**
		 * 重置
		 */
		public function reset():void
		{
			_documentGroup.length = 0;
			_mediaGroup.length = 0;
			_imgGroup.length = 0;
			_rawData = null;
			_groupInfo = new HashMap();
			_groupInfo.put( FileGroupID.DOCUMENT, _documentGroup );
			_groupInfo.put( FileGroupID.IMG, _imgGroup );
			_groupInfo.put( FileGroupID.MEDIA, _mediaGroup );
		}
		
		/**
		 * 根据文档类型获
		 * 取将放进的组类型
		 * @param	type
		 * @return
		 */
		private function getGroupType( type:String ):String
		{
			switch( type )
			{
				case FileType.AUDIO:case FileType.VIDEO:
					return FileGroupID.MEDIA;
					break;
				case FileType.DOCUMENT:case FileType.PPT:
					return FileGroupID.DOCUMENT;
					break;
				case FileType.IMAGE:
					return FileGroupID.IMG;
					break;
				default:
					return "";
					break;
			}
		}
		
		public function get imgGroup():Vector.<IFileInfo> 
		{
			return _imgGroup;
		}
		
		public function get documentGroup():Vector.<IFileInfo> 
		{
			return _documentGroup;
		}
		
		public function get mediaGroup():Vector.<IFileInfo> 
		{
			return _mediaGroup;
		}
		
		public function set rawData(value:Object):void 
		{
			if ( _rawData ) return;
			_rawData = value;
		}
		
	}

}