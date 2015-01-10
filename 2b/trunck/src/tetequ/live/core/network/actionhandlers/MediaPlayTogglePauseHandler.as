package tetequ.live.core.network.actionhandlers 
{
	import com.e2et.datalogic.IMetaActionHandler;
	import com.e2et.datalogic.MediaPlayTogglePause;
	import com.e2et.datalogic.MetaAction;
	import flash.events.IEventDispatcher;
	import tetequ.live.modules.room.doc.players.media.common.events.MediaPlayTogglePauseEvent;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class MediaPlayTogglePauseHandler implements IMetaActionHandler 
	{
		[Inject]
		public var eventDispatcher:IEventDispatcher;
		
		public function MediaPlaySeekHandler() 
		{
			
		}
		
		/* INTERFACE com.e2et.datalogic.IMetaActionHandler */
		
		public function handleMetaAction(a:MetaAction, isLocal:Boolean):void 
		{
			var action:MediaPlayTogglePause = a as MediaPlayTogglePause;
			if ( !isLocal )
			{
				var file:String = action.mediaPlayer.file;
				var paused:Boolean = action.mediaPlayer.paused;
				
				eventDispatcher.dispatchEvent( new MediaPlayTogglePauseEvent( file, paused ) );
			}
		}
		
	}

}