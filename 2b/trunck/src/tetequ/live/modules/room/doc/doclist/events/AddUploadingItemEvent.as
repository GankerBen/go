package tetequ.live.modules.room.doc.doclist.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 添加一个正在上传的文件项目到文档列表
	 */
	public class AddUploadingItemEvent extends Event 
	{
		public static const UPLOADING:String = "uploading";
		
		/**
		 * 正在上传的文件名
		 */
		private var _fileName:String;
		
		/**
		 * 正在上传的文件类型
		 */
		private var _fileType:String;
		
		public function AddUploadingItemEvent( fileName:String, fileType:String, type:String = UPLOADING, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			_fileName = fileName;
			_fileType = fileType;
		}
		
		public function get fileName():String 
		{
			return _fileName;
		}
		
		public function get fileType():String 
		{
			return _fileType;
		}
		
	}

}