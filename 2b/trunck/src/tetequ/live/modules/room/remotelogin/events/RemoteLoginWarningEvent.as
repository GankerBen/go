package tetequ.live.modules.room.remotelogin.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class RemoteLoginWarningEvent extends Event 
	{
		public static const REMOTE_WARNING:String = "remote-warning";
		public function RemoteLoginWarningEvent(type:String = REMOTE_WARNING, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			
		}
		
	}

}