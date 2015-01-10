package tetequ.live.core.network.actionhandlers 
{
	import com.e2et.datalogic.AVStreamToggleVideo;
	import com.e2et.datalogic.IMetaActionHandler;
	import com.e2et.datalogic.MetaAction;
	import flash.events.IEventDispatcher;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class AVStreamToggleVideoHandler implements IMetaActionHandler 
	{
		[Inject]
		public var eventDispatcher:IEventDispatcher;
		
		public function AVStreamToggleAudioHandler() 
		{
			
		}
		
		/* INTERFACE com.e2et.datalogic.IMetaActionHandler */
		
		public function handleMetaAction(a:MetaAction, isLocal:Boolean):void 
		{
			var action:AVStreamToggleVideo = a as AVStreamToggleVideo;
			if ( !isLocal )
			{
				// TODO
			}
		}
		
	}

}