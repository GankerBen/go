package tetequ.live.modules.room.recording.events 
{
	import com.e2et.ISession;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class RecordEvent extends Event 
	{
		public static const STARTED:String = "start";
		public static const STOPED:String = "stop";
		public static const START_FAILED:String = "start-failed";
		
		private var _session:ISession;
		private var _videoId:String;
		
		public function RecordEvent(session:ISession, videoId:String, type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			_session = session;
			_videoId = videoId;
		}
		
		public function get session():ISession 
		{
			return _session;
		}
		
		public function get videoId():String 
		{
			return _videoId;
		}
		
	}

}