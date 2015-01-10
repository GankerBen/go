package tetequ.live.core.network.actionhandlers 
{
	import com.e2et.datalogic.IMetaActionHandler;
	import com.e2et.datalogic.MetaAction;
	import com.e2et.datalogic.RoomChangeConfig;
	import flash.events.IEventDispatcher;
	import flash.external.ExternalInterface;
	import tetequ.live.modules.room.avdocument.AVDocumentManager;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class RoomChangeConfigHandler implements IMetaActionHandler
	{
		[Inject]
		public var eventDispatcher:IEventDispatcher;
		
		public function RoomChangeConfigHandler() 
		{
			
		}
		
		/* INTERFACE com.e2et.datalogic.IMetaActionHandler */
		
		public function handleMetaAction(a:MetaAction, isLocal:Boolean):void 
		{
			var action:RoomChangeConfig = a as RoomChangeConfig;
			if ( !isLocal )
			{
				if (action.name == AVDocumentManager.VIDEO_LIST_MAP)
				{
					trace('视频或者切换了!');
					AVDocumentManager.getInstance().videoListMapChanged(action.value);
				}else if (action.name.indexOf('vcmap%') >= 0)
				{
					trace(action.value);
					AVDocumentManager.getInstance().videoAttachContent(action.name.split('%')[1], action.value);
				}
			}
		}
		
	}

}