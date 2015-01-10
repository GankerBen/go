package tetequ.live.modules.room.doc.tools.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 画笔工具相关事件
	 */
	public class DocToolEvent extends Event 
	{
		public static const PENCIL_SELECT:String = "pencil-select";
		public static const TEXT_SELECT:String = "text-select";
		public static const ERASER_SELECT:String = "eraser-select";
		public static const THICKNESS_SELECT:String = "thickness-select";
		public static const COLOR_SELECT:String = "color-select";
		public static const DUMMY_SELECT:String = "dummy-select";
		
		private var _thickness:int;
		private var _color:uint;
		
		public function DocToolEvent( thickness:int, color:uint, type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			_thickness = thickness;
			_color = color;
		}
		
		public function get thickness():int 
		{
			return _thickness;
		}
		
		public function get color():uint 
		{
			return _color;
		}
		
	}

}