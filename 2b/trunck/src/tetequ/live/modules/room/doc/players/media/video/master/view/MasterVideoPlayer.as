package tetequ.live.modules.room.doc.players.media.video.master.view 
{
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.components.UIAsset;
	import tetequ.live.modules.room.doc.players.common.PlayerID;
	import tetequ.live.modules.room.doc.players.media.video.common.VideoPlayer;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 主讲版本的视频播放器
	 */
	public class MasterVideoPlayer extends VideoPlayer 
	{
		public var tips:Label;
		/**
		 * 构造函数
		 */
		public function MasterVideoPlayer() 
		{
			super();
		}
		
		/**
		 * 初始化组件
		 */
		override protected function initComponents():void
		{
			super.initComponents();

			this.id = PlayerID.MASTER_VIDEO_PLAYER;
			this.width = 500;
			this.height = 500;
			//this.btnClose.visible = false;
			this.labelSlash.visible = false;
			this.contentTitle.visible = false;
			trace("initComponents..");
		}
		
		public function showTips():void
		{
			if ( !tips )
			{
				tips = new Label();
				tips.horizontalCenter = 0;
				tips.verticalCenter = 0;
				tips.text = "正在打开视频，请稍候...";
			}
			
			addElement( tips );
		}
		
		public function hideTips():void
		{
			if ( !tips ) return;
			if ( containsElement( tips ) )
			{
				removeElement( tips );
			}
		}
		
	}

}