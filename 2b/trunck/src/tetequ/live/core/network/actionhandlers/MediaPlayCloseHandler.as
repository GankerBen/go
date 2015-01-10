package tetequ.live.core.network.actionhandlers 
{
	import com.e2et.datalogic.IMetaActionHandler;
	import com.e2et.datalogic.MediaPlayClose;
	import com.e2et.datalogic.MetaAction;
	import flash.events.IEventDispatcher;
	import tetequ.live.modules.room.doc.players.common.events.DocCloseEvent;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class MediaPlayCloseHandler implements IMetaActionHandler 
	{
		[Inject]
		public var eventDispatcher:IEventDispatcher;
		
		public function MediaPlayCloseHandler() 
		{
			
		}
		
		/* INTERFACE com.e2et.datalogic.IMetaActionHandler */
		
		public function handleMetaAction(a:MetaAction, isLocal:Boolean):void 
		{
			if ( isLocal )
			{
				
			}else
			{
				var action:MediaPlayClose = a as MediaPlayClose;
				
				/**
				 * 透传数据
				 */
				var mediaInfo:* = action.mediaPlayer.mediaInfo;
				
				/**
				 * 当前用户的级别
				 */
				var level:uint = action.room.user.level;
				
				/**
				 * 获取用于打开当前文档的播放器id
				 */
				var playerId:String = ( level & 0x80 ) ? mediaInfo['master'] : mediaInfo['normal'];

				//关闭指定播放器
				eventDispatcher.dispatchEvent( new DocCloseEvent( playerId ) );
			}
		}
		
	}

}