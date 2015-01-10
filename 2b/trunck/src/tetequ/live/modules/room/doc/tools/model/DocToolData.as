package tetequ.live.modules.room.doc.tools.model 
{
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class DocToolData 
	{
		public static const TOOL_PENCIL:int = 1;
		public static const TOOL_TEXT:int = 2;
		public static const TOOL_ERASER:int = 3;
		public static const TOOL_DUMMY:int = 0;//什么工具也没选
		
		public static var color:uint;
		public static var thickness:int = 5;
		public static const TEXT_SIZE:int = 30;
		public static var curTool:int = TOOL_DUMMY;
		
		public static var hasToken:Boolean;
		
		private static var textObserver:Function;//当用户使用文本工具的时候，如果点击了其他地方，立刻取消文本的焦点
		public static function setTextObserver( observer:Function ):void
		{
			textObserver = observer;
		}
		
		public static function sendTextNotice():void
		{
			if ( textObserver != null )
			{
				textObserver.apply();
			}
		}
	}

}