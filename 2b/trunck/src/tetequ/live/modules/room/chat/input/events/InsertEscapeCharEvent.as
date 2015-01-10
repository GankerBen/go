package tetequ.live.modules.room.chat.input.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 插入转义符
	 */
	public class InsertEscapeCharEvent extends Event 
	{
		public static const INSERT_ESCAPE_CHAR:String = "insert-escape-char";
		private var _escapeChar:String;
		public function InsertEscapeCharEvent( escapeChar:String, type:String = INSERT_ESCAPE_CHAR, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			_escapeChar = escapeChar;
		}
		
		public function get escapeChar():String 
		{
			return _escapeChar;
		}
		
	}

}