package tetequ.live.modules.room.doc.players.docx.master.view 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import org.flexlite.domUI.components.Button;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.components.TextInput;
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.domUI.core.IVisualElement;
	import org.flexlite.domUI.events.ResizeEvent;
	import org.flexlite.domUI.skins.vector.ButtonSkin;
	import org.flexlite.domUI.skins.vector.TextInputSkin;
	import tetequ.live.core.network.NetworkFacade;
	import tetequ.live.modules.room.doc.players.common.PlayerID;
	import tetequ.live.modules.room.doc.players.docx.common.MasterDocumentPlayer;
	import tetequ.live.modules.room.doc.tools.view.DocToolView;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 主讲版本的普通文档(多页、且单页静态)播放器
	 */
	public class MasterDocxGroupsPlayer extends MasterDocumentPlayer
	{
		private var _network:NetworkFacade;
		/**
		 * 构造函数
		 */
		public function MasterDocxGroupsPlayer() 
		{
			super();
		}
		
		/*	---------------------------------------初始化播放器组件------------------------------------ */
		override protected function initComponents():void
		{
			super.initComponents();
			this.id = PlayerID.MASTER_DOCX_PLAYER;
			this.percentWidth = 100;
			this.percentHeight = 100;
		}
		
		public function set network(value:NetworkFacade):void 
		{
			_network = value;
			if (this.stage&&_network.hasToken)
				this.addElement(DocToolView.getInstance());
		}

	}

}