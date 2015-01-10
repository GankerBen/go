package tetequ.live.modules.room.doc.players.common 
{
	import com.e2et.datalogic.Document;
	import tetequ.live.modules.room.doc.players.common.interfaces.ICanvas;
	import tetequ.live.utils.HashMap;
	/**
	 * ...
	 * @author Pandazhong
	 * 存储了与各个Document对应的Canvas
	 */
	public class CanvasManager 
	{
		private var _canvasMapper:HashMap;
		
		public function CanvasManager() 
		{
			_canvasMapper = new HashMap();
		}
		
		public function registerCanvas( doc:Document, canvas:ICanvas ):void
		{
			_canvasMapper.put( doc.id, canvas );
		}
		
		public function getCanvasByDocId( docId:uint ):ICanvas
		{
			return _canvasMapper.getValue( docId );
		}
		
	}

}