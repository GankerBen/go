package tetequ.live.modules.room.doc.players.common 
{
	import tetequ.live.modules.room.doc.players.docx.master.view.MasterDocxGroupsPlayer;
	import tetequ.live.modules.room.doc.players.img.master.view.MasterSingleIMGGroupsPlayer;
	import tetequ.live.modules.room.doc.players.media.video.master.view.MasterVideoPlayer;
	import tetequ.live.modules.room.doc.players.ppt.master.view.MasterPPTPlayer;
	/**
	 * ...
	 * @author Pandazhong
	 * 管理一组只有主讲能操作的播放器
	 */
	public class MasterPlayerManager extends PlayerManager 
	{
		[Inject]
		public var mLayout:MasterPlayerLayout;
		
		public function MasterPlayerManager() 
		{
			super();
		}

		override protected function initComponents():void
		{
			super.initComponents();
			
			playersIDs.push( PlayerID.MASTER_DOCX_PLAYER );
			playersIDs.push( PlayerID.MASTER_IMAGE_PLAYER );
			playersIDs.push( PlayerID.MASTER_PPT_PLAYER );
			playersIDs.push( PlayerID.MASTER_VIDEO_PLAYER );
			
			playersClasses.put( PlayerID.MASTER_DOCX_PLAYER, MasterDocxGroupsPlayer );
			playersClasses.put( PlayerID.MASTER_IMAGE_PLAYER, MasterSingleIMGGroupsPlayer );
			playersClasses.put( PlayerID.MASTER_PPT_PLAYER, MasterPPTPlayer );
		}
		
		override public function get playerLayout():PlayerLayout
		{
			return mLayout;
		}
	}
}