package tetequ.live.core.network.actionhandlers 
{
	import com.e2et.datalogic.DocLineStart;
	import com.e2et.datalogic.IMetaActionHandler;
	import com.e2et.datalogic.MetaAction;
	import tetequ.live.modules.room.doc.players.common.CanvasManager;
	import tetequ.live.modules.room.doc.players.common.interfaces.ICanvas;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class DocLineStartHandler implements IMetaActionHandler 
	{
		[Inject]
		public var canvasManager:CanvasManager;
		
		public function DocLineStartHandler() 
		{
			
		}
		
		/* INTERFACE com.e2et.datalogic.IMetaActionHandler */
		
		public function handleMetaAction(a:MetaAction, isLocal:Boolean):void 
		{
			var action:DocLineStart = DocLineStart(a);
			if ( !isLocal )
			{
				var canvas:ICanvas = canvasManager.getCanvasByDocId( action.docLine.document.id );
				if( canvas )
					canvas.handleDocLineStart( action );
			}
		}
		
	}

}