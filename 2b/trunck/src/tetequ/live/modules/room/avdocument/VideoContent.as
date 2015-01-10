package tetequ.live.modules.room.avdocument 
{
	import com.e2et.datalogic.AVStream;
	import com.e2et.net.media.player.IMediaPlayClient;
	import com.e2et.net.media.player.IMediaPlayHandler;
	import com.e2et.net.media.publisher.IMediaPubClient;
	import com.e2et.net.media.publisher.IMediaPubHandler;
	import com.e2et.net.media.video.IPreview;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.media.Video;
	import flash.net.NetStream;
	import org.flexlite.domUI.components.Alert;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.domUI.events.CloseEvent;
	import org.flexlite.domUI.layouts.HorizontalLayout;
	import org.flexlite.domUI.layouts.VerticalAlign;
	import tetequ.live.core.assets.AssetsFactory;
	import tetequ.live.core.network.NetworkFacade;
	import tetequ.live.modules.room.common.GlobalVars;
	//import tetequ.live.modules.room.stream.video.master.event.CloseScreenCaptureEvent;
	import tetequ.live.modules.room.tools.ToolsCache;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class VideoContent extends Group implements IMediaPubHandler, IMediaPlayHandler 
	{
		private var _message:Label;
		private var _video:Video;
		private var _videoWrp:UIAsset;
		private var _btnClose:UIAsset;
		private var _msg:String = '无视频' + (++count);
		private var _logo:UIAsset;
		private var _group:Group;
		private static var count:uint;
		
		public function VideoContent() 
		{
			super();
			initComponents();
		}
		
		private function initComponents():void 
		{
			addElement(_group = new Group());
			_group.layout = new HorizontalLayout();
			_group.horizontalCenter = 0;
			_group.verticalCenter = 0;
			HorizontalLayout(_group.layout).verticalAlign = VerticalAlign.MIDDLE;
			HorizontalLayout(_group.layout).padding = 0;
			HorizontalLayout(_group.layout).gap = 0;
			
			_group.addElement(_logo = new UIAsset());
			_logo.width = _logo.height = 25;
			
			if(GlobalVars.orgLogoUri)
				getLogo(GlobalVars.orgLogoUri, _logo);
			
			_group.addElement(_message = new Label());
			_message.textColor = 0xffffff;
			_message.text = _msg;
			_message.verticalCenter = 0;
			_message.horizontalCenter = 0;

			addElement(_videoWrp = new UIAsset());
			_videoWrp.percentWidth = 100;
			_videoWrp.percentHeight = 100;
			_videoWrp.skinName = _video = new Video(640, 360);
			
			addElement(_btnClose = new UIAsset());
			_btnClose.maintainAspectRatio = true;
			_btnClose.mouseChildren = true;
			_btnClose.skinName = AssetsFactory.getInstance().getAsset("video_close_skin");
			_btnClose.right = 5;
			_btnClose.top  = 5;
			_btnClose.visible = false;
			_btnClose.addEventListener(MouseEvent.CLICK, closeAvstm, false, 100000);
			
			this.percentWidth = 100;
			this.percentHeight = 100;
		}
		
		private var _network:NetworkFacade;
		private var _avstm:AVStream;
		private var _eventDispatcher:IEventDispatcher;
		private function closeAvstm(e:MouseEvent):void 
		{
			e.stopImmediatePropagation();
			if (!_avstm) return;
			if (!_network)
			{
				_network = GlobalVars.networkFacade;
				_eventDispatcher = GlobalVars.eventDispatcher;
			}
			
			var closeMe:Boolean = false;
			
			if (_avstm.user.userid != _network.userId)
			{
				if (_network.hasToken)
				{
					Alert.show('您想要关闭 ' + _avstm.user.name + ' 的发言吗？', '', onClose, '确定', '取消');
				}else
				{
					Alert.show('您没有权限关闭它！');
				}
			}else
			{
				closeMe = true;
				Alert.show('您想要结束发言吗？', '', onClose, '确定', '取消');
			}
			
			function onClose(e:CloseEvent):void
			{
				switch( CloseEvent(e).detail )
				{
					case Alert.FIRST_BUTTON:
						trace('--------------------------关闭一次-------------------------');
						if (closeMe)
						{
							_network.closeAVStream(_avstm.avid);
							//publishInterrupted(_avstm.pc, '手动');
						}else
						{
							_network.sendRPC( _avstm.user, "remoteCloseAVStream", _avstm.avid );
							//_eventDispatcher.dispatchEvent(new CloseScreenCaptureEvent());
							//ToolsCache.userData['av'] = true;
						}
						break;
					case Alert.SECOND_BUTTON:case Alert.CLOSE_BUTTON:
						break;
					default:
						break;
				}
			}
		}
		
		private function disableCloseButton():void
		{
			_btnClose.visible = false;
			removeEventListener(MouseEvent.MOUSE_OVER, showCloseButton);
			removeEventListener(MouseEvent.ROLL_OUT, hideCloseButton);
		}
		
		private function enableCloseButton():void
		{
			addEventListener(MouseEvent.MOUSE_OVER, showCloseButton);
			addEventListener(MouseEvent.ROLL_OUT, hideCloseButton);
		}
		
		/* INTERFACE com.e2et.net.media.publisher.IMediaPubHandler */
			
		public function publishStarting(mc:IMediaPubClient, stm:NetStream):void 
		{
			_message.text = '正在初始化...';
		}
		
		public function publishStarted(mc:IMediaPubClient, stm:NetStream):void 
		{
			_message.text = '发布端摄像头故障';
			IPreview(mc.avstm.videoCap).startPreview(_video);
			_avstm = mc.avstm;
			enableCloseButton();
		}
		
		private function hideCloseButton(e:MouseEvent):void 
		{
			_btnClose.visible = false;
		}
		
		private function showCloseButton(e:MouseEvent):void 
		{
			_btnClose.visible = true;
		}
		
		public function publishInterrupted(mc:IMediaPubClient, reason:String):void 
		{
			_message.text = _msg;
			IPreview(mc.avstm.videoCap).stopPreview(_video);
			_video.attachCamera(null);
			_video.clear();
			_videoWrp.skinName = _video = new Video(640, 360);
			_avstm = null;
			disableCloseButton();
		}
		
		public function publishFailed(mc:IMediaPubClient, reason:String):void 
		{
			_message.text = _msg;
			IPreview(mc.avstm.videoCap).stopPreview(_video);
			_video.attachCamera(null);
			_video.clear();
			_videoWrp.skinName = _video = new Video(640, 360);
			_avstm = null;
			disableCloseButton();
		}
		
		public function recordStatus(mc:IMediaPubClient, record:Boolean, file:String, result:Boolean):void 
		{
			// TODO
		}
		
		public function publishUpdateJitterValue(mc:IMediaPubClient, value:Array, time:int, direction:int):void 
		{
			// TODO
		}
		
		/* INTERFACE com.e2et.net.media.player.IMediaPlayHandler */
		
		public function mediaPlayStarting(mc:IMediaPlayClient):void 
		{
			_message.text = '正在初始化...';
		}
		
		public function mediaPlayStarted(mc:IMediaPlayClient, videoStream:NetStream):void 
		{
			//如果没有画面，则用户会看见这句提示
			_message.text = '发布端摄像头故障';
			_video.attachNetStream(videoStream);
			_avstm = mc.avstm;
			enableCloseButton();
		}
		
		public function mediaPlayInterrupted(mc:IMediaPlayClient, reason:String):void 
		{
			_message.text = _msg;
			_video.attachNetStream(null);
			_video.attachCamera(null);
			_video.clear();
			_videoWrp.skinName = _video = new Video(640, 360);
			_avstm = null;
			disableCloseButton();
		}
		
		public function mediaPlayFailed(mc:IMediaPlayClient, reason:String):void 
		{
			mediaPlayInterrupted(mc, reason);
		}
		
		public function publishStopped(mc:IMediaPlayClient):void 
		{
			mediaPlayInterrupted(mc, null);
		}
		
		public function mediaAVStatusChanged(mc:IMediaPlayClient):void 
		{
			// TODO
		}
		
		public function mediaPlayUpdateJitterValue(mc:IMediaPlayClient, value:Array, time:int, direction:int):void 
		{
			// TODO
		}
		
		public function set network(value:NetworkFacade):void 
		{
			_network = value;
		}
		
	}

}