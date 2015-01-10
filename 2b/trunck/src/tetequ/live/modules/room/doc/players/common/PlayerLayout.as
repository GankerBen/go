package tetequ.live.modules.room.doc.players.common 
{
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.core.IVisualElement;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 文档播放器容器
	 */
	public class PlayerLayout extends Group 
	{
		public function PlayerLayout() 
		{
			super();
			initComponents();
		}

		protected function initComponents():void 
		{
			this.percentWidth = 100;
			this.percentHeight = 100;
		}

		public function addPlayer( player:IVisualElement ):void
		{
			addElement( player );
		}

		public function removePlayer():void
		{
			removeAllElements();
		}

		public function containsPlayer( player:IVisualElement ):Boolean
		{
			return containsElement( player );
		}
		
	}

}