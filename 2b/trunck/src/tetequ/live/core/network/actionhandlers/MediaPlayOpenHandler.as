package tetequ.live.core.network.actionhandlers 
{
	import com.e2et.datalogic.IMetaActionHandler;
	import com.e2et.datalogic.MediaPlayOpen;
	import com.e2et.datalogic.MetaAction;
	import flash.events.IEventDispatcher;
	import framework.view.UIRoot;
	import tetequ.live.modules.room.doc.common.FileInfoVo;
	import tetequ.live.modules.room.doc.common.IFileInfo;
	import tetequ.live.modules.room.doc.doclist.model.FileType;
	import tetequ.live.modules.room.doc.players.common.events.CallPlayerEvent;
	import tetequ.live.modules.room.doc.players.common.MasterPlayerManager;
	import tetequ.live.modules.room.doc.players.common.StudentPlayerManager;
	import tetequ.live.modules.room.doc.players.media.audio.common.MasterAudioPlayerManager;
	import tetequ.live.modules.room.doc.players.media.audio.common.NormalAudioPlayerManager;
	import tetequ.live.modules.room.doc.players.media.video.common.MasterVideoPlayerManager;
	import tetequ.live.modules.room.doc.players.media.video.common.StudentVideoPlayerManager;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class MediaPlayOpenHandler implements IMetaActionHandler 
	{
		[Inject]
		public var eventDispatcher:IEventDispatcher;
		
		[Inject]
		public var mPlayerManager:MasterPlayerManager;
		
		[Inject]
		public var sPlayerManager:StudentPlayerManager;
		
		[Inject]
		public var mAudioPlayerManager:MasterAudioPlayerManager;
		
		[Inject]
		public var nAudioPlayerManager:NormalAudioPlayerManager;
		
		[Inject]
		public var mVideoPlayerManager:MasterVideoPlayerManager;
		
		[Inject]
		public var sVideoPlayerManager:StudentVideoPlayerManager;
		
		[Inject]
		public var uiroot:UIRoot;
		
		public function MediaPlayOpenHandler() 
		{
			
		}
		
		/* INTERFACE com.e2et.datalogic.IMetaActionHandler */
		
		public function handleMetaAction(a:MetaAction, isLocal:Boolean):void 
		{
			if ( isLocal )
			{
				
			}else
			{
				//打开的可能是图片、视频流等
				
				var action:MediaPlayOpen = a as MediaPlayOpen;
				/**
				 * 获取透传参数(客户端打开文档的时候，传递了其他客户端应该用什么播放器打开该文档的数据)
				 * 结构类似这样:{master:PlayerID.MATER_DOCX_PLAYER, normal:PlayerID.NORMAL_DOCX_PLAYER}
				 * 意思是，当其他客户端收到这个打开文档的动作之后，结合他们自己的权限，
				 * 选择用主讲播放器还是学生播放器。
				 */
				var mediaInfo:* = action.mediaPlayer.mediaInfo;
				
				/**
				 * 当前用户的级别
				 */
				var level:uint = action.room.user.level;
				
				//是否是主讲
				var isMaster:Boolean = level & 0x80;
				
				/**
				 * 获取用于打开当前文档的播放器id
				 */
				var playerId:String = isMaster ? mediaInfo['master'] : mediaInfo['normal'];
				
				//此处的playerId如果是AUDIO族的，则需要特殊的处理
				var type:String = mediaInfo['type'];
				if ( type == FileType.AUDIO )
				{
					uiroot.addElement( ( isMaster ? mAudioPlayerManager : mAudioPlayerManager).playerLayout );
					( isMaster ? mAudioPlayerManager : mAudioPlayerManager).openPlayerById( playerId );
				}else if ( type == FileType.VIDEO )
				{
					uiroot.addElement( ( isMaster ? mVideoPlayerManager : mVideoPlayerManager).playerLayout );
					( isMaster ? mVideoPlayerManager : mVideoPlayerManager).openPlayerById( playerId );
				}
				else {
					( isMaster ? mPlayerManager : mPlayerManager).openPlayerById( playerId );
				}
				
				var fileInfo:IFileInfo = new FileInfoVo();
				fileInfo.id = mediaInfo['id'];
				fileInfo.name = mediaInfo['name'];
				fileInfo.path = action.mediaPlayer.file;
				fileInfo.type = mediaInfo['type'];
				
				eventDispatcher.dispatchEvent( new CallPlayerEvent( fileInfo, playerId ) );
			}
		}
		
	}

}