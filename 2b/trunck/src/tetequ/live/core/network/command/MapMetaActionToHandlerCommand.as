package tetequ.live.core.network.command 
{
	import com.e2et.datalogic.AVStreamChangeState;
	import com.e2et.datalogic.AVStreamClose;
	import com.e2et.datalogic.AVStreamOpen;
	import com.e2et.datalogic.AVStreamToggleAudio;
	import com.e2et.datalogic.AVStreamToggleVideo;
	import com.e2et.datalogic.DocClose;
	import com.e2et.datalogic.DocLineAddPoint;
	import com.e2et.datalogic.DocLineEnd;
	import com.e2et.datalogic.DocLineStart;
	import com.e2et.datalogic.DocOpen;
	import com.e2et.datalogic.DocPageGoto;
	import com.e2et.datalogic.DocSetPageCount;
	import com.e2et.datalogic.DocTextChangePosition;
	import com.e2et.datalogic.DocTextChangeText;
	import com.e2et.datalogic.MediaPlayChangeVolume;
	import com.e2et.datalogic.MediaPlayClose;
	import com.e2et.datalogic.MediaPlayOpen;
	import com.e2et.datalogic.MediaPlaySeek;
	import com.e2et.datalogic.MediaPlayTogglePause;
	import com.e2et.datalogic.RoomAddDelAVItem;
	import com.e2et.datalogic.RoomAddDelAVReq;
	import com.e2et.datalogic.RoomChangeConfig;
	import com.e2et.datalogic.RoomObjectPurge;
	import com.e2et.datalogic.UserChangeLevel;
	import com.e2et.datalogic.UserUpdateHasCam;
	import com.e2et.datalogic.UserUpdateHasMic;
	import robotlegs.bender.bundles.mvcs.Command;
	import robotlegs.bender.framework.api.IInjector;
	import tetequ.live.core.network.actionhandlers.AVStreamChangeStateHandler;
	import tetequ.live.core.network.actionhandlers.AVStreamCloseHandler;
	import tetequ.live.core.network.actionhandlers.AVStreamOpenHandler;
	import tetequ.live.core.network.actionhandlers.AVStreamToggleAudioHandler;
	import tetequ.live.core.network.actionhandlers.AVStreamToggleVideoHandler;
	import tetequ.live.core.network.actionhandlers.DocCloseHandler;
	import tetequ.live.core.network.actionhandlers.DocLineAddPointHandler;
	import tetequ.live.core.network.actionhandlers.DocLineEndHandler;
	import tetequ.live.core.network.actionhandlers.DocLineStartHandler;
	import tetequ.live.core.network.actionhandlers.DocOpenHandler;
	import tetequ.live.core.network.actionhandlers.DocPageGotoHandler;
	import tetequ.live.core.network.actionhandlers.DocSetPageCountHandler;
	import tetequ.live.core.network.actionhandlers.DocTextChangePositionHandler;
	import tetequ.live.core.network.actionhandlers.DocTextChangeTextHandler;
	import tetequ.live.core.network.actionhandlers.MediaPlayChangeVolumeHandler;
	import tetequ.live.core.network.actionhandlers.MediaPlayCloseHandler;
	import tetequ.live.core.network.actionhandlers.MediaPlayOpenHandler;
	import tetequ.live.core.network.actionhandlers.MediaPlaySeekHandler;
	import tetequ.live.core.network.actionhandlers.MediaPlayTogglePauseHandler;
	import tetequ.live.core.network.actionhandlers.RoomAddDelAVItemHandler;
	import tetequ.live.core.network.actionhandlers.RoomAddDelAVReqHandler;
	import tetequ.live.core.network.actionhandlers.RoomChangeConfigHandler;
	import tetequ.live.core.network.actionhandlers.RoomObjectPurgeHandler;
	import tetequ.live.core.network.actionhandlers.UserChangeLevelHandler;
	import tetequ.live.core.network.actionhandlers.UserUpdateHasCamHandler;
	import tetequ.live.core.network.actionhandlers.UserUpdateHasMicHandler;
	import tetequ.live.core.network.MetaActionHandlerMapper;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 将action映射到handler
	 */
	public class MapMetaActionToHandlerCommand extends Command 
	{
		[Inject]
		public var mapper:MetaActionHandlerMapper;
		
		[Inject]
		public var injector:IInjector;
		
		public function MapMetaActionToHandlerCommand() 
		{
			super();
			
		}
		
		override public function execute():void
		{
			mapper.map( DocOpen, injector.getInstance( DocOpenHandler ) as DocOpenHandler );
			mapper.map( DocSetPageCount, injector.getInstance( DocSetPageCountHandler ) as DocSetPageCountHandler );
			mapper.map( DocPageGoto, injector.getInstance( DocPageGotoHandler ) as DocPageGotoHandler );
			mapper.map( DocClose, injector.getInstance( DocCloseHandler ) as DocCloseHandler );
			
			mapper.map( AVStreamClose, injector.getInstance( AVStreamCloseHandler ) as AVStreamCloseHandler );
			mapper.map( AVStreamOpen, injector.getInstance( AVStreamOpenHandler ) as AVStreamOpenHandler );
			mapper.map( AVStreamToggleAudio, injector.getInstance( AVStreamToggleAudioHandler ) as AVStreamToggleAudioHandler );
			mapper.map( AVStreamToggleVideo, injector.getInstance( AVStreamToggleVideoHandler ) as AVStreamToggleVideoHandler );
			mapper.map( AVStreamChangeState, injector.getInstance( AVStreamChangeStateHandler ) as AVStreamChangeStateHandler );
			
			mapper.map( UserChangeLevel, injector.getInstance( UserChangeLevelHandler ) as UserChangeLevelHandler );
			mapper.map( UserUpdateHasCam, injector.getInstance( UserUpdateHasCamHandler ) as UserUpdateHasCamHandler );
			mapper.map( UserUpdateHasMic, injector.getInstance( UserUpdateHasMicHandler ) as UserUpdateHasMicHandler );
			
			mapper.map( MediaPlayOpen, injector.getInstance( MediaPlayOpenHandler ) as MediaPlayOpenHandler );
			mapper.map( MediaPlayClose, injector.getInstance( MediaPlayCloseHandler ) as MediaPlayCloseHandler );
			mapper.map( MediaPlayChangeVolume, injector.getInstance( MediaPlayChangeVolumeHandler ) as MediaPlayChangeVolumeHandler );
			mapper.map( MediaPlayTogglePause, injector.getInstance( MediaPlayTogglePauseHandler ) as MediaPlayTogglePauseHandler );
			mapper.map( MediaPlaySeek, injector.getInstance( MediaPlaySeekHandler ) as MediaPlaySeekHandler );
			
			mapper.map( RoomAddDelAVItem, injector.getInstance( RoomAddDelAVItemHandler ) as RoomAddDelAVItemHandler );
			mapper.map( RoomAddDelAVReq, injector.getInstance( RoomAddDelAVReqHandler ) as RoomAddDelAVReqHandler );
			
			mapper.map( DocLineStart, injector.getInstance( DocLineStartHandler ) as DocLineStartHandler );
			mapper.map( DocLineEnd, injector.getInstance( DocLineEndHandler ) as DocLineEndHandler );
			mapper.map( DocLineAddPoint, injector.getInstance( DocLineAddPointHandler ) as DocLineAddPointHandler );
			mapper.map( DocTextChangePosition, injector.getInstance( DocTextChangePositionHandler ) as DocTextChangePositionHandler );
			mapper.map( DocTextChangeText, injector.getInstance( DocTextChangeTextHandler ) as DocTextChangeTextHandler );
			mapper.map( RoomObjectPurge, injector.getInstance( RoomObjectPurgeHandler ) as RoomObjectPurgeHandler );
			mapper.map( RoomChangeConfig, injector.getInstance( RoomChangeConfigHandler ) as RoomChangeConfigHandler );
		}
		
	}

}