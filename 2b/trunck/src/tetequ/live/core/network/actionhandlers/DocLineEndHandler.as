package tetequ.live.core.network.actionhandlers 
{
	import com.e2et.datalogic.DocLineEnd;
	import com.e2et.datalogic.IMetaActionHandler;
	import com.e2et.datalogic.MetaAction;
	import tetequ.live.modules.room.doc.players.common.CanvasManager;
	import tetequ.live.modules.room.doc.players.common.interfaces.ICanvas;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class DocLineEndHandler implements IMetaActionHandler 
	{
		[Inject]
		public var canvasManager:CanvasManager;
		public function DocLineEndHandler() 
		{
			
		}
		
		/* INTERFACE com.e2et.datalogic.IMetaActionHandler */
		
		public function handleMetaAction(a:MetaAction, isLocal:Boolean):void 
		{
			var action:DocLineEnd = DocLineEnd(a);
			if (!isLocal)
			{
				var canvas:ICanvas = canvasManager.getCanvasByDocId(action.docLine.document.id);
				if(canvas)
					canvas.handleDocLineEnd(action);
			}
		}
		
	}

}