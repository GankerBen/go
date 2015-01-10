package tetequ.live.core.network.actionhandlers 
{
	import com.e2et.datalogic.IMetaActionHandler;
	import com.e2et.datalogic.MetaAction;
	import com.e2et.datalogic.RoomAddDelAVItem;
	import flash.events.IEventDispatcher;
	import org.flexlite.domUI.components.Alert;
	import org.flexlite.domUI.events.CloseEvent;
	import tetequ.live.core.network.NetworkFacade;
	import tetequ.live.modules.room.common.panel.PanelID;
	import tetequ.live.modules.room.common.panel.PanelManager;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class RoomAddDelAVItemHandler implements IMetaActionHandler 
	{
		[Inject]
		public var panelManager:PanelManager;
		
		[Inject]
		public var eventDispatcher:IEventDispatcher;
		
		[Inject]
		public var networkFacade:NetworkFacade;
		
		public function RoomAddDelAVItemHandler() 
		{
			
		}
		
		/* INTERFACE com.e2et.datalogic.IMetaActionHandler */
		
		public function handleMetaAction(a:MetaAction, isLocal:Boolean):void 
		{
			var action:RoomAddDelAVItem = RoomAddDelAVItem(a);
			if ( !isLocal )
			{
				if ( action.add )
				{
					if ( action.item == null ) return;
					if ( action.item.user == null ) return;
					if ( networkFacade.userId == action.item.user.userid )
					{
						//Alert.show( "主讲 " + action.actor.name + " 邀请您发言", "邀请发言", onClose, "接受", "拒绝"  );
						//function onClose( e:CloseEvent ):void
						//{
							//switch( CloseEvent(e).detail )
							//{
								//case Alert.FIRST_BUTTON:
									//eventDispatcher.dispatchEvent( new AVStreamInvitedPublishEvent() );
									//break;
								//case Alert.SECOND_BUTTON:case Alert.CLOSE_BUTTON:
									//break;
								//default:
									//break;
							//}
						//}
					}
				}else 
				{
					trace( "删除视频" );
				}
			}
		}
	}
}