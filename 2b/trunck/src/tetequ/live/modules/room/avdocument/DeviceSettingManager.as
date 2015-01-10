package tetequ.live.modules.room.avdocument 
{
	import flash.events.ActivityEvent;
	import flash.events.MouseEvent;
	import flash.events.StatusEvent;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.media.SoundTransform;
	import flash.system.Security;
	import org.flexlite.domUI.components.Alert;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.TitleWindow;
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.domUI.components.VScrollBar;
	import org.flexlite.domUI.events.CloseEvent;
	import org.flexlite.domUI.layouts.VerticalLayout;
	import org.flexlite.domUI.utils.callLater;
	import tetequ.live.core.assets.AssetsFactory;
	import tetequ.live.core.network.NetworkFacade;
	import tetequ.live.modules.room.common.button.AssetUnit;
	import tetequ.live.modules.room.common.GlobalVars;
	import tetequ.live.utils.HashMap;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class DeviceSettingManager extends TitleWindow 
	{
		private var _btnSure:AssetUnit;
		private var _btnCancel:AssetUnit;
		
		public function DeviceSettingManager(single:SingletonEnforcer) 
		{
			super();
			if (!single)
				throw new Error('please call getInstance');
			initComponents();
		}
		
		private static var instance:DeviceSettingManager;
		public static function getInstance():DeviceSettingManager
		{
			return instance = instance || new DeviceSettingManager(new SingletonEnforcer());
		}
		
		/**
		 * 发言
		 */
		public function publish(invited:Boolean = false):void
		{
			if (GlobalVars.last_invited)
			{
				invited = true;
				GlobalVars.last_invited = false;
			}
			
			if (_network.avListLength >= GlobalVars.max_av_num)
			{
				Alert.show('最多支持' + GlobalVars.max_av_num + '路视频！');
				return;
			}
			
			if (_usingDevices.getKeys().length == GlobalVars.per_actor_av_num)
			{
				Alert.show('您最多可以发布 ' + GlobalVars.per_actor_av_num + ' 路视频！');
				return;
			}
			
			if ( !Microphone.isSupported )
			{
				
				if (GlobalVars.language == GlobalVars.LANG_ENGLISH)
				{
					//英文
					Alert.show( "Sorry, the system does not detect your microphone, can not speak!" );
				}else if(GlobalVars.language == GlobalVars.LANG_CHINESE)
				{
					//中文
					Alert.show( "对不起，系统没有检测到您的麦克风，不能发言!" );
					
				}else
				{
					throw new Error('无法识别的语言！');
				}
				return;
			}else if ( !Camera.isSupported )
			{
				
				if (GlobalVars.language == GlobalVars.LANG_ENGLISH)
				{
					//英文
					Alert.show( "Sorry, the system does not detect your camera, can not speak!" );
				}else if(GlobalVars.language == GlobalVars.LANG_CHINESE)
				{
					//中文
					Alert.show( "对不起，系统没有检测到您的摄像头，不能发言!" );
					
				}else
				{
					throw new Error('无法识别的语言！');
				}
				return;
			}
			
			if (!invited && !_network.hasToken)
			{
				if ( !_network.hasTokenUser )
				{
					
					if (GlobalVars.language == GlobalVars.LANG_ENGLISH)
					{
						//英文
						Alert.show( "No room speaker, failed to apply speak!" );
					}else if(GlobalVars.language == GlobalVars.LANG_CHINESE)
					{
						//中文
						Alert.show( "房间没有主讲，申请发言失败！" );
						
					}else
					{
						throw new Error('无法识别的语言！');
					}
					return;
				}
				
				if ( !_network.hasAlreadyReq )
				{
					if ( _network.canReq )
					{
						if (GlobalVars.per_actor_av_num == 0)
						{
							Alert.show('房间不允许发言！');
							return;
						}
						
						_network.sendAVReq( { } );
						
						if (GlobalVars.language == GlobalVars.LANG_ENGLISH)
						{
							//英文
							Alert.show( "Request send successfully!" );
						}else if(GlobalVars.language == GlobalVars.LANG_CHINESE)
						{
							//中文
							Alert.show( "请求已发送！" );
							
						}else
						{
							throw new Error('无法识别的语言！');
						}
					}
				}else
				{
					
					if (GlobalVars.language == GlobalVars.LANG_ENGLISH)
					{
						//英文
						Alert.show( "You already requested, please be patient!" );
					}else if(GlobalVars.language == GlobalVars.LANG_CHINESE)
					{
						//中文
						Alert.show( "您已经申请过了，请耐心等待！" );
						
					}else
					{
						throw new Error('无法识别的语言！');
					}
					return;
				}
				
				return;
			}
			
			//如果是第一次发言，则需要弹出设置面板
			if (GlobalVars.my_first_publish)
			{
				GlobalVars.uiroot.addElement(DeviceSettingManager.getInstance());
				startup(true, _fromNav);
				Alert.show('这是您第一次发言，系统需要您指定设备，然后重新点击发言按钮即可:-)');
				if(invited)
					GlobalVars.last_invited = invited;//记住这次是被邀请的
				return;
			}

			var cameraList:Array = _cameraMap.getValues();
			var has:Boolean = false;
			var count:uint;
			var isPublishing:Boolean = true;
			
			for each(var camera:CameraVO in cameraList)
			{
				if (camera.selected && !camera.isUsing)
				{
					trace('找到一个[被选中且空闲]的摄像头', camera.id);
					trace('开始寻找可用的麦克风...');
					var microList:Array =  _microMap.getValues();
					var __micro:MicroVO;
					var __hasOneMicroUsing:Boolean = false;
					
					//检查麦克风是否有一个正在使用
					for each(var micro:MicroVO in microList)
					{
						if (micro.selected && micro.isUsing)
						{
							__hasOneMicroUsing = true;
							break;
						}
					}
					
					if (!__hasOneMicroUsing)
					{
						//目前尚没有使用麦克风，则选择一个
						for each(micro in microList)
						{
							if (micro.selected && !micro.isUsing)
							{
								browserLog('找到一个[被选中且空闲]的麦克风', micro.id);
								__micro = micro;
								break;
							}
						}
					}
					
					
					if (!__micro)
					{
						browserLog('本次发言没有可用的麦克风');
					}else
					{
						__micro.isUsing = true;
						var transfrom:SoundTransform = __micro.micro.soundTransform;
						transfrom.volume = 1;
						__micro.micro.soundTransform = transfrom;
						if (__micro.micro.muted)
						{
							Alert.show('当前麦克风被禁用，您可以点击<设置>按钮，从面板中另选一个麦克风并重新发言。');
						}
					}
					
					camera.isUsing = true;

					isPublishing ? isPublishing = false : null;
					trace('即将开始发言', camera.id);
					
					var __id:String = '$' + Math.random();
					var mode:CameraMode = DeviceConfig.CAMERA_MAP.getValue(camera.fps + camera.resolution);
					
					camera.camera.setMode(mode.width, mode.height, mode.fps);
					camera.camera.setQuality(DeviceConfig.bandwidth, DeviceConfig.quality);
					
					_usingDevices.put(__id, [camera, __micro]);
					
					//if(__micro)
					//{
						//Security.showSettings('2');
						//browserLog('麦克风', __micro.name, 
								//'silenceLevel', __micro.micro.silenceLevel, 
								//'activityLevel', __micro.micro.activityLevel,
								//'muted', __micro.micro.muted);
						//__micro.micro.addEventListener(ActivityEvent.ACTIVITY, onMicroActivity);
						//__micro.micro.setLoopBack(true);
						//function onMicroActivity(e:ActivityEvent):void
						//{
							//browserLog('ActivityLevel:', Microphone(e.currentTarget).activityLevel);
						//}
					//}
					_network.newAVStreamAndOpen(camera.camera, __micro ? __micro.micro : null, 1000000 * Math.random(), { id:__id } );
					
					if(__micro)
						__micro = null;
				}
			}
			
			if (isPublishing)
			{
				Alert.show('请打开设置面板，确保您选择了至少一个设备!');
			}
		}

		/**
		 * 正在用于发言的设备
		 */
		private var _usingDevices:HashMap = new HashMap();
		
		/**
		 * 发言结束后重置设备相关属性
		 * @param	id
		 */
		public function resetDevices(id:String):void
		{
			var devices:Array = _usingDevices.getValue(id);
			if (devices)
			{
				for each(var vo:* in devices)
				{
					if (vo)
					{
						vo.isUsing = false;
					}
				}
				
				_usingDevices.remove(id);
				trace('释放devices ', id);
			}else
			{
				//throw new Error('找不到devices '+id);
			}
		}

		private var _btnRefresh:AssetUnit;
		
		/**
		 * 视频设置
		 */
		private var _camSettings:CameraSettingsView;
		
		/**
		 * 音频设置
		 */
		private var _micSettings:MikeSettingsView;
		
		/**
		 * 选项设置
		 */
		private var _optSettings:OptionSettingsView;
		
		/**
		 * 包含：视频设置、音频设置、选项设置，垂直布局
		 */
		private var _settingsGroup:Group;
		
		//垂直滑动条
		private var _scroller:VScrollBar;
		
		private function initComponents():void 
		{
			this.width = 500;
			this.minHeight = 300;
			this.percentHeight = 70;
			this.horizontalCenter = 0;
			this.verticalCenter = 0;

			_btnSure = new AssetUnit('quedingSkin', true);
			_btnCancel = new AssetUnit('quxiaoSkin', true)
			_btnRefresh = new AssetUnit('refresh_button', true);
			_btnRefresh.top = 10;
			_btnRefresh.left = 10;
			
			_btnSure.buttonMode = true;
			_btnCancel.buttonMode = true;
			_btnRefresh.buttonMode = true;
			
			_btnSure.bottom = 10;
			_btnSure.horizontalCenter = -50;
			_btnCancel.bottom = 10;
			_btnCancel.horizontalCenter = 50;
			
			addElement( _settingsGroup = new Group() );
			_settingsGroup.layout = new VerticalLayout();
			VerticalLayout(_settingsGroup.layout).gap = 40;
			_settingsGroup.horizontalCenter = 0;
			_settingsGroup.percentWidth = 100;
			_settingsGroup.top = 10;
			_settingsGroup.bottom = 60;
			_settingsGroup.addElement( _camSettings = new CameraSettingsView() );
			_settingsGroup.addElement( _micSettings = new  MikeSettingsView() );
			_settingsGroup.addElement( _optSettings = new OptionSettingsView() );
			
			_camSettings.percentWidth = 100;
			_micSettings.percentWidth = 100;
			_optSettings.percentWidth = 100;
			
			this.addElement( _scroller = new VScrollBar() );
			_scroller.viewport = _settingsGroup;
			_scroller.top = 10;
			_scroller.bottom = 60;
			_scroller.right = 0;
			_scroller.alpha = 0;
			
			addEventListener(CloseEvent.CLOSE, closeMe);
			_btnSure.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
			{
				trace('确定');
				closeMe(null);
			});
			_btnCancel.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
			{
				trace('取消')
				closeMe(null);
			});
			_btnRefresh.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
			{
				trace('刷新')
				startup(true, _fromNav);
			});
			
			addElement(_btnSure);
			addElement(_btnCancel);
			addElement(_btnRefresh);
		}
		
		private function closeMe(e:CloseEvent):void 
		{
			if (parent)
			{
				Group(parent).removeElement(this);
				_camSettings.save();
				_micSettings.save();
			}
			
			if (!_fromNav)
			{
				if (GlobalVars.last_invited)
				{
					GlobalVars.my_first_publish = false;
					publish(true);
				}
			}else
			{
				this.fromNav = false;
				GlobalVars.my_first_publish = false;
				publish();
			}
		}
		
		private var _network:NetworkFacade;
		public function set network(value:NetworkFacade):void
		{
			if (value == _network) return;
			_network = value;
		}
		
		public function get cameraList():Vector.<CameraVO> 
		{
			return _cameraList;
		}
		
		public function get microList():Vector.<MicroVO> 
		{
			return _microList;
		}
		
		private function set fromNav(value:Boolean):void 
		{
			_fromNav = value;
		}
		
		/**
		 * 启动设备管理器
		 * 以获得可用的摄像头与麦克风
		 */
		private var _cameraList:Vector.<CameraVO>;
		private var _cameraMap:HashMap = new HashMap;
		private var _microList:Vector.<MicroVO>;
		private var _microMap:HashMap = new HashMap;
		private var _hasStartup:Boolean = false;
		private var _fromNav:Boolean = false;
		
		public function startup(openPanel:Boolean = false, fromNav:Boolean = false):void
		{
			this.fromNav = fromNav;
			
			//初始化设备配置
			DeviceConfig.startup();
			
			//显示摄像头
			refreshCamera(openPanel);
			
			//显示麦克风
			refreshMicrophone(openPanel);
		}
		
		private function refreshMicrophone(openPanel:Boolean=false):void 
		{
			//刷新可获取的麦克风
			var microNames:Array = Microphone.names;
			browserLog('检测到', microNames.length, '个麦克风');
			for (var i:int = 0, len:int = microNames.length; i != len; ++i)
			{
				var index:int = i;
				var micro:Microphone = Microphone.getMicrophone(index);
				var microVO:MicroVO = _microMap.getValue(micro.index + ':' + micro.name);

				if (!microVO)
				{
					_microMap.put(micro.index + ':' + micro.name, microVO = new MicroVO());
					microVO.micro = micro;
					microVO.index = index;
					microVO.name = microNames[i];
					microVO.selected = false;
				}
			}
			
			//如果中途拔掉了某些麦克风，则对这类麦克风的引用不应该继续持有
			var names:Array = _microMap.getKeys();
			for each(name in names)
			{
				var __name:String = name.split(':')[1];
				if (microNames.indexOf(__name) < 0)
				{
					_microMap.remove(name);
				}
			}
			
			//如果有，设置一个默认被选中的麦克风
			var microVOs:Array = _microMap.getValues();

			var numSelected:uint = 0;
			for each(microVO in microVOs)
			{
				if (microVO.selected)
					numSelected++;
			}
			
			if (numSelected < 1)
			{
				for each(microVO in microVOs)
				{
					if (!microVO.selected && !microVO.micro.muted)
					{
						microVO.selected = true;
						numSelected++;
						if (numSelected == 1)
							break;
					}
				}
			}else if (numSelected > 1)
			{
				throw new Error('有超过1个麦克风被选中了！');
			}
			
			//if (numSelected < 1)
			//{
				//Alert.show('您没有安装麦克风或者所有麦克风都被禁用了！');
			//}
			
			//显示麦克风列表
			if(openPanel)
			{
				_micSettings.setMics(_microMap);
			}
		}
		
		private function refreshCamera(openPanel:Boolean = false):void 
		{
			//刷新可获取的摄像头
			var cameraNames:Array = Camera.names;
			
			browserLog('检测到', cameraNames.length, '个摄像头');

			for (var i:int = 0, len:int = cameraNames.length; i != len; ++i)
			{
				var index:String = i.toString();
				var camera:Camera = Camera.getCamera(index);
				if (camera.muted) {
					browserLog('摄像头 ', camera.name, ' 被禁用.');
				}
				
				var cameraVO:CameraVO = _cameraMap.getValue(camera.index + ':' + camera.name);
				/**
				 * 每次传入相同的index到Camera.getCamera方法，
				 * 获得的Camera实例都是不一样的，因此不能使用camera实例作为键来作为比较的对象，
				 * 当用户拔出或者新插入了摄像头后，能够唯一确定一个Camera的只能是index+name，这对于
				 * 麦克风也一样。
				 */
				if (!cameraVO)
				{
					_cameraMap.put(camera.index + ':' + camera.name, cameraVO = new CameraVO());
					cameraVO.camera = camera;
					cameraVO.fps = DeviceConfig.HD;//默认设置
					cameraVO.resolution = DeviceConfig.KEY_RES_16_9;//默认设置
					cameraVO.fullName = camera.name;//对于普通摄像头 fullName 与 name 是相同的，对于网络摄像头是不同的
					cameraVO.index = index;
					cameraVO.isIpCam = false;//Camera.names不会返回网络摄像头，网络摄像头从信令SDK获取
					cameraVO.name = cameraVO.fullName;
					cameraVO.selected = false;
					cameraVO.session = null;//暂时还不需要session
				}
			}
			
			//如果中途拔掉了某些摄像头，则对这类摄像头的引用不应该继续持有
			//var names:Array = _cameraMap.getKeys();
			//for each(name in names)
			//{
				//var __name:String = name.split(':')[1];
				//if (cameraNames.indexOf(__name) < 0)
				//{
					//_cameraMap.remove(name);
				//}
			//}
			
			//获取网络摄像头
			//var ipcams:Array = _network.session.ipcams;
			//var ipNames:Array = [];
//
			//if (ipcams)
			//{
				//for each(name in ipcams)
				//{
					//ipNames.push(name.split(',')[1]);
					//
					//if (!_cameraMap.containsKey(name))
					//{
						//_cameraMap.put(name, cameraVO = new CameraVO());
						//cameraVO.camera = null;//网络摄像头没有本地能够获取到的Camera实例
						//cameraVO.fps;//默认已设置
						//cameraVO.resolution;//默认已设置
						//cameraVO.fullName = name;
						//cameraVO.index = '';//index对网络摄像头无意义
						//cameraVO.isIpCam = true;
						//cameraVO.name = name.split(',')[1];
						//cameraVO.selected = false;
						//cameraVO.session = _network.session;
					//}
				//}
			//}
			//
			//names = _cameraMap.getKeys();
			//ipcams = [];
			//
			var cameraVOs:Array = _cameraMap.getValues();
			//
			//for each(cameraVO in cameraVOs)
			//{
				//if (cameraVO.isIpCam)
				//{
					//ipcams.push(cameraVO.name);
				//}
			//}
			//
			//删除无用的网络摄像头
			//for each(name in ipcams)
			//{
				//if (ipNames.indexOf(name) < 0)
				//{
					//_cameraMap.remove(name);
				//}
			//}


			var numSelected:uint = 0;
			for each(cameraVO in cameraVOs)
			{
				if (cameraVO.selected)
					numSelected++;
			}
			
			if (numSelected < GlobalVars.per_actor_av_num)
			{
				for each(cameraVO in cameraVOs)
				{
					if (!cameraVO.selected)
					{
						cameraVO.selected = true;
						numSelected++;
						if (numSelected == GlobalVars.per_actor_av_num)
							break;
					}
				}
			}else if (numSelected > GlobalVars.per_actor_av_num)
			{
				throw new Error('有超过 ' + GlobalVars.per_actor_av_num + ' 个摄像头被选中了！');
			}
			
			if (numSelected < GlobalVars.per_actor_av_num)
			{
				trace('不足 ' + GlobalVars.per_actor_av_num + ' 个摄像头.');
			}
			
			//显示摄像头列表
			if(openPanel)
			{
				trace('显示摄像头！');
				_camSettings.setCams(_cameraMap);
			}
		}
	}
}

class SingletonEnforcer
{
	
}