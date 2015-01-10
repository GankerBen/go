package tetequ.live.core.network.actionhandlers 
{
	import com.e2et.datalogic.IMetaActionHandler;
	import com.e2et.datalogic.MetaAction;
	import com.e2et.datalogic.UserUpdateHasMic;
	import flash.events.IEventDispatcher;
	import tetequ.live.modules.room.userlist.events.UserDeviceStatusEvent;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class UserUpdateHasMicHandler implements IMetaActionHandler 
	{
		[Inject]
		public var eventDispatcher:IEventDispatcher;
		
		public function UserUpdateHasMicHandler() 
		{
			
		}
		
		/* INTERFACE com.e2et.datalogic.IMetaActionHandler */
		
		public function handleMetaAction(a:MetaAction, isLocal:Boolean):void 
		{
			if ( !isLocal )
			{
				var action:UserUpdateHasMic = a as UserUpdateHasMic;
				eventDispatcher.dispatchEvent( new UserDeviceStatusEvent( action.user.userid, action.user.hasMic, UserDeviceStatusEvent.MIKE ) );
			}
		}
		
	}

}