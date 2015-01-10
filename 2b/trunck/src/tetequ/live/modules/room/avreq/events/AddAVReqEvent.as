package tetequ.live.modules.room.avreq.events 
{
	import com.e2et.datalogic.AVReq;
	import com.e2et.datalogic.User;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class AddAVReqEvent extends Event 
	{
		public static const ADD:String = "add";
		public static const DEL:String = "del";
		private var _avReq:AVReq;
		
		public function AddAVReqEvent( avReq:AVReq, type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			_avReq = avReq;
		}
		
		public function get avReq():AVReq 
		{
			return _avReq;
		}
		
	}

}