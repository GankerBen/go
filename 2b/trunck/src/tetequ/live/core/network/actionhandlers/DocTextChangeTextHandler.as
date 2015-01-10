package tetequ.live.core.network.actionhandlers 
{
	import com.e2et.datalogic.DocTextChangeText;
	import com.e2et.datalogic.IMetaActionHandler;
	import com.e2et.datalogic.MetaAction;
	import tetequ.live.modules.room.doc.players.common.CanvasManager;
	import tetequ.live.modules.room.doc.players.common.interfaces.ICanvas;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class DocTextChangeTextHandler implements IMetaActionHandler 
	{
		[Inject]
		public var canvasManager:CanvasManager;
		
		public function DocTextChangeTextHandler() 
		{
			
		}
		
		/* INTERFACE com.e2et.datalogic.IMetaActionHandler */
		
		public function handleMetaAction(a:MetaAction, isLocal:Boolean):void 
		{
			var action:DocTextChangeText = DocTextChangeText(a);
			if ( !isLocal )
			{
				var canvas:ICanvas = canvasManager.getCanvasByDocId(action.room.doc.id);
				if(canvas)
					canvas.handleDocTextChangeText(action);
			}
		}
		
	}

}