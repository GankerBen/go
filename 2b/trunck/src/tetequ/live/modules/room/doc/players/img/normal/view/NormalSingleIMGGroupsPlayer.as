package tetequ.live.modules.room.doc.players.img.normal.view 
{
	import tetequ.live.modules.room.doc.players.common.PlayerID;
	import tetequ.live.modules.room.doc.players.common.view.VisualPlayer;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 学生版本的单张图片播放器
	 */
	public class NormalSingleIMGGroupsPlayer extends VisualPlayer 
	{
		
		public function NormalSingleIMGGroupsPlayer() 
		{
			super();
		}
		
		override protected function initComponents():void
		{
			super.initComponents();
			
			this.horizontalCenter = 0;
			this.verticalCenter = 0;
			this.showCloseButton = false;
			this.id = PlayerID.NORMAL_IMAGE_PLAYER;
		}
		
	}

}