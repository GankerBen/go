package tetequ.live.core.network 
{
	import com.e2et.datalogic.AVItem;
	import com.e2et.datalogic.AVStream;
	import com.e2et.net.media.video.IPreview;
	import flash.events.IEventDispatcher;
	import flash.media.H264Level;
	import flash.media.H264Profile;
	import flash.media.H264VideoStreamSettings;
	import flash.net.NetStream;
	import com.e2et.net.media.publisher.IMediaPubClient;
	import com.e2et.net.media.publisher.IMediaPubHandler;
	import tetequ.live.modules.room.avdocument.AVDocumentManager;
	//import tetequ.live.modules.room.stream.common.events.AVPreviewEvent;
	//import tetequ.live.modules.room.stream.common.events.AVPublishErrorEvent;
	//import tetequ.live.modules.room.stream.common.events.AVPublishStartingEvent;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class MediaPubHandler implements IMediaPubHandler 
	{
		[Inject]
		public var eventDispatcher:IEventDispatcher;
		
		//private var _pub:IMediaPubHandler = AVDocumentManager.getInstance();
		
		public function MediaPubHandler() 
		{
			
		}
		
		/* INTERFACE com.e2et.net.media.publisher.IMediaPubHandler */
		
		public function publishStarting(mc:IMediaPubClient, stm:NetStream):void 
		{
			//eventDispatcher.dispatchEvent( new AVPublishStartingEvent( mc.avstm ) );
			AVDocumentManager.getInstance().publishStarting(mc, stm);
		}
		
		/**
		 * 音视频发布开始了
		 * @param	mc
		 * @param	stm
		 */
		public function publishStarted(mc:IMediaPubClient, stm:NetStream):void 
		{
			if( mc.avstm.videoCap )
			{
				var s:H264VideoStreamSettings = new H264VideoStreamSettings();
				s.setProfileLevel( H264Profile.MAIN, H264Level.LEVEL_2_1 );
				s.setKeyFrameInterval( 15 );
				mc.avstm.videoCap.videoStreamSettings = s;
				
				//eventDispatcher.dispatchEvent( new AVPreviewEvent( IPreview( mc.avstm.videoCap ), mc.avstm, AVPreviewEvent.START,mc ) );
				
			}else {
				
				//eventDispatcher.dispatchEvent( new AVPreviewEvent( null, mc.avstm, AVPreviewEvent.START,mc ) );
			}
			
			AVDocumentManager.getInstance().publishStarted(mc, stm);
		}
		
		/**
		 * 发布视频中断
		 * 
		 * @param	mc
		 * @param	reason
		 */
		public function publishInterrupted(mc:IMediaPubClient, reason:String):void 
		{
			var avstm:AVStream = mc.avstm;
			avstm.close();
			
			AVDocumentManager.getInstance().publishInterrupted(mc, reason);
			//eventDispatcher.dispatchEvent( new AVPreviewEvent( IPreview( mc.avstm.videoCap ), mc.avstm, AVPreviewEvent.STOP ) );
			//eventDispatcher.dispatchEvent( new AVPublishErrorEvent( mc.avstm, reason, AVPublishErrorEvent.BROKEN ) );
		}
		
		/**
		 * 发布视频失败
		 * @param	mc
		 * @param	reason
		 */
		public function publishFailed(mc:IMediaPubClient, reason:String ):void 
		{
			var avstm:AVStream = mc.avstm;
			avstm.close();
			//eventDispatcher.dispatchEvent( new AVPublishErrorEvent( mc.avstm, reason, AVPublishErrorEvent.FAILED ) );
			AVDocumentManager.getInstance().publishFailed(mc, reason);
		}
		
		public function recordStatus(mc:IMediaPubClient, record:Boolean, file:String, result:Boolean):void 
		{
			AVDocumentManager.getInstance().recordStatus(mc, record, file, result);
		}
		
		public function publishUpdateJitterValue(mc:IMediaPubClient, value:Array, time:int, direction:int):void 
		{
			AVDocumentManager.getInstance().publishUpdateJitterValue(mc, value, time, direction);
		}
		
	}

}