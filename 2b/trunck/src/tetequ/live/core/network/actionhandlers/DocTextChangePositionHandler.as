package tetequ.live.core.network.actionhandlers 
{
	import com.e2et.datalogic.DocTextChangePosition;
	import com.e2et.datalogic.IMetaActionHandler;
	import com.e2et.datalogic.MetaAction;
	import tetequ.live.modules.room.doc.players.common.CanvasManager;
	import tetequ.live.modules.room.doc.players.common.interfaces.ICanvas;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class DocTextChangePositionHandler implements IMetaActionHandler 
	{
		[Inject]
		public var canvasManager:CanvasManager;
		public function DocTextChangePositionHandler() 
		{
			
		}
		
		/* INTERFACE com.e2et.datalogic.IMetaActionHandler */
		
		public function handleMetaAction(a:MetaAction, isLocal:Boolean):void 
		{
			var action:DocTextChangePosition = DocTextChangePosition(a);
			if ( !isLocal )
			{
				var canvas:ICanvas = canvasManager.getCanvasByDocId(action.room.doc.id);
				if( canvas )
					canvas.handleDocTextChangePosition(action);
			}
		}
		
	}

}