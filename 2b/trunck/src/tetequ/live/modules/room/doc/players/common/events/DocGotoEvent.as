package tetequ.live.modules.room.doc.players.common.events 
{
	import flash.events.Event;
	import tetequ.live.modules.room.doc.players.common.PlayerID;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 文档翻页事件
	 */
	public class DocGotoEvent extends Event 
	{
		public static const MASTER_DOCX:String = PlayerID.MASTER_DOCX_PLAYER;
		public static const NORMAL_DOCX:String = PlayerID.NORMAL_DOCX_PLAYER;
		
		public static const MASTER_PPT:String = PlayerID.MASTER_PPT_PLAYER;
		public static const NORMAL_PPT:String = PlayerID.NORMAL_PPT_PLAYER;
		
		/**
		 * 文档页码
		 */
		private var _pageNo:uint;
		
		/**
		 * 当前页步数
		 */
		private var _pageStep:uint;
		
		public function DocGotoEvent( pageNo:uint, pageStep:uint, type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			_pageNo = pageNo;
			_pageStep = pageStep;
		}
		
		public function get pageNo():uint 
		{
			return _pageNo;
		}
		
		public function get pageStep():uint 
		{
			return _pageStep;
		}
		
	}

}