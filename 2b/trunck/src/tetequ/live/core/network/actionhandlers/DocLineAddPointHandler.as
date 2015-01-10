package tetequ.live.core.network.actionhandlers 
{
	import com.e2et.datalogic.DocLineAddPoint;
	import com.e2et.datalogic.IMetaActionHandler;
	import com.e2et.datalogic.IMetaActionHandler;
	import com.e2et.datalogic.MetaAction;
	import tetequ.live.modules.room.doc.players.common.CanvasManager;
	import tetequ.live.modules.room.doc.players.common.interfaces.ICanvas;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class DocLineAddPointHandler implements IMetaActionHandler 
	{
		[Inject]
		public var canvasManager:CanvasManager;
		public function DocLineAddPointHandler() 
		{
			
		}
		
		/* INTERFACE com.e2et.datalogic.IMetaActionHandler */
		
		public function handleMetaAction(a:MetaAction, isLocal:Boolean):void 
		{
			var action:DocLineAddPoint = DocLineAddPoint(a);
			if (!isLocal)
			{
				var canvas:ICanvas = canvasManager.getCanvasByDocId(action.docLine.document.id);
				if(canvas)
					canvas.handleDocLineAddPoint(action);
			}
		}
		
	}

}