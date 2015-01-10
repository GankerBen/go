package tetequ.live.modules.room.doc.players.img.master.view 
{
	import org.flexlite.domUI.components.Group;
	import tetequ.live.modules.room.doc.players.common.PlayerID;
	import tetequ.live.modules.room.doc.players.common.view.VisualPlayer;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 主讲版本的单张图片播放器
	 */
	public class MasterSingleIMGGroupsPlayer extends VisualPlayer 
	{
		protected var toolsContainer:Group;				//工具栏容器

		public function MasterSingleIMGGroupsPlayer() 
		{
			super();
		}
		
		override protected function initComponents():void
		{
			super.initComponents();
			
			this.horizontalCenter = 0;
			this.verticalCenter = 0;
			this.scroller.bottom = -60;
			this.scroller.top = -50;
			this.id = PlayerID.MASTER_IMAGE_PLAYER;
		}
		
	}

}