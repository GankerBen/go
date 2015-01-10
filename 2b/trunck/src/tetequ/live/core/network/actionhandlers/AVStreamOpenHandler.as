package tetequ.live.core.network.actionhandlers 
{
	import com.e2et.datalogic.AVStream;
	import com.e2et.datalogic.AVStreamOpen;
	import com.e2et.datalogic.IMetaActionHandler;
	import com.e2et.datalogic.MetaAction;
	import tetequ.live.core.network.MediaPlayHandler;
	import tetequ.live.core.network.MediaPubHandler;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class AVStreamOpenHandler implements IMetaActionHandler 
	{
		[Inject]
		public var mediaPubHandler:MediaPubHandler;
		
		[Inject]
		public var mediaPlayHandler:MediaPlayHandler;
		
		public function AVStreamOpenHandler() 
		{
			
		}
		
		/* INTERFACE com.e2et.datalogic.IMetaActionHandler */
		
		public function handleMetaAction(a:MetaAction, isLocal:Boolean):void 
		{
			var action:AVStreamOpen = AVStreamOpen(a);
			if ( isLocal )
			{	
				action.stream.pc.addHandler( mediaPubHandler );
			}else
			{
				action.stream.mp.addHandler( mediaPlayHandler );
			}
		}
		
	}

}