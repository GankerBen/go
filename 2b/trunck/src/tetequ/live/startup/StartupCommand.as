package tetequ.live.startup 
{
	import com.hurlant.crypto.hash.MD5;
	import com.hurlant.util.Base64;
	import com.hurlant.util.Hex;
	import flash.external.ExternalInterface;
	import flash.utils.ByteArray;
	import framework.view.UIRoot;
	import org.flexlite.domCore.Injector;
	import org.flexlite.domDll.core.ConfigItem;
	import org.flexlite.domUI.components.Alert;
	import org.flexlite.domUI.core.Theme;
	import org.flexlite.domUI.skins.themes.VectorTheme;
	import robotlegs.bender.bundles.mvcs.Command;
	import robotlegs.bender.extensions.contextView.ContextView;
	import robotlegs.bender.framework.api.ILogger;
	import tetequ.live.core.assets.AssetsLoader;
	import tetequ.live.modules.loading.view.LoadingView;
	import tetequ.live.modules.login.model.LoginVo;
	import tetequ.live.modules.login.model.LoginVoCache;
	import tetequ.live.modules.room.common.GlobalVars;
	
	/**
	 * ...
	 * @author pandazhong
	 */
	public class StartupCommand extends Command 
	{
		[Inject]
		public var logger:ILogger;
		
		[Inject]
		public var assetsManager:AssetsLoader;
		
		[Inject]
		public var contextView:ContextView;
		
		[Inject]
		public var loginVoCache:LoginVoCache;
		
		[Inject]
		public var loading:LoadingView;
		
		[Inject]
		public var uiroot:UIRoot;
		
		public function StartupCommand() 
		{
			super();
			
		}
		
		override public function execute():void
		{
			//启动FlexLite默认皮肤
			Injector.mapClass( Theme, VectorTheme );
			
			//解析从页面传过来的登陆数据
			var info:String = Application(contextView.view).loaderInfo.parameters['info'];
			var rawData:Object;
			
			if(info){
				rawData= JSON.parse(Base64.decode(info));
			}
			
			//本地资源相对路径
			var assetsConfigUri:String = "app/web/assets/asset_config.xml";
			var assetsFolder:String = "app/web/assets/";
			
			if (rawData)
			{
				//缓存登陆数据，先加载资源
				var loginVo:LoginVo = loginVoCache.cache = new LoginVo();
			
				var res:ByteArray = new ByteArray();
				res.writeUTFBytes(String(rawData['userid']) + String(rawData['userlevel']) + String(rawData['roomid']) + "qrsd_");
				
				browserLog('userid', rawData['userid']);
				browserLog('userlevel', rawData['userlevel']);
				browserLog('roomid', rawData['roomid']);
				browserLog('live_quth', rawData['live_quth']);
				
				var md5:MD5 = new MD5();
				var digest:ByteArray = md5.hash(res);
				
				browserLog('正在验证登陆信息...');
				browserLog('客户端md5:' + Hex.fromArray(digest));
				browserLog('服务器md5:' + rawData['live_quth']);

				if (Hex.fromArray(digest) != rawData['live_quth'] )
				{
					//Alert.show("非法登陆！");
					browserLog('md5验证不通过！');
					return;
				}
				
				browserLog('md5验证通过！');

				loginVo.videoId = rawData['roomid'];
				loginVo.roomid = rawData['roomid'];
				loginVo.roomorgname = 'bukav'//rawData['roomorgname'];//FIXME:暂时写死
				loginVo.usericonurl = rawData['usericonurl'];
				loginVo.userid = rawData['userid'];
				loginVo.userlevel = parseInt(rawData['userlevel']);
				loginVo.username = rawData['username'];
				
				//机构logo的URI
				if(rawData['orgLogoUri'])
					GlobalVars.orgLogoUri = rawData['orgLogoUri'];
				
				//机构的名字
				if(rawData['orgName'])
				{
					if(rawData['orgName'] == 'sanhaowang')
						GlobalVars.orgName = '三好网';
					else
						GlobalVars.orgName = rawData['orgName'];
				}
				
				GlobalVars.max_av_num = rawData['max_av_num'] > 0 ? rawData['max_av_num'] : 4;
				GlobalVars.per_actor_av_num = rawData['per_actor_av_num'] > 0 ? rawData['per_actor_av_num'] : 2;
				GlobalVars.per_visitor_av_num = rawData['per_visitor_av_num'];
				GlobalVars.user_session = rawData['userid'];
				GlobalVars.room_id = rawData['roomid'];
				
				//服务器给出资源绝对路径
				assetsConfigUri = rawData['assetsPath'] + assetsConfigUri;
				assetsFolder = rawData['assetsPath'] + assetsFolder;
				GlobalVars.topUri = rawData['assetsPath'];
				GlobalVars.videoId = loginVo.videoId;
				GlobalVars.userId = loginVo.userid;
				browserLog('您从www.bukav.com登陆，以下是登录信息:');
				browserLog('videoId:' + loginVo.roomid);
				browserLog('roomid:' + loginVo.roomid);
				browserLog('roomorgname:' + loginVo.roomorgname);
				browserLog('usericonurl:' + loginVo.usericonurl);
				browserLog('userid:' + loginVo.userid);
				browserLog('userlevel:' + loginVo.userlevel);
				browserLog('username:' + loginVo.username);
				browserLog('assetsPath:' + rawData['assetsPath']);
				browserLog('orgName ' + GlobalVars.orgName);
			}
			
			browserLog('加载并显示Loading界面...');
			loading.init(uiroot);
			
			browserLog('开始加载资源包...');
			assetsManager.loadSwfAssets();
		}
	}

}