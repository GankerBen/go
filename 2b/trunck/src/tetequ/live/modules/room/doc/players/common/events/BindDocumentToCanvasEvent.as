package tetequ.live.modules.room.doc.players.common.events 
{
	import com.e2et.datalogic.Document;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class BindDocumentToCanvasEvent extends Event 
	{
		public static const BIND_DOCUMENT:String = "bind-document";
		private var _doc:Document;
		public function BindDocumentToCanvasEvent(doc:Document, type:String = BIND_DOCUMENT, bubbles:Boolean=false, cancelable:Boolean=false) 
		{
			super(type, bubbles, cancelable);
			_doc = doc;
		}
		
		public function get doc():Document 
		{
			return _doc;
		}
		
	}

}