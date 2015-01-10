package tetequ.live.modules.room.doc.doclist.events 
{
	import flash.events.Event;
	import tetequ.live.modules.room.doc.common.IFileInfo;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 添加一个已经上传完成的文件项目到列表
	 */
	public class AddItemEvent extends Event 
	{
		public static const ADD_UPLOADED_ITEM:String = "add-uploaded-item";
		private var _fileInfo:IFileInfo;
		
		public function AddItemEvent( fileInfo:IFileInfo, type:String = ADD_UPLOADED_ITEM, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			_fileInfo = fileInfo;
		}
		
		public function get fileInfo():IFileInfo 
		{
			return _fileInfo;
		}
		
	}

}