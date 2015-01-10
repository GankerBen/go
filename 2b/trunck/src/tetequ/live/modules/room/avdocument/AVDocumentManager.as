package tetequ.live.modules.room.avdocument 
{
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.net.NetStream;
	import com.e2et.net.media.publisher.IMediaPubClient;
	import flash.net.NetStream;
	import com.e2et.net.media.player.IMediaPlayClient;
	import com.e2et.net.media.player.IMediaPlayHandler;
	import com.e2et.net.media.publisher.IMediaPubHandler;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.core.UIComponent;
	import org.flexlite.domUI.layouts.HorizontalAlign;
	import org.flexlite.domUI.layouts.HorizontalLayout;
	import org.flexlite.domUI.layouts.VerticalAlign;
	import org.flexlite.domUI.layouts.VerticalLayout;
	import tetequ.live.modules.room.common.GlobalVars;
	import tetequ.live.utils.HashMap;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 负责视频、文档布局、切换等
	 */
	public class AVDocumentManager extends Group implements IMediaPlayHandler, IMediaPubHandler 
	{
		
		public function AVDocumentManager(single:SingletonEnforcer) 
		{
			super();
			if (!single)
				throw new Error('please call getInstance!');
			initComponents();
		}
		
		private static var instance:AVDocumentManager;
		public static function getInstance():AVDocumentManager
		{
			return instance = instance || new AVDocumentManager(new SingletonEnforcer());
		}
		
		public static const VIDEO_LIST_MAP:String = 'video-list-map';
		
		//主区域，显示放大的内容
		private var _mainGroup:Group;
		
		//子区域，包含四个小预览区
		private var _subGroup:Group;
		private var _subWidth:int = 160;
		private var _subHeight:int = 90;
		
		//滤镜
		private static const FILTERS:Array = [new DropShadowFilter(0, 0, 0x00ff00, 1, 8, 8, 5)];
		
		//有序的element
		private var _elementsList:Vector.<AVDocElement>;
		
		private function initComponents():void 
		{
			this.percentWidth = 100;
			this.percentHeight = 100;
			this.layout = new HorizontalLayout();
			HorizontalLayout(this.layout).paddingLeft = 0;
			HorizontalLayout(this.layout).paddingRight = 0;
			HorizontalLayout(this.layout).gap = 5;
			
			addElement(_subGroup = new Group());
			addElement(_mainGroup = new Group());
			
			_mainGroup.percentWidth = 100;
			_mainGroup.percentHeight = 100;
			
			_subGroup.width = _subWidth;//缩略区宽度
			_subGroup.percentHeight = 100;
			_subGroup.layout = new VerticalLayout();

			VerticalLayout(_subGroup.layout).paddingTop = 10;
			VerticalLayout(_subGroup.layout).paddingBottom = 0;
			VerticalLayout(_subGroup.layout).gap = 5;
			
			//左边缩略图的数量为最大路数的视频数量，该数量由机构定制
			_elementsList = new Vector.<AVDocElement>(GlobalVars.max_av_num + 1, true);
			
			//初始化缩略图区域
			var sub:AVDocElement;
			var content:UIComponent;
			for (var i:int = 0, len:int = GlobalVars.max_av_num; i != len; ++i)
			{
				sub = new AVDocElement();
				sub.percentHeight = NaN;
				sub.height = _subHeight;
				sub.id = 'sub' + i + 1;
				addMouseListener(sub);
				
				_subGroup.addElement(sub);
				_elementsList[i + 1] = sub;
				_elementsMap.put(sub.id, sub);
				
				content = new VideoContent();
				content.id = sub.id;
				sub.content = content;
				
				_idleVideoContents.push(content);
				_contentsMap.put(content.id, content);
			}

			//初始化主区域
			sub = new AVDocElement();
			sub.id = 'main';//主区域不可点
			_mainGroup.addElement(sub);
			
			_elementsList[0] = sub;
			_elementsMap.put(sub.id, sub);
			
			//默认是显示文档的
			content = new DocContent();
			content.id = 'main';
			sub.content = content;
			_contentsMap.put(content.id, content);
			
			sub = null;
			content = null;
			
			//主讲改变了房间的视频布局配置，后进房间的用户可以根据该配置获取到最新的视频布局信息
			if (roomConfig()[VIDEO_LIST_MAP] != undefined)
			{
				videoListMapChanged(roomConfig()[VIDEO_LIST_MAP]);
			}
		}
		
		private var _elementsMap:HashMap = new HashMap;
		private var _contentsMap:HashMap = new HashMap;
		
		/**
		 * 确定打开的文档显示在哪个区域
		 */
		public function whenDocumentOpened(document:UIComponent):void
		{
			//找到当前是哪个element拥有的content是DocContent类型
			for (var i:int = 0, len:int = _elementsList.length; i != len; ++i )
			{
				var element:AVDocElement = _elementsList[i];
				var content:UIComponent = element.content;
				if (content is DocContent)
				{
					if(!Group(content).containsElement(document))
						Group(content).addElement(document);
					return;
				}
			}
		}

		private function addMouseListener(sub:AVDocElement):void
		{
			sub.addEventListener(MouseEvent.CLICK, switchContent);
			sub.addEventListener(MouseEvent.MOUSE_OVER, showBorder);
			sub.addEventListener(MouseEvent.MOUSE_OUT, hideBorder);
		}
		
		/**
		 * 隐藏滤镜
		 * @param	e
		 */
		private function hideBorder(e:MouseEvent):void 
		{
			var element:AVDocElement = e.currentTarget as AVDocElement;
			element.filters = [];
		}
		
		/**
		 * 显示滤镜
		 * @param	e
		 */
		private function showBorder(e:MouseEvent):void 
		{
			var element:AVDocElement = e.currentTarget as AVDocElement;
			element.filters = FILTERS;
		}

		/**
		 * 点击预览区域与主区域交换内容
		 * 预览区域的内容本身不可点击
		 * @param	sub
		 */
		private function switchContent(e:MouseEvent):void 
		{
			var clickElement:AVDocElement = AVDocElement(e.currentTarget);
			var clickContent:UIComponent = clickElement.content;
			var mainElement:AVDocElement = AVDocElement(_mainGroup.getElementAt(0));
			var mainContent:UIComponent = mainElement.content;
			
			mainElement.content = clickContent;
			clickElement.content = mainContent;
			
			clickContent.mouseChildren = true;
			clickContent.mouseEnabled = true;
			
			if(mainContent is DocContent)
			{
				//文档缩小后不可点击
				mainContent.mouseChildren = false;
				mainContent.mouseEnabled = false;
			}
			
			//如果是老师在切换，同步切换结果，否则不继续处理
			if (!GlobalVars.networkFacade.hasToken)
			{
				return;
			}
			
			var result:Object = { };
			for each(var element:AVDocElement in _elementsList)
			{
				result[element.id] = element.content.id;
				trace('对应关系', element.id, element.content.id);
			}
			
			GlobalVars.networkFacade.session.room.config[VIDEO_LIST_MAP] = result;
		}
		
		/**
		 * 视频、文档切换导致排列顺序改变了
		 * @param	result
		 */
		public function videoListMapChanged(result:Object):void
		{
			for (var elementId:String in result)
			{
				var contentId:String = result[elementId];
				var element:AVDocElement = _elementsMap.getValue(elementId);
				var content:UIComponent = _contentsMap.getValue(contentId);
				element.content = content;
			}
		}
		
		/**
		 * 指定id的视频流将在对应的content上面显示
		 * @param	videoID
		 * @param	contentID
		 */
		public function videoAttachContent(videoID:String, contentID:String):void
		{
			var content:VideoContent = _videoContentsMap.getValue(videoID);
			
			if (content)
			{
				if (content.id == contentID)
				{
					trace('主讲已经修改，当前用户不需要再次更新，因为是他委托主讲修改该房间状态的。', videoID, contentID);
					return;
				}
			}
			
			for (var i:int = 0, len:int = _idleVideoContents.length; i != len; ++i)
			{
				var content:VideoContent = _idleVideoContents[i];
				if (content.id == contentID)
				{
					_videoContentsMap.put(videoID, content);
					_idleVideoContents.splice(i, 1);
					break;
				}
			}
		}
		
		/**
		 * 更新视频数量
		 */
		private function updateAVLength():void
		{
			GlobalVars.avnum = GlobalVars.max_av_num - _idleVideoContents.length;
		}

		private var _videoContentMap:HashMap = new HashMap;

		//尚未用来显示视频的video content
		private var _idleVideoContents:Vector.<VideoContent> = new Vector.<VideoContent>;
		
		//正在显示视频的一组video
		private var _videoContentsMap:HashMap = new HashMap;
		
		/* INTERFACE com.e2et.net.media.publisher.IMediaPubHandler */
			
		public function publishStarting(mc:IMediaPubClient, stm:NetStream):void 
		{
			var id:String = mc.avstm.info['id'];
			var content:IMediaPubHandler = _videoContentsMap.getValue(id);
			
			if (!content)
			{
				_videoContentsMap.put(id, content = _idleVideoContents.shift());
				
				updateAVLength();
				
				/* 各个客户端的视频显示顺序需要一致，这个时候把老师端的顺序同步到其他客户端 */
				if(hasToken())
				{
					roomConfig()['vcmap%' + id] = UIComponent(content).id;
				}else
				{
					//如果是学生在发言，则需要委托老师来同步这个视频顺序了
					if (!tokenUser())
					{
						browserLog('房间没有主讲，当前打开视频的操作不能同步给其他客户端！这会导致各个客户端的视频列表顺序不一致。');
					}else
					{
						browserLog('委托主讲 ' + tokenUser().name + ' 同步房间的视频列表顺序！');
						var key:String = 'vcmap%' + id;
						var value:String = UIComponent(content).id;
						var map:Object = { };
						map[key] = value;
						trace('委托主讲 ' + tokenUser().name + ' 同步房间的视频列表顺序！', key, value);
						GlobalVars.networkFacade.sendRPC(tokenUser(), 'setRoomConfig', map);
					}
				}
			}
			
			if (content)
			{
				content.publishStarting(mc, stm);
			}
			else
				throw new Error('没有可用的video element了！');
		}
		
		public function publishStarted(mc:IMediaPubClient, stm:NetStream):void 
		{
			var id:String = mc.avstm.info['id'];
			var content:IMediaPubHandler = _videoContentsMap.getValue(id);
			
			if (!content)
			{
				throw new Error('找不到与 '+ id +' 对应的VideoContent');
			}else
			{
				content.publishStarted(mc, stm);
			}
		}
		
		public function publishInterrupted(mc:IMediaPubClient, reason:String):void 
		{
			if (!mc) return;
			var id:String = mc.avstm.info['id'];
			var content:IMediaPubHandler = _videoContentsMap.getValue(id);
			trace('--------------------media publish interrupted----------------------', id);
			if (!content)
			{
				return;
			}else
			{
				content.publishInterrupted(mc, reason);
				_videoContentsMap.remove(id);
				_idleVideoContents.push(content);
				
				updateAVLength();
			}
			
			DeviceSettingManager.getInstance().resetDevices(id);
		}
		
		public function publishFailed(mc:IMediaPubClient, reason:String):void 
		{
			if (!mc) return;
			var id:String = mc.avstm.info['id'];
			var content:IMediaPubHandler = _videoContentsMap.getValue(id);
			trace('--------------------media publish failed----------------------', id);
			if (!content)
			{
				return;
			}else
			{
				content.publishFailed(mc, reason);
				_videoContentsMap.remove(id);
				_idleVideoContents.push(content);
				
				updateAVLength();
			}
			
			DeviceSettingManager.getInstance().resetDevices(id);
		}
		
		public function recordStatus(mc:IMediaPubClient, record:Boolean, file:String, result:Boolean):void 
		{
			var id:String = mc.avstm.info['id'];
			var content:IMediaPubHandler = _videoContentsMap.getValue(id);
			
			if (!content)
			{
				throw new Error('找不到与 '+ id +' 对应的VideoContent');
			}else
			{
				content.recordStatus(mc, record, file, result);
			}
		}
		
		public function publishUpdateJitterValue(mc:IMediaPubClient, value:Array, time:int, direction:int):void 
		{
			var id:String = mc.avstm.info['id'];
			var content:IMediaPubHandler = _videoContentsMap.getValue(id);
			
			if (!content)
			{
				throw new Error('找不到与 '+ id +' 对应的VideoContent');
			}else
			{
				content.publishUpdateJitterValue(mc, value, time, direction);
			}
		}
		
		/* INTERFACE com.e2et.net.media.player.IMediaPlayHandler */
	
		public function mediaPlayStarting(mc:IMediaPlayClient):void 
		{
			var id:String = mc.avstm.info['id'];
			trace('--------------------media play starting----------------------', id);
			
			//对于后进房间的用户，需要首先查询房间中是否有某一个正在发布的视频已经配置了与特定content的对应关系
			if (roomConfig()["vcmap%" + id] != undefined)
			{
				videoAttachContent(id, roomConfig()["vcmap%" + id]);
			}
			
			var content:IMediaPlayHandler = _videoContentsMap.getValue(id);
			
			if (content)
			{
				content.mediaPlayStarting(mc);
			}else
			{
				//程序执行到此处，很可能是因为主讲已经不在房间，导致视频发布方委托主讲修改房间video id 与 content id
				//对应关系失败
				//发布方可能没有权限修改房间状态，于是RoomConfig中并不存在以"vcmap%" + id为键的数据
				//目前采用如下方式进行处理，这可能会导致视频显示列表在各个客户端顺序不一致，
				//但不会影响正常发言。
				_videoContentsMap.put(id, content = _idleVideoContents.shift());
				updateAVLength();
			}
		}
		
		public function mediaPlayStarted(mc:IMediaPlayClient, videoStream:NetStream):void 
		{
			var id:String = mc.avstm.info['id'];
			trace('--------------------media play started----------------------', id);
			var content:IMediaPlayHandler = _videoContentsMap.getValue(id);
			
			if (!content)
			{
				throw new Error('找不到与 '+ id +' 对应的VideoContent');
			}else
			{
				content.mediaPlayStarted(mc, videoStream);
			}
		}
		
		public function mediaPlayInterrupted(mc:IMediaPlayClient, reason:String):void 
		{
			if (!mc) return;
			var id:String = mc.avstm.info['id'];
			trace('--------------------media play interrupted----------------------', id);
			var content:IMediaPlayHandler = _videoContentsMap.getValue(id);
			
			if (!content)
			{
				return;
			}else
			{
				content.mediaPlayInterrupted(mc, reason);
				_videoContentsMap.remove(id);
				_idleVideoContents.push(content);
				
				updateAVLength();
			}
			
			DeviceSettingManager.getInstance().resetDevices(id);
		}
		
		public function mediaPlayFailed(mc:IMediaPlayClient, reason:String):void 
		{
			if (!mc) return;
			var id:String = mc.avstm.info['id'];
			trace('--------------------media play failed----------------------', id);
			var content:IMediaPlayHandler = _videoContentsMap.getValue(id);
			
			if (!content)
			{
				return;
			}else
			{
				content.mediaPlayFailed(mc, reason);
				_videoContentsMap.remove(id);
				_idleVideoContents.push(content);
				
				updateAVLength();
			}
			
			DeviceSettingManager.getInstance().resetDevices(id);
		}
		
		public function publishStopped(mc:IMediaPlayClient):void 
		{
			if (!mc) return;
			var id:String = mc.avstm.info['id'];
			trace('--------------------远端停止发布----------------------', id);
			var content:IMediaPlayHandler = _videoContentsMap.getValue(id);
			
			if (!content)
			{
				return;
			}else
			{
				content.publishStopped(mc);
				_videoContentsMap.remove(id);
				_idleVideoContents.push(content);
				
				updateAVLength();
			}
			
			DeviceSettingManager.getInstance().resetDevices(id);
		}
		
		public function mediaAVStatusChanged(mc:IMediaPlayClient):void 
		{
			var id:String = mc.avstm.info['id'];
			var content:IMediaPlayHandler = _videoContentsMap.getValue(id);
			
			if (!content)
			{
				throw new Error('找不到与 '+ id +' 对应的VideoContent');
			}else
			{
				content.mediaAVStatusChanged(mc);
			}
		}
		
		public function mediaPlayUpdateJitterValue(mc:IMediaPlayClient, value:Array, time:int, direction:int):void 
		{
			var id:String = mc.avstm.info['id'];
			var content:IMediaPlayHandler = _videoContentsMap.getValue(id);
			
			if (!content)
			{
				throw new Error('找不到与 '+ id +' 对应的VideoContent');
			}else
			{
				content.mediaPlayUpdateJitterValue(mc, value, time, direction);
			}
		}
		
	}

}

class SingletonEnforcer
{
	
}