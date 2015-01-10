package tetequ.live.modules.room.userlist.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 用户设备(摄像头、麦克风等)状态发生改变时派发
	 */
	public class UserDeviceStatusEvent extends Event 
	{
		public static const MIKE:String = "mike";
		public static const CAMERA:String = "camera";
		private var _has:Boolean;
		private var _userId:String;
		
		public function UserDeviceStatusEvent( userId:String, has:Boolean, type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			_userId = userId;
			_has = has;
		}
		
		public function get has():Boolean 
		{
			return _has;
		}
		
		public function get userId():String 
		{
			return _userId;
		}
		
	}

}