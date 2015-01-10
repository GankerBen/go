package tetequ.live.modules.room.doc.players.media.video.normal.view 
{
	import tetequ.live.modules.room.doc.players.common.PlayerID;
	import tetequ.live.modules.room.doc.players.media.video.common.VideoPlayer;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 普通版本的视频播放器
	 */
	public class NormalVideoPlayer extends VideoPlayer 
	{
		/**
		 * 构造函数
		 */
		public function NormalVideoPlayer() 
		{
			super();
			
		}
		
		override protected function initComponents():void
		{
			super.initComponents();
			
			//this.btnClose.visible = false;
			this._btnMute.visible = false;
			this._btnPlay.visible = false;
			this._btnStop.visible = false;
			this._btnVoice.visible = false;
			//this._slider.visible = false;
			this.labelSlash.visible = false;

			this.id = PlayerID.NORMAL_VIDEO_PLAYER;
			this.percentWidth = 100;
			this.percentHeight = 100;
		}
		
	}

}