package tetequ.live.modules.room.doc.players.media.video.common 
{
	import tetequ.live.modules.room.doc.players.common.PlayerID;
	import tetequ.live.modules.room.doc.players.common.PlayerLayout;
	import tetequ.live.modules.room.doc.players.common.PlayerManager;
	import tetequ.live.modules.room.doc.players.media.video.master.view.MasterVideoPlayer;
	import tetequ.live.modules.room.doc.players.media.video.normal.view.NormalVideoPlayer;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class StudentVideoPlayerManager extends PlayerManager 
	{
		private var _sLayout:SVideoPlayerLayout;
		
		public function StudentVideoPlayerManager() 
		{
			super();
			
		}
		
		/**
		 * 初始化
		 */
		override protected function initComponents():void
		{
			super.initComponents();

			playersIDs.push( PlayerID.MASTER_VIDEO_PLAYER );
			playersClasses.put( PlayerID.MASTER_VIDEO_PLAYER, MasterVideoPlayer );
			
			_sLayout = new SVideoPlayerLayout();
			//_sLayout.verticalCenter = 0;
			//_sLayout.horizontalCenter = 0;
			_sLayout.percentWidth = 30;
			_sLayout.percentHeight = 50;
		}
		
		override public function get playerLayout():PlayerLayout
		{
			return _sLayout;
		}
		
	}

}