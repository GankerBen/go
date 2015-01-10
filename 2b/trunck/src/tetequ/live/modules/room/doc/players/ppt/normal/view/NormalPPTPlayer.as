package tetequ.live.modules.room.doc.players.ppt.normal.view 
{
	import tetequ.live.modules.room.doc.players.common.PlayerID;
	import tetequ.live.modules.room.doc.players.docx.common.NormalDocumentPlayer;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 学生版本的PPT文档播放器
	 */
	public class NormalPPTPlayer extends NormalDocumentPlayer 
	{
		
		/**
		 * 构造函数
		 */
		public function NormalPPTPlayer() 
		{
			super();
			
		}
		
		override protected function initComponents():void
		{
			super.initComponents();

			this.id = PlayerID.NORMAL_PPT_PLAYER;
			this.showCloseButton = false;
		}
		
	}

}