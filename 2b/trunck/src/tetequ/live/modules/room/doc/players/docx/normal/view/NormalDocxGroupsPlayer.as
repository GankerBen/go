package tetequ.live.modules.room.doc.players.docx.normal.view 
{
	import flash.display.Sprite;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.components.UIAsset;
	import tetequ.live.modules.room.doc.players.common.PlayerID;
	import tetequ.live.modules.room.doc.players.docx.common.NormalDocumentPlayer;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 学生版本的普通文档播放器
	 */
	public class NormalDocxGroupsPlayer extends NormalDocumentPlayer 
	{
		/**
		 * 构造函数
		 */
		public function NormalDocxGroupsPlayer() 
		{
			super();
		}
		
		/**
		 * 初始化组件
		 */
		override protected function initComponents():void
		{
			super.initComponents();
			this.id = PlayerID.NORMAL_DOCX_PLAYER;
			this.percentWidth = 100;
			this.percentHeight = 100;
		}
		
		/**
		 * 设置总页数
		 * @param	value
		 */
		public function setTotalPages( value:int ):void
		{
			this.labelPageTotal.text = value.toString();
		}
		
		/**
		 * 设置当前页
		 * @param	value
		 */
		public function setCurrentPage( value:int ):void
		{
			this._labelCurPage.text = value.toString();
		}
		
	}

}