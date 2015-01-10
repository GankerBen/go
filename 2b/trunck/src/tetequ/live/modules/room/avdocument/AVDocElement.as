package tetequ.live.modules.room.avdocument 
{
	import com.e2et.net.media.player.IMediaPlayClient;
	import com.e2et.net.media.player.IMediaPlayHandler;
	import com.e2et.net.media.publisher.IMediaPubClient;
	import com.e2et.net.media.publisher.IMediaPubHandler;
	import flash.events.MouseEvent;
	import flash.net.NetStream;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.components.Rect;
	import org.flexlite.domUI.core.UIComponent;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class AVDocElement extends Group implements IMediaPlayHandler, IMediaPubHandler 
	{
		
		//内容可能是视频(video)、文档(各种player)
		private var _content:UIComponent;
		private var _back:Rect;
		
		//防止内容超出区域
		private var _backMask:Rect;
				
		public function AVDocElement() 
		{
			super();
			initComponents();
		}
		
		private function initComponents():void 
		{
			this.percentWidth = 100;
			this.percentHeight = 100;
			
			addElement(_back = new Rect());
			_back.fillColor = 0x000000;
			_back.percentWidth = 100;
			_back.percentHeight = 100;
			
			addElement(_backMask = new Rect());
			_backMask.fillColor = 0x000000;
			_backMask.percentWidth = 100;
			_backMask.percentHeight = 100;
			
			//测试用
			//var dummyContent:Label = new Label();
			//dummyContent.textColor = 0xffffff;
			//dummyContent.text = Math.random().toString().substring(0, 5);
			//dummyContent.horizontalCenter = 0;
			//dummyContent.verticalCenter = 0;
			//this.content = dummyContent;
		}
		
		public function get content():UIComponent 
		{
			return _content;
		}
		
		public function set content(value:UIComponent):void 
		{
			if (_content == value) return;
			addElement(_content = value);
			_content.mask = _backMask;
		}
		
		/* INTERFACE com.e2et.net.media.publisher.IMediaPubHandler */
			
		public function publishStarting(mc:IMediaPubClient, stm:NetStream):void 
		{
			var content:IMediaPubHandler = _content as IMediaPubHandler;
			if (content)
			{
				content.publishStarting(mc, stm);
			}else
			{
				throw new Error('content没有下实现IMediaPubHandler接口！因为它是 '+_content['constructor']);
			}
		}
		
		public function publishStarted(mc:IMediaPubClient, stm:NetStream):void 
		{
			var content:IMediaPubHandler = _content as IMediaPubHandler;
			if (content)
			{
				content.publishStarted(mc, stm);
			}else
			{
				throw new Error('content没有下实现IMediaPubHandler接口！因为它是 '+_content['constructor']);
			}
		}
		
		public function publishInterrupted(mc:IMediaPubClient, reason:String):void 
		{
			var content:IMediaPubHandler = _content as IMediaPubHandler;
			if (content)
			{
				content.publishInterrupted(mc, reason);
			}else
			{
				throw new Error('content没有下实现IMediaPubHandler接口！因为它是 '+_content['constructor']);
			}
		}
		
		public function publishFailed(mc:IMediaPubClient, reason:String):void 
		{
			var content:IMediaPubHandler = _content as IMediaPubHandler;
			if (content)
			{
				content.publishFailed(mc, reason);
			}else
			{
				throw new Error('content没有下实现IMediaPubHandler接口！因为它是 '+_content['constructor']);
			}
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
			var content:IMediaPlayHandler = _content as IMediaPlayHandler;
			if (content)
			{
				content.mediaPlayStarting(mc);
			}else
			{
				throw new Error('content没有下实现IMediaPlayHandler接口！因为它是 '+_content['constructor']);
			}
		}
		
		public function mediaPlayStarted(mc:IMediaPlayClient, videoStream:NetStream):void 
		{
			var content:IMediaPlayHandler = _content as IMediaPlayHandler;
			if (content)
			{
				content.mediaPlayStarted(mc, videoStream);
			}else
			{
				throw new Error('content没有下实现IMediaPlayHandler接口！因为它是 '+_content['constructor']);
			}
		}
		
		public function mediaPlayInterrupted(mc:IMediaPlayClient, reason:String):void 
		{
			var content:IMediaPlayHandler = _content as IMediaPlayHandler;
			if (content)
			{
				content.mediaPlayInterrupted(mc, reason);
			}else
			{
				throw new Error('content没有下实现IMediaPlayHandler接口！因为它是 '+_content['constructor']);
			}
		}
		
		public function mediaPlayFailed(mc:IMediaPlayClient, reason:String):void 
		{
			var content:IMediaPlayHandler = _content as IMediaPlayHandler;
			if (content)
			{
				content.mediaPlayFailed(mc, reason);
			}else
			{
				throw new Error('content没有下实现IMediaPlayHandler接口！因为它是 '+_content['constructor']);
			}
		}
		
		public function publishStopped(mc:IMediaPlayClient):void 
		{
			var content:IMediaPlayHandler = _content as IMediaPlayHandler;
			if (content)
			{
				content.publishStopped(mc);
			}else
			{
				throw new Error('content没有下实现IMediaPlayHandler接口！因为它是 '+_content['constructor']);
			}
		}
		
		public function mediaAVStatusChanged(mc:IMediaPlayClient):void 
		{
			// TODO
		}
		
		public function mediaPlayUpdateJitterValue(mc:IMediaPlayClient, value:Array, time:int, direction:int):void 
		{
			// TODO
		}
		
	}

}