package
{
	import flash.display.DisplayObjectContainer;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Endian;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class Main extends Sprite
	{
		private var _client:Socket;
		private var _btnLogin:Button;
		private var _btnReConn:Button;
		private var _btnAcquiredToken:Button;
		private var _btnSendRoomAction:Button;
		private var _btnSendUserAction:Button;
		private var _btnUpdateUser:Button;
		private var _btnChat:Button;
		private var _btnRPC:Button;
		private var _btnPing:Button;
		private var _btnRecord:Button;
		private var _btnJoinRoom:Button;
		private var _btnLogout:Button;
		private var _pkgMap:Dictionary;
		private var _msgMap:Dictionary;
		private var cmap:Object = {};
		
		public function Main():void
		{
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			// entry point
			reset();
			
			_btnReConn = makeButton(this, "重连", 100, 200);
			_btnLogin = makeButton(this, "登陆", 200, 200);
			_btnAcquiredToken = makeButton(this, "抢令牌", 300, 200);
			_btnSendRoomAction = makeButton(this, "房间动作", 300, 200);
			_btnSendUserAction = makeButton(this, "用户动作", 400, 200);
			_btnUpdateUser = makeButton(this, "更新用户", 500, 200);
			_btnChat = makeButton(this, "聊天", 100, 300);
			_btnRPC = makeButton(this, "RPC", 200, 300);
			_btnPing = makeButton(this, "PING", 300, 300);
			_btnRecord = makeButton(this, "录制", 400, 300);
			_btnJoinRoom = makeButton(this, "加入房间", 500, 300);
			_btnLogout = makeButton(this, "退出", 600, 300);
			
			_pkgMap = new Dictionary();
			_pkgMap[_btnLogin] = loginPacket();
			_pkgMap[_btnAcquiredToken] = dummyPacket(11);
			_pkgMap[_btnSendRoomAction] = actionPacket(5);
			_pkgMap[_btnSendUserAction] = actionPacket(7);
			_pkgMap[_btnUpdateUser] = updateUserPacket();
			_pkgMap[_btnChat] = chatPacket();
			_pkgMap[_btnRPC] = RPCPacket(10086, "cb", []);
			_pkgMap[_btnPing] = pingPacket();
			_pkgMap[_btnRecord] = RecordPacket();
			_pkgMap[_btnJoinRoom] = joinRoomPacket();
			_pkgMap[_btnLogout] = dummyPacket(10);
			
			_msgMap = new Dictionary();
			_msgMap[_btnLogin] = "开始登陆";
			_msgMap[_btnAcquiredToken] = "抢令牌";
			_msgMap[_btnSendRoomAction] = "房间动作";
			_msgMap[_btnSendUserAction] = "用户动作";
			_msgMap[_btnUpdateUser] = "更新我";
			_msgMap[_btnChat] = "发送聊天消息";
			_msgMap[_btnRPC] = "RPC";
			_msgMap[_btnPing] = "PONG";
			_msgMap[_btnRecord] = "录制";
			_msgMap[_btnJoinRoom] = "请求加入房间";
			_msgMap[_btnLogout] = "退出";
			
			_procData = processData;
			
			cmap[SignalProtocol.LOGIN_RESULT] = handleLoginResult;
			cmap[SignalProtocol.JOIN_ROOM_RESULT] = handleJoinResult;
			cmap[SignalProtocol.UPDATE_USER] = handleUpdateUser;
			cmap[SignalProtocol.SEND_ROOM_ACTION] = handleRoomAction;
			cmap[SignalProtocol.SEND_USER_ACTION] = handleUserAction;
			cmap[SignalProtocol.USER_IN] = handleUserIn;
			cmap[SignalProtocol.USER_OUT] = handleUserOut;
			cmap[SignalProtocol.CHAT] = handleChat;
			cmap[SignalProtocol.RPC] = handleRPC;
			cmap[SignalProtocol.ACQUIRE_TOKEN] = handleAcquireToken;
			cmap[SignalProtocol.TOKEN_CHANGED] = handleTokenChanged;
			cmap[SignalProtocol.PING] = handlePing;
			cmap[SignalProtocol.REPEAT] = handleRemoteLogin;
			cmap[SignalProtocol.RECORD_RESULT] = handleRecordResult;
			cmap[SignalProtocol.RECORD_INFO] = handleRecordInfo;
			
			var bt:ByteArray = new ByteArray;
			bt.writeByte(0);
			bt.writeByte(0);
			bt.writeByte(0);
			bt.writeByte(0);
			bt.writeByte(0);
			//trace("write so long", bt.length);
			bt.length = 0;
			bt = null;
		}
		
		private final function handleRemoteLogin(pkt:ByteArray):void
		{
			//$.logi (logTag, "在别处登录了");
			//_handler.handleRemoteLogin(this);
			//close ();
		}
		
		//room
		private var _roomId:String = "za";
		//user
		private var _sid:uint; 
		private var _level:uint;
		private var _userId:String;
		private var _username:String;
		private var _hasCam:Boolean;
		private var _hasMic:Boolean;
		private function handleLoginResult(pkt:ByteArray):void
		{
			var ok:int = pkt.readByte ();
			var code:uint = pkt.readUnsignedInt ();
			
			//_handler.handleLoginResult (this, ok, code);
			
			if (ok == 0)
			{
				trace("登陆成功！");
				_sid = code;
				joinRoom ();
			}
		}
		
		private function joinRoom():void 
		{
			trace("请求加入房间")
			send (joinRoomPacket ());
		}
		
		private function handleJoinResult(pkt:ByteArray):void
		{
			trace("房间登陆成功！");
			// 非空字符串表示房间里面正在录制
			//var videoId:String = pkt.readUTF ();
			//_recording = videoId != '';
			// 读取用户列表
			//_connectTimer.stop ();
			//var users:Vector.<User> = new Vector.<User>;
			//var userCount:uint = pkt.readUnsignedInt ();
			//var id:uint, sid:uint, len:uint, user:User;
			//while (userCount--) {
			//id = pkt.readUnsignedInt ();
			//sid = pkt.readUnsignedInt ();
			//users.push (user = new User (id, sid));
			//user.addHandler (this);
			//}
			// 房间初始化
			//id = pkt.readUnsignedInt ();
			//_room.init (users, id);
			// 读取房间状态
			//_room.handlerOff ();
			//len = pkt.readUnsignedInt ();
			//if (len > 0)
			//{    // 房间状态解封装会用到用户列表，所以要在这之前调用 _room.init ()
			//_room.unpack (pkt);
			//}
			// 读取房间动作
			//var acount:uint = pkt.readUnsignedShort ();
			//while (acount--)
			//{
			//pkt.readShort ();
			//_room.addRawAction (pkt);
			//}
			//_room.handlerOn ();
			//_handler.handleJoinResult (this, userCount, id);
			//startClientTimer ();
			//if (_recording) // 正在录制
			//_handler.handleRecordStarted (this, videoId);
		}
		
		private function handleRecordResult(pkt:ByteArray):void
		{
			//var code:uint = pkt.readByte ();
			//if (code != 0)
			//{
			// 1 无权限(非令牌用户), 2 录制中，重复录制
			//_handler.handleRecordStartFailed (this, code);
			//}
		}
		
		private function handleRecordInfo(pkt:ByteArray):void
		{
			//var code:uint = pkt.readByte ();
			//if (code == 0)
			//{
			//var record:Boolean = pkt.readBoolean ();
			//var videoId:String = pkt.readUTF ();
			//if (record)
			//{
			//_recording = true;
			//_updatedForAll = false;
			//updateRoom ();
			//_handler.handleRecordStarted (this, videoId);
			//}
			//else
			//{
			//_recording = false;
			//_handler.handleRecordStopped (this);
			//}
			//}
		}
		
		private function handleUpdateUser(pkt:ByteArray):void
		{
			//_handler.handleUserUpdate (this, parseUser (pkt));
		}
		
		private function handleRoomAction(pkt:ByteArray):void
		{
			//_room.addRawAction (pkt);
		}
		
		private function handleUserAction(pkt:ByteArray):void
		{
			//var id:uint = pkt.readUnsignedInt ();
			//var user:User = _users.getUser(id);
			//if (user == null)
			//throw new Error ('bad user id');
			//if (user.isNewBorn ())
			//throw new Error ('bad user sequence');
			//user.addRawAction (pkt);
		}
		
		private final function handleUserIn(pkt:ByteArray):void
		{
			//var id:uint = pkt.readUnsignedInt ();
			//var user:User = _users.getUser(id);
			//if (user != null)
			//throw new Error ("bad user id");
			//user = new User (id, 0);
			//user.addHandler (this);
			//_room.userIn (user.unpack (pkt));
			//_handler.handleUserIn (this, user);
			//_updatedForAll = false; // 新进来的用户还未收到用户状态
		}
		
		private final function handleUserOut(pkt:ByteArray):void
		{
			//var type:uint = pkt.readByte ();
			//var user:User = _room.userOut (parseUser (pkt));
			//user.delHandler (this);
			//if ($.tokenUser == user)
			//_handler.handleTokenChanged (this, _tokenUser = null, $.tokenUser);
			//_handler.handleUserOut (this, user, type);
			//var stms:Vector.<AVStream> = user.streams;
			//if (stms != null && stms.length > 0)
			//{
			//var i:uint, c:uint = stms.length;
			//for (i=0; i<c; ++i)
			//{
			//var stm:AVStream = stms[i];
			//if (!stm.isOpened)
			//continue;
			//if (stm.mp != null)
			//{
			//stm.mp.close ();
			//stm.mp = null;
			//}
			//var k:int = _play_streams.indexOf (stm);
			//if (k >= 0) _play_streams.splice (k, 1);
			//}
			//}
		}
		
		private final function handleChat(pkt:ByteArray):void
		{
			//var s:uint = pkt.readUnsignedInt ();
			//var r:uint = pkt.readUnsignedInt ();
			//var su:User = _users.getUser (s);
			//var ru:User = _users.getUser (r);
			//if (su == null)
			//throw new Error ('bad user id');
			//var time:uint = pkt.readUnsignedInt ();
			//var msg:String = pkt.readUTF ();
			//_handler.handleChat(this, su, ru, time, msg);
		}
		
		private final function handleRPC(pkt:ByteArray):void
		{
			//var s:uint = pkt.readUnsignedInt ();
			//var r:uint = pkt.readUnsignedInt ();
			//var su:User = _users.getUser (s);
			//var ru:User = _users.getUser (r);
			//if (su == null)
			//throw new Error ('bad user id');
			//if (ru != null && ru !== _user)
			//return;
//
			//var func:String = pkt.readUTF();
			//var i:int, cnt:int = pkt.readShort ();
			//var args:Array = [];
			//for (i=0; i<cnt; ++i)
			//{
			//args.push (readObject(pkt));
			//}
			//_handler.handleRPC (this, su, ru, func, args);
		}
		
		private final function handleAcquireToken(pkt:ByteArray):void
		{
			//_handler.handleAcquireToken (this, pkt.readByte ());
		}
		
		private final function handleTokenChanged(pkt:ByteArray):void
		{
			//var prevToken:User = _tokenUser;
			// 新的 TokenUser 是谁？
			//var id:uint = pkt.readUnsignedInt ();
			//var i:uint, c:uint, len:uint;
			//_tokenUser = _users.getUser (id);
			//var newBorn:Boolean = (_tokenUser.isNewBorn ());
//
			// 有必要的话，读取 TokenUser 的状态
			//len = pkt.readShort ();
			//if (newBorn)
			//_tokenUser.unpack (pkt);
			//else
			//pkt.position += len;
//
			// 有必要的话，读取 TokenUser 的动作
			//if (newBorn) _tokenUser.handlerOff ();
			//c = pkt.readShort ();
			//for (i=0; i<c; ++i)
			//{
			//len = pkt.readShort ();
			//if (newBorn)
			//_tokenUser.addRawAction (pkt);
			//else
			//pkt.position += len;
			//}
			//if (newBorn)
			//{
			//_tokenUser.handlerOn ();
			//_handler.handleUserUpdate (this, _tokenUser);
			//}
//
			// 有必要的话，读取房间状态和房间动作
			//var hasStat:Boolean = pkt.readBoolean ();
			//_handler.handleTokenChanged (this, _tokenUser, prevToken);
			//if (prevToken === _user && hasStat)
			//{
			//len = pkt.readInt ();
			//_room.unpack (pkt);
			//_room.handlerOff ();
			//if (pkt.position < pkt.length)
			//{
			//c = pkt.readShort ();
			//for (i=0; i<c; ++i)
			//{
			//pkt.readShort ();
			//_room.addRawAction (pkt);
			//}
			//}
			//_room.handlerOn ();
			//}
			//if (_tokenUser === _user)
			//{   // 我获得令牌了，更新一下房间状态吧
			//updateRoom ();
			//}
		}
		
		private final function handlePing(pkt:ByteArray):void
		{
			//pkt.position = 0;
			//pkt.writeByte (SignalProtocol.PONG);
			//sendPkt (pkt);
		}
		
		protected function pingPacket():ByteArray
		{
			var pkt:ByteArray = new LEByteArray;
			pkt.writeByte(0xFC);
			pkt.writeByte(0);
			return pkt;
		}
		
		private function makeButton(parent:DisplayObjectContainer = null, label:String = "default", x:Number = 0, y:Number = 0):Button
		{
			var btn:Button = new Button(label);
			btn.x = x;
			btn.y = y;
			btn.addEventListener(MouseEvent.CLICK, onClick);
			if (parent)
				parent.addChild(btn);
			return btn;
		}
		
		private function onClick(e:MouseEvent):void
		{
			var ct:* = e.currentTarget;
			if (ct == _btnReConn)
			{
				reset();
				return;
			}
			trace(_msgMap[ct]);
			send(_pkgMap[ct]);
		}
		
		private function send(pkt:ByteArray):void
		{
			if (!_client)
				return;
			if (!_client.connected)
				return;
			_client.writeBytes(pkt);
			_client.flush();
			//trace('send data');
		}
		
		private function loginPacket():ByteArray
		{
			var o:ByteArray = new LEByteArray;
			
			o.writeByte(11);
			o.writeByte(0);
			o.writeUnsignedInt(0);
			
			o.writeUTF('userid:pandazhong');
			o.writeUTF('username:pandazhong');
			
			o.position = 2;
			o.writeUnsignedInt(o.length - 6);
			return o;
		}
		
		private function dummyPacket(type:uint):ByteArray
		{
			var o:ByteArray = new LEByteArray;
			o.writeByte(type);
			o.writeInt(0);
			return o;
		}
		
		function chatPacket():ByteArray
		{
			var bytes:ByteArray = new LEByteArray;
			bytes.writeByte(8);
			bytes.writeUnsignedInt(0);
			bytes.writeUnsignedInt(123456);
			bytes.writeUTF("hello");
			
			bytes.position = 1;
			bytes.writeUnsignedInt(bytes.length - 5);
			return bytes;
		}
		
		function RPCPacket(to:uint, func:String, args:Array):ByteArray
		{
			var bytes:ByteArray = new LEByteArray;
			bytes.writeByte(9);
			bytes.writeUnsignedInt(0);
			
			bytes.writeUnsignedInt(to);
			
			bytes.writeUTF(func);
			var i:int, c:int = args.length;
			bytes.writeShort(c);
			//for (i=0; i<c; ++i)
			//writeObject (bytes, args[i]);
			
			bytes.position = 1;
			bytes.writeUnsignedInt(bytes.length - 5);
			return bytes;
		}
		
		function updateRoomPacket():ByteArray
		{
			var bytes:ByteArray = new LEByteArray;
			bytes.writeByte(4);
			bytes.writeUnsignedInt(0);
			//room.pack (bytes);
			bytes.position = 1;
			bytes.writeUnsignedInt(bytes.length - 5);
			return bytes;
		}
		
		function joinRoomPacket():ByteArray
		{
			var o:ByteArray = new LEByteArray;
			
			o.writeByte(1);
			o.writeUnsignedInt(0);
			
			o.writeUTF (_roomId);
			
			//user
			o.writeByte (_level=100);
			o.writeUnsignedInt (_sid);

			o.writeUTF (_userId=Math.random().toString());
			o.writeUTF (_username=Math.random().toString());
			o.writeBoolean (_hasCam);
			o.writeBoolean (_hasMic);
			
			//raw.writeUnsignedInt ($nextActionId);
			//raw.writeUnsignedInt ($nextObjectId);
//
			// 先写入 n 个 <id, type>
			//var objs:Vector.<MetaObject> = new Vector.<MetaObject>;
			//for each (var o:* in $metaObjects)
			//{
				//objs.push (o);
			//}
			//objs.sort (function (a:MetaObject, b:MetaObject):int {
				//return a.$id - b.$id;
			//});
			//var i:uint, c:uint = objs.length;
			//writeU29 (raw, c);
			//for (i=0; i<c; ++i)
			//{
				//var mo:MetaObject = objs[i];
				//writeU29 (raw, mo.$id);
				//writeU29 (raw, mo.type);
			//}
//
			// 写入 n 个 UserObject
			//for (i=0; i<c; ++i)
			//{
				//mo = objs[i];
				//mo.packBody (raw);
			//}
		//
			//var stms:Vector.<AVStream> = $streams;
			//var i:uint, c:uint = stms ? stms.length : 0;
			//raw.writeByte (c);
			//for (i=0; i<c; ++i)
				//writeU29 (raw, stms[i].$id);
			
			o.position = 1;
			o.writeUnsignedInt(o.length - 5);
			return o;
		}
		
		// room = 5 user = 7
		function actionPacket(type:uint):ByteArray
		{
			var bytes:ByteArray = new LEByteArray;
			bytes.writeByte(type);
			bytes.writeUnsignedInt(0);
			bytes.writeBoolean(false);
			//act.packHead (bytes);
			//act.packBody (bytes);
			bytes.position = 1;
			bytes.writeUnsignedInt(bytes.length - 5);
			return bytes;
		}
		
		function updateUserPacket():ByteArray
		{
			var bytes:ByteArray = new LEByteArray;
			bytes.writeByte(6);
			bytes.writeUnsignedInt(0);
			bytes.writeBoolean(false);
			//user.pack (bytes);
			bytes.position = 1;
			bytes.writeUnsignedInt(bytes.length - 5);
			return bytes;
		}
		
		function RecordPacket(record:Boolean = false, videoId:String = ''):ByteArray
		{
			var pkt:ByteArray = new LEByteArray;
			
			pkt.writeByte(13);
			pkt.writeUnsignedInt(0);
			pkt.writeBoolean(record);
			pkt.writeUTF(videoId);
			pkt.position = 1;
			pkt.writeUnsignedInt(pkt.length - 5);
			return pkt;
		}
		
		private function reset(e:MouseEvent = null):void
		{
			if (_client)
			{
				_client.removeEventListener(Event.CONNECT, onConnected);
				_client.removeEventListener(Event.CLOSE, onDisconnected);
				_client.removeEventListener(ProgressEvent.SOCKET_DATA, onData);
				try
				{
					_client.close();
				}
				catch (e:*)
				{
				}
			}
			
			_client = new Socket();
			_client.endian = Endian.LITTLE_ENDIAN;
			_client.addEventListener(Event.CONNECT, onConnected);
			_client.addEventListener(Event.CLOSE, onDisconnected);
			_client.addEventListener(IOErrorEvent.IO_ERROR, onError);
			_client.addEventListener(ProgressEvent.SOCKET_DATA, onData);
			_client.connect('localhost', 8088);
		}
		
		private function onError(e:IOErrorEvent):void
		{
		
		}
		
		private function processData(type:uint, pkt:ByteArray):void
		{
			if (type != 0 && type != 251 && type != 252)
				trace("收到数据包,type:" + type);
			if (pkt == null)
			{
				//if (_updateNow)
				//updateUser ();
				trace("没有数据");
				return;
			}
			var func:Function = cmap[type];
			if (func != null)
				func(pkt);
		}
		
		var _procData:Function;
		var _state:int = 0;
		var _size:uint;
		var _type:uint;
		var _body:LEByteArray = new LEByteArray;
		
		private function onData(e:ProgressEvent):void
		{
			while (_client.connected)
			{
				switch (_state)
				{
					case 0: 
						if (_client.bytesAvailable < 1)
						{
							if (_procData)
								_procData(0, null);
							return;
						}
						_type = _client.readUnsignedByte();
						_state = 1; // 不用 break, 进入 case 1
						//trace("type", _type);
					case 1: 
						if (_client.bytesAvailable < 4)
						{
							if (_procData)
								_procData(0, null);
							return;
						}
						_size = _client.readUnsignedInt();
						_state = 2; // 不用 break, 进入 case 2
						//trace("_size", _size);
					case 2: 
						if (_client.bytesAvailable < _size)
						{
							//trace("_client.bytesAvailable < _size");
							if (_procData)
								_procData(0, null);
							return;
						}
						if (_size)
							_client.readBytes(_body, 0, _size);
						//trace("readBytes");
						if (_procData !== null)
						{
							//trace("_procData", _procData);
							_body.position = 0;
							_body.length = _size;
							/* 处理该数据包时，有可能将 Socket 关闭，所以要用 while (this.connected) 循环 */
							_procData(_type, _body);
						}
						_state = 0;
						break;
				}
			}
		}
		
		private function onDisconnected(e:Event):void
		{
			//trace('onDisconnected');
		}
		
		private function onConnected(e:Event):void
		{
			trace("服务器连接成功！");
		}
		
		private function sndData():void
		{
			//trace('发送数据<hello go server>');
			_client.writeUTFBytes('<hello go server>');
			_client.flush();
		}
	
	}

}