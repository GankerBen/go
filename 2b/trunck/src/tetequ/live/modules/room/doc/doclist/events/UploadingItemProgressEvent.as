package tetequ.live.modules.room.doc.doclist.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 文件的上传进度跟踪事件
	 */
	public class UploadingItemProgressEvent extends Event 
	{
		public static const PROGRESS:String = "progress";
		private var _fileName:String;
		private var _bytesLoaded:Number;
		private var _bytesTotal:Number;
		
		public function UploadingItemProgressEvent( fileName:String, bytesLoaded:Number, bytesTotal:Number, 
													type:String = PROGRESS, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			_fileName = fileName;
			_bytesLoaded = bytesLoaded;
			_bytesTotal = bytesTotal;
		}
		
		public function get fileName():String 
		{
			return _fileName;
		}
		
		public function get bytesLoaded():Number 
		{
			return _bytesLoaded;
		}
		
		public function get bytesTotal():Number 
		{
			return _bytesTotal;
		}
		
	}

}