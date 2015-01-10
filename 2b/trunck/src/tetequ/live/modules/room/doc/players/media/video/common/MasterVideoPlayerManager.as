package tetequ.live.modules.room.doc.players.media.video.common 
{
	import flash.events.Event;
	import org.flexlite.domUI.core.DomGlobals;
	import tetequ.live.modules.room.doc.players.common.PlayerID;
	import tetequ.live.modules.room.doc.players.common.PlayerLayout;
	import tetequ.live.modules.room.doc.players.common.PlayerManager;
	import tetequ.live.modules.room.doc.players.media.video.master.view.MasterVideoPlayer;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class MasterVideoPlayerManager extends PlayerManager 
	{
		private var _mLayout:MVideoPlayerLayout;
		
		public function MasterVideoPlayerManager() 
		{
			super();
			
		}
		
		/**
		 * 初始化
		 */
		override protected function initComponents():void
		{
			super.initComponents();

			playersIDs.push( PlayerID.MASTER_VIDEO_PLAYER );
			playersClasses.put( PlayerID.MASTER_VIDEO_PLAYER, MasterVideoPlayer );
			
			_mLayout = new MVideoPlayerLayout();
			_mLayout.percentWidth = 30;
			_mLayout.percentHeight = 50;
			_mLayout.addEventListener( Event.ADDED_TO_STAGE, onStage );
		}
		
		private function onStage(e:Event):void 
		{
			_mLayout.removeEventListener(Event.ADDED_TO_STAGE, onStage);
			_mLayout.x = (DomGlobals.stage.stageWidth - 500) >> 1;
			_mLayout.y = (DomGlobals.stage.stageHeight - 500) >> 1;
		}
		
		override public function get playerLayout():PlayerLayout
		{
			return _mLayout;
		}
		
	}

}