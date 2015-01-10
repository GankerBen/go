package tetequ.live.modules.room.doc.players.common.events 
{
	import flash.events.Event;
	import tetequ.live.modules.room.doc.players.common.PlayerID;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 文档关闭事件
	 */
	public class DocCloseEvent extends Event 
	{
		public static const CLOSE_DOCX_MASTER:String = PlayerID.MASTER_DOCX_PLAYER;
		public static const CLOSE_DOCX_NORMAL:String = PlayerID.NORMAL_DOCX_PLAYER;
		
		public static const CLOSE_PPT_MASTER:String = PlayerID.MASTER_PPT_PLAYER;
		public static const CLOSE_PPT_NORMAL:String = PlayerID.NORMAL_PPT_PLAYER;
		
		public static const CLOSE_IMAGE_MASTER:String = PlayerID.MASTER_IMAGE_PLAYER;
		public static const CLOSE_IMAGE_NORMAL:String = PlayerID.NORMAL_IMAGE_PLAYER;
		
		public static const CLOSE_VIDEO_MASTER:String = PlayerID.MASTER_VIDEO_PLAYER;
		public static const CLOSE_VIDEO_NORMAL:String = PlayerID.NORMAL_VIDEO_PLAYER;
		
		public static const CLOSE_AUDIO_MASTER:String = PlayerID.MASTER_AUDIO_PLAYER;
		public static const CLOSE_AUDIO_NORMAL:String = PlayerID.NORMAL_AUDIO_PLAYER;
		
		public function DocCloseEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			
		}
		
	}

}