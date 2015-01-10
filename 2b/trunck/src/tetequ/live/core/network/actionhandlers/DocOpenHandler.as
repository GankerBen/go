package tetequ.live.core.network.actionhandlers 
{
	import com.e2et.datalogic.DocOpen;
	import com.e2et.datalogic.IMetaActionHandler;
	import com.e2et.datalogic.MetaAction;
	import flash.events.IEventDispatcher;
	import robotlegs.bender.framework.api.IInjector;
	import tetequ.live.modules.room.doc.common.FileInfoVo;
	import tetequ.live.modules.room.doc.common.IFileInfo;
	import tetequ.live.modules.room.doc.players.common.events.BindDocumentToCanvasEvent;
	import tetequ.live.modules.room.doc.players.common.events.CallPlayerEvent;
	import tetequ.live.modules.room.doc.players.common.MasterPlayerManager;
	import tetequ.live.modules.room.doc.players.common.PlayerID;
	import tetequ.live.modules.room.doc.players.common.PlayerManager;
	import tetequ.live.modules.room.doc.players.common.StudentPlayerManager;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 打开文档动作的处理器
	 */
	public class DocOpenHandler implements IMetaActionHandler 
	{
		[Inject]
		public var injector:IInjector;
		
		[Inject]
		public var eventDispatcher:IEventDispatcher;
		
		[Inject]
		public var mPlayerManager:MasterPlayerManager;
		
		[Inject]
		public var sPlayerManager:StudentPlayerManager;
		
		//new FileFilter("上传文件 (*.ttq,*.swf,*.flv,*.mp4,*.mp3,*.doc,*.docx,*.ppt, *.pptx, *.pdf,*.JPG, *.jpg, *.png, *.gif, *.f4v)", "*.ttq;*.swf;*.flv;*.mp4;*.mp3;*.aac;*.doc;*.docx;*.ppt;*.pptx;*.pdf;*.JPG;*.jpg;*.gif;*.png;*.f4v");
		
		
		public function DocOpenHandler() 
		{
			
		}
		
		/* INTERFACE com.e2et.datalogic.IMetaActionHandler */
		
		/**
		 * 处理打开文档的动作
		 * @param	a
		 * @param	isLocal	用来区分action是远端的还是本地的
		 */
		public function handleMetaAction( a:MetaAction, isLocal:Boolean ):void 
		{
			if ( !isLocal )
			{
				var action:DocOpen = a as DocOpen;
				/**
				 * 获取透传参数(客户端打开文档的时候，传递了其他客户端应该用什么播放器打开该文档的数据)
				 * 结构类似这样:{master:PlayerID.MATER_DOCX_PLAYER, normal:PlayerID.NORMAL_DOCX_PLAYER}
				 * 意思是，当其他客户端收到这个打开文档的动作之后，结合他们自己的权限，
				 * 选择用主讲播放器还是学生播放器。
				 */
				var docInfo:* = action.doc.docInfo;
				
				/**
				 * 当前用户的级别
				 */
				var level:uint = action.room.user.level;
				
				/**
				 * 获取用于打开当前文档的播放器id
				 */
				var playerId:String = ( level & 0x80 ) ? docInfo['master'] : docInfo['normal'];
				
				/**
				 * 打开播放器
				 */
				((level & 0x80) ? mPlayerManager : mPlayerManager).openPlayerById( playerId );
				
				/**
				 * 构造一个文档信息对象
				 */
				var fileInfo:IFileInfo = new FileInfoVo();
				fileInfo.id = docInfo['id'];
				fileInfo.name = action.room.doc.name;
				fileInfo.path = action.room.doc.uri;
				fileInfo.type = docInfo['type'];
				fileInfo.pages = docInfo['pages'];
				
				//通知播放器打开文档第一页
				eventDispatcher.dispatchEvent( new CallPlayerEvent( fileInfo, playerId ) );
				
				//设置文档对象到绘图层
				eventDispatcher.dispatchEvent( new BindDocumentToCanvasEvent( action.doc ) );
			}
		}
		
	}

}