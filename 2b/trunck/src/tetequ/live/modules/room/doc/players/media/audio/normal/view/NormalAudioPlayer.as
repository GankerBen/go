package tetequ.live.modules.room.doc.players.media.audio.normal.view 
{
	import tetequ.live.modules.room.doc.players.common.PlayerID;
	import tetequ.live.modules.room.doc.players.media.audio.common.AudioPlayer;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 普通版本的音频播放器
	 */
	public class NormalAudioPlayer extends AudioPlayer 
	{
		/**
		 * 构造函数
		 */
		public function NormalAudioPlayer() 
		{
			super();
			
		}
		
		/**
		 * 初始化组件
		 */
		override protected function initComponents():void
		{
			super.initComponents();
			
			//controllerContainer.removeElement( controllerBackground );
			controllerContainer.removeElement( _btnStop );
			controllerContainer.removeElement( _btnPlay );
			controllerContainer.removeElement( _btnMute );
			controllerContainer.removeElement( _btnVoice );
			//controllerContainer.removeElement( _btnClose );
			//controllerContainer.removeElement( _slider );
			this.width = 390;
			this.id = PlayerID.NORMAL_AUDIO_PLAYER;
			this.showCloseButton = false;
		}
	}

}