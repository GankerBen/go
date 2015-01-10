package tetequ.live.modules.room.doc.doclist.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 移除一个已经上传完毕的文件项目
	 */
	public class RemoveItemEvent extends Event 
	{
		public static const REMOVE_UPLOADED_ITEM:String = "remove-uploaded-item";
		
		/**
		 * 文件id
		 */
		private var _id:String;
		
		public function RemoveItemEvent( id:String, type:String = REMOVE_UPLOADED_ITEM, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			
			_id = id;
		}
		
		public function get id():String 
		{
			return _id;
		}
		
	}

}