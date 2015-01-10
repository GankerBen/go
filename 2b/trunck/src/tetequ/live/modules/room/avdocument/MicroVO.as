package tetequ.live.modules.room.avdocument 
{
	import flash.media.Microphone;
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class MicroVO 
	{
		private var _name:String;
		private var _index:int;
		private var _selected:Boolean;
		private var _micro:Microphone;
		private var _id:String;
		private var _isUsing:Boolean;
		
		public function MicroVO() 
		{
			
		}
		
		public function get name():String 
		{
			return _name;
		}
		
		public function set name(value:String):void 
		{
			_name = value;
		}
		
		public function get index():int 
		{
			return _index;
		}
		
		public function set index(value:int):void 
		{
			_index = value;
		}
		
		public function get selected():Boolean 
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void 
		{
			_selected = value;
		}
		
		public function get micro():Microphone 
		{
			return _micro;
		}
		
		public function set micro(value:Microphone):void 
		{
			_micro = value;
		}
		
		public function get id():String 
		{
			if (!_id)
			{
				_id = _index + ':' + _name;
			}
			return _id;
		}
		
		public function get isUsing():Boolean 
		{
			return _isUsing;
		}
		
		public function set isUsing(value:Boolean):void 
		{
			_isUsing = value;
		}
	}
}