package tetequ.live.modules.room.doc.doclist.events 
{
	import flash.events.Event;
	import tetequ.live.modules.room.doc.common.IFileInfo;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 获取到文件列表信息的事件
	 */
	public class FileListInfoResponseEvent extends Event 
	{
		public static const LIST_INFO_RESPONSE:String = "list-info-response";
		
		/**
		 * 图片组的文档信息
		 */
		private var _imgGroupInfo:Vector.<IFileInfo>;
		
		/**
		 * 文档组的文档信息
		 */
		private var _documentGroupInfo:Vector.<IFileInfo>;
		
		/**
		 * 媒体组的文档信息
		 */
		private var _mediaGroupInfo:Vector.<IFileInfo>;
		
		public function FileListInfoResponseEvent( imgGroupInfo:Vector.<IFileInfo>, 
												   documentGroupInfo:Vector.<IFileInfo>,
												   mediaGroupInfo:Vector.<IFileInfo>,
												   type:String = LIST_INFO_RESPONSE, 
												   bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			
			_imgGroupInfo = imgGroupInfo;
			_documentGroupInfo = documentGroupInfo;
			_mediaGroupInfo = mediaGroupInfo;
		}
		
		public function get imgGroupInfo():Vector.<IFileInfo> 
		{
			return _imgGroupInfo;
		}
		
		public function get documentGroupInfo():Vector.<IFileInfo> 
		{
			return _documentGroupInfo;
		}
		
		public function get mediaGroupInfo():Vector.<IFileInfo> 
		{
			return _mediaGroupInfo;
		}
		
	}

}