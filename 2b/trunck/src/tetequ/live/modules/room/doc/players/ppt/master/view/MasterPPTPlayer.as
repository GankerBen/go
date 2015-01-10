package tetequ.live.modules.room.doc.players.ppt.master.view 
{
	import flash.events.Event;
	import tetequ.live.core.network.NetworkFacade;
	import tetequ.live.modules.room.doc.players.common.PlayerID;
	import tetequ.live.modules.room.doc.players.docx.common.MasterDocumentPlayer;
	import tetequ.live.modules.room.doc.tools.view.DocToolView;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 主讲版本的PPT文档播放器
	 */
	public class MasterPPTPlayer extends MasterDocumentPlayer 
	{
		private var _network:NetworkFacade;
		/**
		 * 构造函数
		 */
		public function MasterPPTPlayer() 
		{
			super();
			
		}
		
		/**
		 * 初始化组件
		 */
		override protected function initComponents():void
		{
			super.initComponents();

			this.id = PlayerID.MASTER_PPT_PLAYER;
		}
		
		public function set network(value:NetworkFacade):void 
		{
			_network = value;
			if (this.stage&&_network.hasToken)
				this.addElement(DocToolView.getInstance());
		}
		
	}

}