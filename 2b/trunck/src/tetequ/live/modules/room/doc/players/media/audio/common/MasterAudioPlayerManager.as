package tetequ.live.modules.room.doc.players.media.audio.common 
{
	import tetequ.live.modules.room.doc.players.common.PlayerID;
	import tetequ.live.modules.room.doc.players.common.PlayerLayout;
	import tetequ.live.modules.room.doc.players.common.PlayerManager;
	import tetequ.live.modules.room.doc.players.media.audio.master.view.MasterAudioPlayer;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class MasterAudioPlayerManager extends PlayerManager 
	{
		private var _mLayout:MAudioPlayerLayout;
		
		public function MasterAudioPlayerManager() 
		{
			super();
			
		}
		
		/**
		 * 初始化
		 */
		override protected function initComponents():void
		{
			super.initComponents();

			playersIDs.push( PlayerID.MASTER_AUDIO_PLAYER );
			playersClasses.put( PlayerID.MASTER_AUDIO_PLAYER, MasterAudioPlayer );
			
			_mLayout = new MAudioPlayerLayout();
			_mLayout.verticalCenter = 0;
			_mLayout.horizontalCenter = 0;
		}
		
		override public function get playerLayout():PlayerLayout
		{
			return _mLayout;
		}
		
	}

}