package tetequ.live.modules.room.doc.players.common.events 
{
	import flash.events.Event;
	import tetequ.live.modules.room.doc.common.IFileInfo;
	import tetequ.live.modules.room.doc.players.common.PlayerID;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 调用播放器播放指定文档
	 */
	public class CallPlayerEvent extends Event 
	{
		public static const MASTER_DOCX:String = PlayerID.MASTER_DOCX_PLAYER;			//调用主讲版本的普通文档播放器
		public static const NORMAL_DOCX:String = PlayerID.NORMAL_DOCX_PLAYER;			//调用学生版本的普通文档播放器
		
		public static const MASTER_PPT:String = PlayerID.MASTER_PPT_PLAYER;				//调用主讲版本的PPT文档播放器
		public static const NORMAL_PPT:String = PlayerID.NORMAL_PPT_PLAYER;				//调用学生版本的PPT文档播放器
		
		public static const MASTER_IMAGE:String = PlayerID.MASTER_IMAGE_PLAYER;			//调用主讲版本的图片播放器
		public static const NORMAL_IMAGE:String = PlayerID.NORMAL_IMAGE_PLAYER;			//调用学生版本的图片播放器
		
		public static const MASTER_AUDIO:String = PlayerID.MASTER_AUDIO_PLAYER;			//调用主讲版本的音频播放器
		public static const NORMAL_AUDIO:String = PlayerID.NORMAL_AUDIO_PLAYER;			//调用学生版本的音频播放器
		
		public static const MASTER_VIDEO:String = PlayerID.MASTER_VIDEO_PLAYER;			//调用主讲版本的视频播放器
		public static const NORMAL_VIDEO:String = PlayerID.NORMAL_VIDEO_PLAYER;			//调用学生版本的视频播放器
		
		/**
		 * 需要打开的文件信息
		 */
		private var _fileInfo:IFileInfo;
		
		/**
		 * 构造函数
		 * @param	fileInfo
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 */
		public function CallPlayerEvent( fileInfo:IFileInfo, type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			_fileInfo = fileInfo;
		}
		
		/**
		 * 获取需要打开的文件信息
		 */
		public function get fileInfo():IFileInfo 
		{
			return _fileInfo;
		}
		
	}

}