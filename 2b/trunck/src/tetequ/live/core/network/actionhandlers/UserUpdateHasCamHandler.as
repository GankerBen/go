package tetequ.live.core.network.actionhandlers 
{
	import com.e2et.datalogic.IMetaActionHandler;
	import com.e2et.datalogic.MetaAction;
	import com.e2et.datalogic.UserUpdateHasCam;
	import flash.events.IEventDispatcher;
	import tetequ.live.modules.room.userlist.events.UserDeviceStatusEvent;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class UserUpdateHasCamHandler implements IMetaActionHandler 
	{
		[Inject]
		public var eventDispatcher:IEventDispatcher;
		
		public function UserUpdateHasCamHandler() 
		{
			
		}
		
		/* INTERFACE com.e2et.datalogic.IMetaActionHandler */
		
		public function handleMetaAction(a:MetaAction, isLocal:Boolean):void 
		{
			if ( !isLocal )
			{
				var action:UserUpdateHasCam = a as UserUpdateHasCam;
				eventDispatcher.dispatchEvent( new UserDeviceStatusEvent( action.user.userid, action.user.hasCam, UserDeviceStatusEvent.CAMERA ) );
			}
		}
		
	}

}