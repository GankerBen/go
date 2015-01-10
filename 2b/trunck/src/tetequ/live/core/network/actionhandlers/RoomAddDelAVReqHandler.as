package tetequ.live.core.network.actionhandlers 
{
	import com.e2et.datalogic.IMetaActionHandler;
	import com.e2et.datalogic.MetaAction;
	import com.e2et.datalogic.RoomAddDelAVReq;
	import flash.events.IEventDispatcher;
	import tetequ.live.core.network.NetworkFacade;
	import tetequ.live.modules.room.avreq.events.AddAVReqEvent;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class RoomAddDelAVReqHandler implements IMetaActionHandler 
	{
		[Inject]
		public var eventDispatcher:IEventDispatcher;
		
		[Inject]
		public var networkFacade:NetworkFacade;
		
		public function RoomAddDelAVReqHandler() 
		{
			
		}
		
		/* INTERFACE com.e2et.datalogic.IMetaActionHandler */
		
		public function handleMetaAction(a:MetaAction, isLocal:Boolean):void 
		{
			var action:RoomAddDelAVReq = RoomAddDelAVReq(a);
			
			if ( isLocal )
			{
				if ( !action.room.tokenUser )
				{
					return;
				}
				
				if ( action.room.tokenUser.userid != networkFacade.user.userid )
				{
					return;
				}
				
				if ( action.add )
				{
					eventDispatcher.dispatchEvent( new AddAVReqEvent( action.avReq, AddAVReqEvent.ADD ));
				}else
				{
					eventDispatcher.dispatchEvent( new AddAVReqEvent( action.avReq, AddAVReqEvent.DEL ));
				}
			}else
			{
				trace( '------------------------avreq', isLocal );
			}
		}
		
	}

}