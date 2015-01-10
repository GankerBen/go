package tetequ.live.core.network.actionhandlers 
{
	import com.e2et.datalogic.IMetaActionHandler;
	import com.e2et.datalogic.MediaPlaySeek;
	import com.e2et.datalogic.MetaAction;
	import flash.events.IEventDispatcher;
	import tetequ.live.modules.room.doc.players.media.common.events.MediaPlaySeekEvent;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class MediaPlaySeekHandler implements IMetaActionHandler 
	{
		[Inject]
		public var eventDispatcher:IEventDispatcher;
		
		public function MediaPlaySeekHandler() 
		{
			
		}
		
		/* INTERFACE com.e2et.datalogic.IMetaActionHandler */
		
		public function handleMetaAction(a:MetaAction, isLocal:Boolean):void 
		{
			var action:MediaPlaySeek = a as MediaPlaySeek;
			if ( !isLocal )
			{
				var file:String = action.mediaPlayer.file;
				var time:Number = action.time;
				
				eventDispatcher.dispatchEvent( new MediaPlaySeekEvent( file, time ) );
			}
		}
		
	}

}