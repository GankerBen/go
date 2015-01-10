package tetequ.live.modules.room.doc.players.media.audio.common 
{
	import tetequ.live.modules.room.doc.players.common.PlayerID;
	import tetequ.live.modules.room.doc.players.common.PlayerLayout;
	import tetequ.live.modules.room.doc.players.common.PlayerManager;
	import tetequ.live.modules.room.doc.players.media.audio.normal.view.NormalAudioPlayer;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class NormalAudioPlayerManager extends PlayerManager 
	{
		private var _sLayout:SAudioPlayerLayout;
		
		public function NormalAudioPlayerManager() 
		{
			super();
			
		}
		
		/**
		 * 初始化
		 */
		override protected function initComponents():void
		{
			super.initComponents();

			playersIDs.push( PlayerID.NORMAL_AUDIO_PLAYER );
			playersClasses.put( PlayerID.NORMAL_AUDIO_PLAYER, NormalAudioPlayer );
			
			_sLayout = new SAudioPlayerLayout();
		}
		
		override public function get playerLayout():PlayerLayout
		{
			return _sLayout;
		}
		
	}

}