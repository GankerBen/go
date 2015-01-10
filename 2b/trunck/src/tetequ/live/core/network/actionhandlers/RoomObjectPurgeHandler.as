package tetequ.live.core.network.actionhandlers 
{
	import com.e2et.datalogic.DocLine;
	import com.e2et.datalogic.DocText;
	import com.e2et.datalogic.IMetaActionHandler;
	import com.e2et.datalogic.MetaAction;
	import com.e2et.datalogic.RoomObjectPurge;
	import tetequ.live.modules.room.doc.players.common.CanvasManager;
	import tetequ.live.modules.room.doc.players.common.interfaces.ICanvas;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class RoomObjectPurgeHandler implements IMetaActionHandler 
	{
		[Inject]
		public var canvasManager:CanvasManager;
		
		public function RoomObjectPurgeHandler() 
		{
			
		}
		
		/* INTERFACE com.e2et.datalogic.IMetaActionHandler */
		
		public function handleMetaAction(a:MetaAction, isLocal:Boolean):void 
		{
			var action:RoomObjectPurge = RoomObjectPurge(a);
			if ( !isLocal )
			{
				switch(action.subject['constructor'])
				{
					case DocLine:
						var canvas:ICanvas = canvasManager.getCanvasByDocId(action.room.doc.id);
						canvas.handlePurgeDocLine( DocLine(action.subject) );
						break;
					case DocText:
						canvas = canvasManager.getCanvasByDocId(action.room.doc.id);
						canvas.handlePurgeDocText( DocText(action.subject) );
						break;
					default:
						break;
				}
			}
		}
		
	}

}