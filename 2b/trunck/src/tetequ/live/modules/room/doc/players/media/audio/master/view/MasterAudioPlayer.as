package tetequ.live.modules.room.doc.players.media.audio.master.view 
{
	import tetequ.live.modules.room.doc.players.common.PlayerID;
	import tetequ.live.modules.room.doc.players.media.audio.common.AudioPlayer;
	/**
	 * ...
	 * @author Pandazhong
	 * 主讲版本的音频播放器
	 */
	public class MasterAudioPlayer extends AudioPlayer
	{
		
		public function MasterAudioPlayer() 
		{
				
		}
		
		override protected function initComponents():void
		{
			super.initComponents();
			this.id = PlayerID.MASTER_AUDIO_PLAYER;
		}
		
	}

}