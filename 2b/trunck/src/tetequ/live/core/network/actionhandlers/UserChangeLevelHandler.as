package tetequ.live.core.network.actionhandlers 
{
	import com.e2et.datalogic.Document;
	import com.e2et.datalogic.IMetaActionHandler;
	import com.e2et.datalogic.MetaAction;
	import com.e2et.datalogic.UserChangeLevel;
	import flash.events.IEventDispatcher;
	import tetequ.live.core.network.NetworkFacade;
	import tetequ.live.modules.room.doc.common.FileInfoVo;
	import tetequ.live.modules.room.doc.common.IFileInfo;
	import tetequ.live.modules.room.doc.players.common.events.BindDocumentToCanvasEvent;
	import tetequ.live.modules.room.doc.players.common.events.CallPlayerEvent;
	import tetequ.live.modules.room.doc.players.common.events.DocGotoEvent;
	import tetequ.live.modules.room.doc.players.common.MasterPlayerManager;
	import tetequ.live.modules.room.doc.players.common.StudentPlayerManager;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class UserChangeLevelHandler implements IMetaActionHandler 
	{
		[Inject]
		public var eventDispatcher:IEventDispatcher;
		
		[Inject]
		public var mPlayerManager:MasterPlayerManager;
		
		[Inject]
		public var sPlayerManager:StudentPlayerManager;
		
		[Inject]
		public var networkFacade:NetworkFacade;
		
		public function UserChangeLevelHandler() 
		{
			
		}
		
		/* INTERFACE com.e2et.datalogic.IMetaActionHandler */
		
		public function handleMetaAction(a:MetaAction, isLocal:Boolean):void 
		{
			var action:UserChangeLevel = a as UserChangeLevel;
			if ( !isLocal )
			{
				
			}else {
				var doc:Document = networkFacade.doc;
				
				if ( !doc ) return;
				
				var docInfo:* = doc.docInfo;
					
				/**
				 * 当前用户的级别
				 */
				var level:uint = action.user.level;
				
				/**
				 * 获取用于打开当前文档的播放器id
				 */
				var playerId:String = ( level & 0x80 ) ? docInfo['master'] : docInfo['normal'];
				
				/**
				 * 打开播放器
				 */
				((level & 0x80) ? mPlayerManager : sPlayerManager).openPlayerById( playerId );
				
				/**
				 * 构造一个文档信息对象
				 */
				var fileInfo:IFileInfo = new FileInfoVo();
				fileInfo.id = docInfo['id'];
				fileInfo.name = doc.name;
				fileInfo.path = doc.uri;
				fileInfo.type = docInfo['type'];
				fileInfo.pages = docInfo['pages'];
				
				//通知播放器打开文档
				eventDispatcher.dispatchEvent( new CallPlayerEvent( fileInfo, playerId ) );
				
				//设置文档对象到绘图层
				eventDispatcher.dispatchEvent( new BindDocumentToCanvasEvent( doc ) );
				
				//播放指定页文档(内部pageNo从0开始，所以这里要+1)
				eventDispatcher.dispatchEvent( new DocGotoEvent( doc.pageNo + 1, doc.page.step, playerId ) );
			}
		}
		
	}

}