package tetequ.live.core.assets 
{
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.getTimer;
	import org.flexlite.domCore.Injector;
	import org.flexlite.domDll.core.ConfigItem;
	import org.flexlite.domDll.Dll;
	import org.flexlite.domDll.events.DllEvent;
	import org.flexlite.domUI.components.supportClasses.DefaultSkinAdapter;
	import org.flexlite.domUI.core.ISkinAdapter;
	import org.flexlite.skin.SkinAdapter;
	import robotlegs.bender.framework.api.ILogger;
	import tetequ.live.core.assets.events.GroupCompleteEvent;
	import tetequ.live.modules.loading.view.LoadingView;
	import tetequ.live.modules.room.avdocument.CameraMode;
	import tetequ.live.modules.room.avdocument.DeviceConfig;
	import tetequ.live.modules.room.common.GlobalVars;

	/**
	 * ...
	 * @author pandazhong
	 * 资源加载器
	 * 负责加载资源
	 * 该软件的资源分为三种类型
	 * 1.embed到Application中的资源，一开始就会用到，所以没有打包到assets.swf
	 * 2.assets.swf中的资源，包含了全部的UI模块资源，通过AssetsFactory并传入链接名即可创建一个实例
	 * 3.表情(.gif)，这部分资源用第三方库GIFPlayer解析播放
	 */
	public class AssetsLoader
	{
		[Inject]
		public var eventDispatcher:IEventDispatcher;
		
		[Inject]
		public var factory:AssetsFactory;
		
		[Inject]
		public var logger:ILogger;
		
		[Inject]
		public var loading:LoadingView;

		public function AssetsLoader()
		{
			
		}

		private var _assets:Loader;
		private var _config:URLLoader;
		private var _time:int;
		private var _uri:String;
		
		/**
		 * 开始加载assets.swf
		 */
		public function loadSwfAssets():void
		{
			if (_assets) return;
			_time = getTimer();
			_assets = new Loader();
			_assets.load(new URLRequest(GlobalVars.topUri + 'app/web/assets/uilib/assets.swf?' + Math.random() * 1000));
			_assets.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete );
			_assets.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError );
			_assets.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgress);
		}
		
		private function onProgress(e:ProgressEvent):void 
		{
			loading.onProgress(e.bytesLoaded, e.bytesTotal);
		}
		
		/**
		 * 加载完毕
		 * @param	e
		 */
		private function onLoadComplete(e:Event):void 
		{
			browserLog('加载资源包用时 ' + (getTimer() - _time) + ' 毫秒...');
			factory.source = _assets;
			_assets.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadComplete );
			_assets.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOError );
			_assets = null;
			browserLog('素材加载完毕');
			
			_config = new URLLoader();
			_config.addEventListener(IOErrorEvent.IO_ERROR, onConfigIOError);
			_config.addEventListener(Event.COMPLETE, onConfigComplete);
			_config.load(new URLRequest(GlobalVars.topUri + 'app/web/config/orgs.xml?' + Math.random() * 1000));
		}
		
		private function onConfigComplete(e:Event):void 
		{
			var rawData:XML = XML(_config.data);
			var orgs:XMLList = rawData.children();
			var i:int, numOrgs:uint = orgs.length();
			for (; i != numOrgs; ++i)
			{
				var org:XML = orgs[i] as XML;
				var name:String = org.@name;
				if (name == GlobalVars.orgName)
				{
					GlobalVars.max_av_num = org.@max_av_num;
					GlobalVars.per_actor_av_num = org.@per_actor_av_num;
					GlobalVars.per_visitor_av_num = org.@per_visitor_av_num;
					GlobalVars.hasChat = (parseInt(org.@chat) == 0)? false : true;
					
					browserLog('hasChat', GlobalVars.hasChat);
					
					DeviceConfig.bandwidth = org.@bandwidth;
					DeviceConfig.quality = org.@quality;
					DeviceConfig.HD = org.@hd_fps;
					DeviceConfig.SD = org.@sd_fps;
					DeviceConfig.SM = org.@sm_fps;
					DeviceConfig.KEY_HD = DeviceConfig.HD.toString();
					DeviceConfig.KEY_SD = DeviceConfig.SD.toString();
					DeviceConfig.KEY_SM = DeviceConfig.SM.toString();
					DeviceConfig.SM_RES_4_3 = new CameraMode(org.@sm_res_4_3_width, org.@sm_res_4_3_height, DeviceConfig.SM);
					DeviceConfig.SD_RES_4_3 = new CameraMode(org.@sd_res_4_3_width, org.@sd_res_4_3_height, DeviceConfig.SD);
					DeviceConfig.HD_RES_4_3 = new CameraMode(org.@hd_res_4_3_width, org.@hd_res_4_3_height, DeviceConfig.HD);
					DeviceConfig.SM_RES_16_9 = new CameraMode(org.@sm_res_16_9_width, org.@sm_res_16_9_height, DeviceConfig.SM);
					DeviceConfig.SD_RES_16_9 = new CameraMode(org.@sd_res_16_9_width, org.@sd_res_16_9_height, DeviceConfig.SD);
					DeviceConfig.HD_RES_16_9 = new CameraMode(org.@hd_res_16_9_width, org.@hd_res_16_9_height, DeviceConfig.HD);
					DeviceConfig.startup();
					
					browserLog('GlobalVars.MAX_AV_NUM', GlobalVars.max_av_num);
					browserLog('GlobalVars.PER_ACTOR_AV_NUM', GlobalVars.per_actor_av_num);
					browserLog('GlobalVars.PER_VISITOR_AV_NUM', GlobalVars.per_visitor_av_num);
					browserLog('DeviceConfig.bandwidth', DeviceConfig.bandwidth);
					browserLog('DeviceConfig.quality', DeviceConfig.quality);
					browserLog('DeviceConfig.HD', DeviceConfig.HD);
					browserLog('DeviceConfig.SD', DeviceConfig.SD);
					browserLog('DeviceConfig.SM', DeviceConfig.SM);
					browserLog('DeviceConfig.KEY_HD', DeviceConfig.KEY_HD);
					browserLog('DeviceConfig.KEY_SD', DeviceConfig.KEY_SD);
					browserLog('DeviceConfig.KEY_SM', DeviceConfig.KEY_SM);
					browserLog('DeviceConfig.SM_RES_4_3', DeviceConfig.SM_RES_4_3);
					browserLog('DeviceConfig.SD_RES_4_3', DeviceConfig.SD_RES_4_3);
					browserLog('DeviceConfig.HD_RES_4_3', DeviceConfig.HD_RES_4_3);
					browserLog('DeviceConfig.SM_RES_16_9', DeviceConfig.SM_RES_16_9);
					browserLog('DeviceConfig.SD_RES_16_9', DeviceConfig.SD_RES_16_9);
					browserLog('DeviceConfig.HD_RES_16_9', DeviceConfig.HD_RES_16_9);
					break;
				}
			}
			browserLog('org length', numOrgs);
			browserLog('rawData', rawData);
			eventDispatcher.dispatchEvent( new GroupCompleteEvent( GroupCompleteEvent.GROUP_COMPLETE, 'assets' ) );
		}
		
		private function onConfigIOError(e:IOErrorEvent):void 
		{
			_config.removeEventListener(IOErrorEvent.IO_ERROR, onConfigIOError);
			_config.removeEventListener(Event.COMPLETE, onConfigComplete);
			_config.close();
			_config = null;
			browserLog('配置表加载失败，将会使用默认参数');
			eventDispatcher.dispatchEvent( new GroupCompleteEvent( GroupCompleteEvent.GROUP_COMPLETE, 'assets' ) );
		}
		
		/**
		 * 加载中遇到错误
		 * @param	e
		 */
		private function onIOError(e:IOErrorEvent):void 
		{
			_assets.unloadAndStop();
			_assets.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadComplete);
			_assets.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onIOError );
		}
	}
}