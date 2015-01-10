package tetequ.live.core.network.actionhandlers 
{
	import com.e2et.datalogic.AVStreamToggleAudio;
	import com.e2et.datalogic.IMetaActionHandler;
	import com.e2et.datalogic.MetaAction;
	import flash.events.IEventDispatcher;
	//import tetequ.live.modules.room.stream.common.events.AVStreamToggleEvent;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class AVStreamToggleAudioHandler implements IMetaActionHandler 
	{
		[Inject]
		public var eventDispatcher:IEventDispatcher;
		
		public function AVStreamToggleAudioHandler() 
		{
			
		}
		
		/* INTERFACE com.e2et.datalogic.IMetaActionHandler */
		
		public function handleMetaAction(a:MetaAction, isLocal:Boolean):void 
		{
			var action:AVStreamToggleAudio = a as AVStreamToggleAudio;
			if ( !isLocal )
			{
				//eventDispatcher.dispatchEvent( new AVStreamToggleEvent( action.stream, AVStreamToggleEvent.AUDIO ) );
			}
		}
		
	}

}