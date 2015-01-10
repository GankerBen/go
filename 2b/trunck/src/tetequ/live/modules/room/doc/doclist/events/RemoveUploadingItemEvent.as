package tetequ.live.modules.room.doc.doclist.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 删除一个正在上传的文件项目
	 */
	public class RemoveUploadingItemEvent extends Event 
	{
		public static const REMOVE_UPLOADING_ITEM:String = "remove-uploading-item";
		private var _fileName:String;
		
		public function RemoveUploadingItemEvent( fileName:String, type:String = REMOVE_UPLOADING_ITEM, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			_fileName = fileName;
		}
		
		public function get fileName():String 
		{
			return _fileName;
		}
		
	}

}