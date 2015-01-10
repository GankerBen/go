package tetequ.live.core.network.actionhandlers 
{
	import com.e2et.datalogic.IMetaActionHandler;
	import com.e2et.datalogic.MediaPlayChangeVolume;
	import com.e2et.datalogic.MetaAction;
	import flash.events.IEventDispatcher;
	import tetequ.live.modules.room.doc.players.media.common.events.MediaPlayChangeVolumeEvent;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class MediaPlayChangeVolumeHandler implements IMetaActionHandler 
	{
		[Inject]
		public var eventDispatcher:IEventDispatcher;
		
		public function MediaPlaySeekHandler() 
		{
			
		}
		
		/* INTERFACE com.e2et.datalogic.IMetaActionHandler */
		
		public function handleMetaAction(a:MetaAction, isLocal:Boolean):void 
		{
			var action:MediaPlayChangeVolume = a as MediaPlayChangeVolume;
			if ( !isLocal )
			{
				var file:String = action.mediaPlayer.file;
				var volume:Number = action.volume;
				
				eventDispatcher.dispatchEvent( new MediaPlayChangeVolumeEvent( file, volume ) );
			}
		}
		
	}

}