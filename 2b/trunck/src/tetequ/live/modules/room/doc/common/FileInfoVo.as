package tetequ.live.modules.room.doc.common 
{
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class FileInfoVo implements IFileInfo 
	{
		private var _path:String;
		private var _pages:int;
		private var _name:String;
		private var _type:String;
		private var _id:String;
		
		public function FileInfoVo() 
		{
			
		}
		
		/* INTERFACE tetequ.live.modules.room.doc.common.IFileInfo */
		
		public function set name(value:String):void 
		{
			_name = value;
		}
		
		public function get name():String 
		{
			return _name;
		}
		
		public function set type(value:String):void 
		{
			_type = value;
		}
		
		public function get type():String 
		{
			return _type;
		}
		
		public function set path(value:String):void 
		{
			_path = value;
		}
		
		public function get path():String 
		{
			return _path;
		}
		
		public function set pages(value:int):void 
		{
			_pages = value;
		}
		
		public function get pages():int 
		{
			return _pages;
		}
		
		public function get id():String 
		{
			return _id;
		}
		
		public function set id(value:String):void 
		{
			_id = value;
		}
		
	}

}