package tetequ.live.core.network 
{
	import com.e2et.createNewSession;
	import com.e2et.datalogic.AVItem;
	import com.e2et.datalogic.AVReq;
	import com.e2et.datalogic.AVStream;
	import com.e2et.datalogic.DocPage;
	import com.e2et.datalogic.Document;
	import com.e2et.datalogic.IMetaActionHandler;
	import com.e2et.datalogic.LocalUser;
	import com.e2et.datalogic.MediaPlayer;
	import com.e2et.datalogic.MetaObject;
	import com.e2et.datalogic.Room;
	import com.e2et.datalogic.User;
	import com.e2et.datalogic.Users;
	import com.e2et.ISession;
	import com.e2et.ISessionHandler;
	import com.e2et.net.media.audio.IAudioCapture;
	import com.e2et.net.media.video.IPreview;
	import com.e2et.net.media.video.IVideoCapture;
	import com.e2et.net.signal.SignalClient;
	import com.e2et.net.ULog;
	import com.e2et.Session;
	import flash.events.IEventDispatcher;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.media.SoundCodec;
	import flash.media.Video;
	import org.flexlite.domUI.components.Alert;
	import tetequ.live.modules.room.common.GlobalVars;
	/**
	 * ...
	 * @author Pandazhong
	 * 信令相关的操作都封装在这里
	 * 用于隔离底层与UI层的交互。
	 */
	public class NetworkFacade 
	{
		[Inject]
		public var sessionHandler:SessionHandler;
		
		[Inject]
		public var eventDispatcher:IEventDispatcher;

		private var _user:LocalUser;
		private var _room:Room;
		private var _session:ISession;
		
		public function NetworkFacade() 
		{
			
		}
		
		/**
		 * 登陆
		 * @param	userId	用户id
		 * @param	userName	用户名
		 * @param	roomId	房间id(与videoId相同)
		 * @param	level	用户等级 0x80以上能抢令牌 0x80一下不能抢令牌
		 */
		public function init( userId:String, userName:String, roomId:String, level:uint ):void
		{
			MetaObject.registerAll ();
			_room = new Room( roomId, "bukav" );
			_room.localUser = _user = new LocalUser( userId, userName, level );
			_session = createNewSession( _room );
			_session.init( sessionHandler );
			GlobalVars.networkFacade = this;
			GlobalVars.eventDispatcher = eventDispatcher;
		}
		
		/**
		 * 添加房间动作处理器
		 * (文档翻页、画线等动作属于房间动作)
		 * @param	handler
		 */
		public function addRoomHandler( handler:IMetaActionHandler ):void
		{
			_room.addHandler( handler );
			_user.addHandler( handler );
		}
		
		/**
		 * 设置令牌用户
		 */
		public function set tokenUser( user:User ):void
		{
			_room.tokenUser = user;
		}
		
		/**
		 * 获取令牌用户
		 */
		public function get tokenUser():User
		{
			return _room.tokenUser;
		}
		
		/**
		 * 获取当前用户的名字
		 */
		public function get userName():String
		{
			return _user.name;
		}
		
		/**
		 * 获取当前用户的id
		 */
		public function get userId():String
		{
			return _user.userid;
		}
		
		/**
		 * 发送聊天消息
		 * @param	msg
		 * @param	to
		 */
		public function sendChat( msg:String, to:User = null ):void
		{
			_session.sendChat( msg, to );
		}
		
		/**
		 * 打开文档
		 * (docx、ppt、pptx、ttq等)
		 * @param	name	文档名
		 * @param	uri		文档地址
		 */
		public function openDocument( name:String, uri:String, docInfo:* = null ):Document
		{
			return _session.room.newDocument( name, uri, docInfo ).open();
		}
		
		/**
		 * 打开media文件
		 * (mp3、MP4等等)
		 * @param	file
		 * @param	mediaInfo
		 */
		public function openMediaPlayer( file:String, mediaInfo:* ):void
		{
			_session.room.newMediaPlayer( file, mediaInfo ).open();
		}
		
		/**
		 * 关闭上一个文档
		 */
		public function closePrevDoc():void
		{
			if ( _session.room.doc )
			{
				_session.room.doc.close();
			}
		}
		
		/**
		 * 房间有令牌用户吗
		 * @return
		 */
		public function get hasTokenUser():Boolean
		{
			return _room.tokenUser != null;
		}
		
		/**
		 * 是否正在录制
		 */
		public function get recording():Boolean
		{
			return _session.recording;
		}
		
		/**
		 * 开始录制
		 * @param	videoId
		 */
		public function startRecord(videoId:String):void
		{
			_session.startRecord(videoId);
		}
		
		/**
		 * 停止录制
		 */
		public function stopRecord():void
		{
			_session.stopRecord();
		}
		
		/**
		 * 关闭上一个media，这个方法
		 * 肯定是主讲本地调用的。
		 * 这可能是video、audio、img等
		 * 根据type来区分关闭哪一个。
		 */
		public function closePrevMedia( type:String ):void
		{
			var mps:Vector.<MediaPlayer> = _room.mediaPlayers;
			if ( !mps ) return;
			
			for each( var mp:MediaPlayer in mps )
			{
				if ( mp.mediaInfo['master'] == type )
				{
					mp.close();
					return;
				}
			}
		}
		
		/**
		 * 文档翻页
		 * @param	frame	页码
		 * @param	step	该页第几步
		 * @return
		 */
		public function gotoPage( frame:uint, step:uint = 0 ):DocPage
		{
			return _room.doc.gotoPage( frame, step );
		}
		
		/**
		 * '我'是否有令牌
		 * @return
		 */
		public function get hasToken():Boolean
		{
			return _session.hasToken;
		}
		
		/**
		 * 获取令牌
		 */
		public function acquireToken():void
		{
			_session.acquireToken();
		}
		
		/**
		 * 切换某一路流的音频开关
		 * @param	userid
		 */
		public function avstreamToggleAudio( userid:String ):void
		{
			if ( _user.hasStream )
			{
				for each( var avstm:AVStream in _user.streams )
				{
					if ( avstm.user.userid == userid )
					{
						avstm.toggleAudio();
						return;
					}
				}
			}
		}
		
		/**
		 * 切换某一路流的视频开关
		 * @param	userid
		 */
		public function avstreamToggleVideo( userid:String ):void
		{
			if ( _user.hasStream )
			{
				for each( var avstm:AVStream in _user.streams )
				{
					if ( avstm.user.userid == userid )
					{
						avstm.toggleVideo();
						return;
					}
				}
			}
		}
		
		/**
		 * 房间视频数量
		 */
		public function get avListLength():int
		{
			return GlobalVars.avnum;
		}
		
		/**
		 * 申请发言
		 */
		public function addAVReq( user:User, info:* ):void
		{
			_room.addAVReq( user, info );
		}
		
		/**
		 * 发送发言请求
		 * @param	info
		 */
		public function sendAVReq( info:* ):void
		{
			_session.sendAVReq( info );
		}
		
		/**
		 * 申请者删除发言申请
		 * @param	user
		 */
		public function delAVReqByUser( user:User ):void
		{
			_room.delAVReqByUser( user );
		}
		
		/**
		 * 接收者删除发言申请
		 * @param	req
		 * @param	actor
		 */
		public function delAvReq( req:AVReq, actor:User = null ):void
		{
			_room.delAVReq( req, actor );
		}
		
		/**
		 * 是否可以申请发言
		 */
		public function get canReq():Boolean
		{
			return _room.avReqs.length < 5;
		}
		
		/**
		 * 是否已经申请了发言
		 */
		public function get hasAlreadyReq():Boolean
		{
			for each( var req:AVReq in _room.avReqs )
			{
				if ( req.user.userid == userId )
				{
					return true;
				}
			}
			
			return false;
		}
		
		/**
		 * 远程过程调用
		 * @param	to
		 * @param	func
		 * @param	...args
		 */
		public function sendRPC( to:User, func:String, ...args ):void
		{
			_session.sendRPC( to, func, args );
		}
		
		/**
		 * 发言
		 * @param	name
		 * @param	audioOn
		 * @param	videoOn
		 */
		public function newAVStreamAndOpen( cam:Camera, mike:Microphone, avId:uint, info:* ):void
		{
			mike ? mike.codec = SoundCodec.SPEEX : null;
			_user.newAVStream( new AVItem( _user, avId, info ) ).open ( mike ? _session.newMicCapture( mike ) : null, cam ? _session.newCamCapture( cam ) : null );
		}
		
		/**
		 * 开启屏幕共享
		 * @param	closure
		 * @return
		 */
		public function newScreenCapture( closure:Function, avid:uint, info:* ):*
		{
			var screenCapture:IVideoCapture = _session.newScreenCapture(closure);
			var avStream:AVStream = _user.newAVStream(new AVItem(_user, avid, info));
			avStream.open(null, screenCapture);
			return { sc:screenCapture, av:avStream };
		}
		
		/**
		 * 切换摄像头
		 * @param	cam
		 */
		public function newCamCapture( cam:Camera ):IVideoCapture
		{
			return _session.newCamCapture( cam );
		}
		
		/**
		 * 切换麦克风
		 * @param	mic
		 */
		public function newMicCapture( mic:Microphone ):IAudioCapture
		{
			return _session.newMicCapture( mic );
		}
		
		/**
		 * 设置指定的media音量
		 * @param	file
		 * @param	volume
		 */
		public function mediaPlayChangeVolume( file:String, volume:Number ):void
		{
			if ( !hasToken )
			{
				Alert.show( "对不起，您不是主讲，不能执行此操作！" );
				return;
			}
			for each( var mp:MediaPlayer in _room.mediaPlayers )
			{
				if ( mp.file == file )
				{
					mp.volume = volume;
					return;
				}
			}
		}
		
		/**
		 * 暂停或者播放指定media
		 * @param	file
		 */
		public function mediaPlayTogglePause( file:String ):void
		{
			if ( !hasToken )
			{
				Alert.show( "对不起，您不是主讲，不能执行此操作！" );
				return;
			}
			for each( var mp:MediaPlayer in _room.mediaPlayers )
			{
				if ( mp.file == file )
				{
					mp.togglePause();
					return;
				}
			}
		}
		
		/**
		 * media(mp3、mp4等)是否已经停止
		 * @param	file
		 * @return
		 */
		public function isMediaPlayPaused( file:String ):Boolean
		{
			for each( var mp:MediaPlayer in _room.mediaPlayers )
			{
				if ( mp.file == file )
				{
					return mp.paused;
				}
			}
			
			return false;
		}
		
		/**
		 * seek指定的media
		 * @param	file
		 */
		public function mediaPlaySeek( file:String, time:Number ):void
		{
			if ( !hasToken )
			{
				Alert.show( "对不起，您不是主讲，不能执行此操作！" );
				return;
			}
			for each( var mp:MediaPlayer in _room.mediaPlayers )
			{
				if ( mp.file == file )
				{
					mp.seek( time );
					return;
				}
			}
		}
		
		/**
		 * 关闭某一路视频
		 * @param	userid
		 */
		public function closeAVStream( avid:uint ):void
		{
			if ( _user.hasStream )
			{
				for each( var avstm:AVStream in _user.streams )
				{
					if ( avstm.avid == avid )
					{
						avstm.close();
						return;
					}
				}
			}
		}
		
		/**
		 * 更新用户信息
		 * @param	to
		 * @param	callback
		 * @return
		 */
		public function requestUserUpdate( to:User = null, callback:Function = null ):void
		{
			_session.requestUserUpdate( to, callback );
		}
		
		/**
		 * 获取用户列表
		 */
		public function get userList():Users
		{
			return _session.userList;
		}
		
		/**
		 * 房间正打开着的文档
		 */
		public function get doc():Document
		{
			return _session.room.doc;
		}
		
		/**
		 * 输出消息到浏览器控制台
		 * @param	...args
		 */
		public function logd( ...args ):void
		{
			_session.logd( args );
		}
		
		/**
		 * 我
		 */
		public function get user():LocalUser
		{
			return _user;
		}
		
		/**
		 * 信令
		 */
		public function get session():ISession 
		{
			return _session;
		}
		
	}

}