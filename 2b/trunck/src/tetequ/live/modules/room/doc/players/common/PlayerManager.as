package tetequ.live.modules.room.doc.players.common 
{
	import flash.events.MouseEvent;
	import org.flexlite.domUI.components.Button;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.core.IVisualElement;
	import org.flexlite.domUI.layouts.HorizontalLayout;
	import tetequ.live.core.network.NetworkFacade;
	import tetequ.live.modules.room.avdocument.AVDocumentManager;
	import tetequ.live.modules.room.common.GlobalVars;
	import tetequ.live.modules.room.common.panel.PanelID;
	import tetequ.live.modules.room.doc.players.common.PlayerID;
	import tetequ.live.modules.room.doc.players.common.view.VisualPlayer;
	import tetequ.live.modules.room.doc.players.docx.master.view.MasterDocxGroupsPlayer;
	import tetequ.live.modules.room.doc.players.docx.normal.view.NormalDocxGroupsPlayer;
	import tetequ.live.modules.room.doc.players.img.master.view.MasterSingleIMGGroupsPlayer;
	import tetequ.live.modules.room.doc.players.img.normal.view.NormalSingleIMGGroupsPlayer;
	import tetequ.live.modules.room.doc.players.media.audio.common.MasterAudioPlayerManager;
	import tetequ.live.modules.room.doc.players.media.audio.common.NormalAudioPlayerManager;
	import tetequ.live.modules.room.doc.players.media.video.common.MasterVideoPlayerManager;
	import tetequ.live.modules.room.doc.players.media.video.common.StudentVideoPlayerManager;
	import tetequ.live.modules.room.doc.players.media.video.master.view.MasterVideoPlayer;
	import tetequ.live.modules.room.doc.players.media.video.normal.view.NormalVideoPlayer;
	import tetequ.live.modules.room.doc.players.ppt.master.view.MasterPPTPlayer;
	import tetequ.live.modules.room.doc.players.ppt.normal.view.NormalPPTPlayer;
	import tetequ.live.modules.room.doc.tools.view.DocToolView;
	//import tetequ.live.modules.room.stream.video.master.view.MultiAVView;
	import tetequ.live.utils.HashMap;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 文档播放器管理器
	 * 负责切换各种文档的播放器(音视频播放器除外)
	 */
	public class PlayerManager
	{
		protected var players:HashMap;
		protected var playersClasses:HashMap;
		protected var playersIDs:Vector.<String>;
		protected var curPlayerId:String;

		public function PlayerManager() 
		{
			super();
			initComponents();
		}

		protected function initComponents():void 
		{
			players = new HashMap();
			playersClasses = new HashMap();
			playersIDs = new Vector.<String>;
		}
		
		private var _numOpen:int;
		
		/**
		 * 打开播放器
		 * PS:当没有视频打开时，打开文档后，文档
		 * 占据中间空白部分区域，当有视频打开时，
		 * 打开文档后，文档出现在视频右边。
		 * @param	id 播放器id
		 */
		public function openPlayerById( id:String ):void
		{
			AVDocumentManager.getInstance().whenDocumentOpened(GlobalVars.document);
			
			closeCurPlayer();
			if ( invalid( id ) )
			{
				throw new Error( "非法的播放器ID!" + id );
			}
			if ( isOpened( id ) )
			{
				//throw new Error( "播放器已经打开!" );
			}else 
			{
				var player:IVisualElement = players.getValue( id );
				
				if ( !player )
				{
					player = new ((playersClasses.getValue( id )) as Class);
					players.put( id, player );
				}
				
				playerLayout.addPlayer( player );
				curPlayerId = id;
				_numOpen++;
			}
		}
		
		/**
		 * 关闭当前打开着的播放器
		 */
		public function closeCurPlayer():void
		{
			if ( curPlayerId != "" && curPlayerId != null )
			{
				closePlayerById( curPlayerId );
			}
		}
		
		/**
		 * 关闭指定播放器
		 * @param	id
		 */
		public function closePlayerById( id:String ):void
		{
			if ( invalid( id ) )
			{
				throw new Error( "非法的播放器ID!" );
			}
			if ( !isOpened( id ) )
			{
				//throw new Error( "播放器已经关闭!" );
			}else 
			{
				playerLayout.removePlayer();
				curPlayerId = "";
			}

			_numOpen--;
		}
		
		/**
		 * 某个播放器是否正在打开
		 * @param	id
		 */
		private function isOpened( id:String ):Boolean
		{
			var player:IVisualElement = players.getValue( id );
			if ( !player )
			{
				return false;
			}
			return playerLayout.containsPlayer( player );
		}
		
		/**
		 * 播放器id是否非法
		 * @param	id
		 * @return
		 */
		private function invalid( id:String ):Boolean
		{
			return playersIDs.indexOf( id ) < 0;
		}
		
		/**
		 * 交给子类重写
		 */
		public function get playerLayout():PlayerLayout
		{
			throw new Error('子类需要重写该方法！');
		}
		
	}

}