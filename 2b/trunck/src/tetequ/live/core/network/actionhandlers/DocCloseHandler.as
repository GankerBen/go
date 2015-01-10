package tetequ.live.core.network.actionhandlers 
{
	import com.e2et.datalogic.DocClose;
	import com.e2et.datalogic.IMetaActionHandler;
	import com.e2et.datalogic.MetaAction;
	import flash.events.IEventDispatcher;
	import tetequ.live.modules.room.doc.players.common.events.DocCloseEvent;
	import tetequ.live.modules.room.doc.players.common.PlayerManager;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 文档关闭动作处理器
	 */
	public class DocCloseHandler implements IMetaActionHandler 
	{
		[Inject]
		public var eventDispatcher:IEventDispatcher;
		
		public function DocCloseHandler() 
		{
			
		}
		
		/* INTERFACE com.e2et.datalogic.IMetaActionHandler */
		
		public function handleMetaAction(a:MetaAction, isLocal:Boolean):void 
		{
			if ( !isLocal )
			{
				var action:DocClose = a as DocClose;
				
				/**
				 * 透传数据
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

				//关闭指定播放器
				eventDispatcher.dispatchEvent( new DocCloseEvent( playerId ) );
			}
		}
		
	}

}