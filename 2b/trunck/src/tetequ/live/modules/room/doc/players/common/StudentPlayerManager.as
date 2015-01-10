package tetequ.live.modules.room.doc.players.common 
{
	import tetequ.live.modules.room.doc.players.docx.master.view.MasterDocxGroupsPlayer;
	import tetequ.live.modules.room.doc.players.docx.normal.view.NormalDocxGroupsPlayer;
	import tetequ.live.modules.room.doc.players.img.master.view.MasterSingleIMGGroupsPlayer;
	import tetequ.live.modules.room.doc.players.img.normal.view.NormalSingleIMGGroupsPlayer;
	import tetequ.live.modules.room.doc.players.media.video.master.view.MasterVideoPlayer;
	import tetequ.live.modules.room.doc.players.media.video.normal.view.NormalVideoPlayer;
	import tetequ.live.modules.room.doc.players.ppt.master.view.MasterPPTPlayer;
	import tetequ.live.modules.room.doc.players.ppt.normal.view.NormalPPTPlayer;
	/**
	 * ...
	 * @author Pandazhong
	 * 管理一组学生能操作的播放器
	 */
	public class StudentPlayerManager extends PlayerManager 
	{
		[Inject]
		public var sLayout:MasterPlayerLayout;
		
		public function StudentPlayerManager() 
		{
			super();
			
		}

		override protected function initComponents():void
		{
			super.initComponents();

			//playersIDs.push( PlayerID.NORMAL_DOCX_PLAYER );
			//playersIDs.push( PlayerID.NORMAL_IMAGE_PLAYER );
			//playersIDs.push( PlayerID.NORMAL_PPT_PLAYER );
			//playersIDs.push( PlayerID.NORMAL_VIDEO_PLAYER );
//
			//playersClasses.put( PlayerID.NORMAL_DOCX_PLAYER, NormalDocxGroupsPlayer );
			//playersClasses.put( PlayerID.NORMAL_IMAGE_PLAYER, NormalSingleIMGGroupsPlayer );
			//playersClasses.put( PlayerID.NORMAL_PPT_PLAYER, NormalPPTPlayer );
			//playersClasses.put( PlayerID.NORMAL_VIDEO_PLAYER, NormalVideoPlayer );
			
			playersIDs.push( PlayerID.MASTER_DOCX_PLAYER );
			playersIDs.push( PlayerID.MASTER_IMAGE_PLAYER );
			playersIDs.push( PlayerID.MASTER_PPT_PLAYER );
			playersIDs.push( PlayerID.MASTER_VIDEO_PLAYER );
			
			playersClasses.put( PlayerID.MASTER_DOCX_PLAYER, MasterDocxGroupsPlayer );
			playersClasses.put( PlayerID.MASTER_IMAGE_PLAYER, MasterSingleIMGGroupsPlayer );
			playersClasses.put( PlayerID.MASTER_PPT_PLAYER, MasterPPTPlayer );
			playersClasses.put( PlayerID.MASTER_VIDEO_PLAYER, MasterVideoPlayer );
		}
		
		override public function get playerLayout():PlayerLayout
		{
			return sLayout;
		}
	}
}