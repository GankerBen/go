package tetequ.live.core.network.actionhandlers 
{
	import com.e2et.datalogic.AVStreamClose;
	import com.e2et.datalogic.IMetaActionHandler;
	import com.e2et.datalogic.MetaAction;
	import flash.events.IEventDispatcher;
	import tetequ.live.core.network.MediaPlayHandler;
	import tetequ.live.core.network.MediaPubHandler;
	import tetequ.live.core.network.NetworkFacade;
	import tetequ.live.modules.room.avdocument.AVDocumentManager;
	//import tetequ.live.modules.room.stream.common.events.AVPlayInterruptEvent;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class AVStreamCloseHandler implements IMetaActionHandler 
	{
		[Inject]
		public var eventDispatcher:IEventDispatcher;
		
		[Inject]
		public var mediaPubHandler:MediaPubHandler;
		
		[Inject]
		public var mediaPlayHandler:MediaPlayHandler;
		
		[Inject]
		public var networkFacade:NetworkFacade;
		
		public function AVStreamCloseHandler() 
		{
			
		}
		
		/* INTERFACE com.e2et.datalogic.IMetaActionHandler */
		
		public function handleMetaAction(a:MetaAction, isLocal:Boolean):void 
		{
			var action:AVStreamClose = a as AVStreamClose;
			if ( !isLocal )
			{
				action.stream.mp.delHandler( mediaPlayHandler );
				AVDocumentManager.getInstance().mediaPlayInterrupted(action.stream.mp, '远端关闭');
			}else
			{
				action.stream.pc.delHandler( mediaPubHandler );
				AVDocumentManager.getInstance().publishInterrupted(action.stream.pc, '手动关闭');
			}

		}
		
	}

}