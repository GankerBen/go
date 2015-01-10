package tetequ.live.core.network 
{
	import com.e2et.datalogic.AVStream;
	import com.e2et.datalogic.RoomConfig;
	import flash.events.IEventDispatcher;
	import flash.media.H264Level;
	import flash.media.H264Profile;
	import flash.media.H264VideoStreamSettings;
	import flash.net.NetStream;
	import com.e2et.net.media.player.IMediaPlayClient;
	import com.e2et.net.media.player.IMediaPlayHandler;
	import org.flexlite.domUI.components.Alert;
	import tetequ.live.modules.room.avdocument.AVDocumentManager;
	//import tetequ.live.modules.room.stream.common.events.AVPlayInterruptEvent;
	//import tetequ.live.modules.room.stream.common.events.AVPlayStartedEvent;
	//import tetequ.live.modules.room.stream.common.events.AVPlayStartingEvent;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class MediaPlayHandler implements IMediaPlayHandler 
	{
		[Inject]
		public var eventDispatcher:IEventDispatcher;
		
		private var _play:IMediaPlayHandler// = AVDocumentManager.getInstance();
		
		public function MediaPlayHandler() 
		{
			
		}
		
		/* INTERFACE com.e2et.net.media.player.IMediaPlayHandler */
		
		public function mediaPlayStarting(mc:IMediaPlayClient):void 
		{
			//eventDispatcher.dispatchEvent( new AVPlayStartingEvent( mc.avstm ) );
			AVDocumentManager.getInstance().mediaPlayStarting(mc);
		}
		
		/**
		 * 发布端停止发布了 
		 */
		public function publishStopped (mc:IMediaPlayClient):void
		{
			//eventDispatcher.dispatchEvent( new AVPlayInterruptEvent( mc.avstm ) );
			AVDocumentManager.getInstance().publishStopped(mc);
		}
		
		/**
		 * 远端发布视频开始了，当前客户端可以播放视频流
		 * @param	mc
		 * @param	videoStream
		 */
		public function mediaPlayStarted(mc:IMediaPlayClient, videoStream:NetStream):void 
		{
			if ( !videoStream ) 
			{
				Alert.show( "mediaPlayStarted错误!因为videoStream为空!" );
				return;
			}

			//eventDispatcher.dispatchEvent( new AVPlayStartedEvent( videoStream, mc.avstm, mc ) );
			AVDocumentManager.getInstance().mediaPlayStarted(mc, videoStream);
		}
		
		/**
		 * 远端视频发布中断
		 * @param	mc
		 * @param	reason
		 */
		public function mediaPlayInterrupted(mc:IMediaPlayClient, reason:String):void 
		{
			 //eventDispatcher.dispatchEvent( new AVPlayInterruptEvent( mc.avstm ) );
			 AVDocumentManager.getInstance().mediaPlayInterrupted(mc, reason);
		}
		
		public function mediaPlayFailed(mc:IMediaPlayClient, reason:String):void 
		{
			//mediaPlayInterrupted( mc, reason );
			AVDocumentManager.getInstance().mediaPlayFailed(mc, reason);
		}
		
		public function mediaAVStatusChanged(mc:IMediaPlayClient):void 
		{
			AVDocumentManager.getInstance().mediaAVStatusChanged(mc);
		}
		
		public function mediaPlayUpdateJitterValue(mc:IMediaPlayClient, value:Array, time:int, direction:int):void 
		{
			AVDocumentManager.getInstance().mediaPlayUpdateJitterValue(mc, value, time, direction);
		}
		
	}

}