package tetequ.live.modules.room.cm.sanhao 
{
	import com.hurlant.crypto.hash.MD5;
	import com.hurlant.util.Base64;
	import com.hurlant.util.Hex;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	import org.flexlite.domUI.components.Alert;
	import tetequ.live.modules.room.common.GlobalVars;
	/**
	 * ...
	 * @author Pandazhong
	 * 三好机构服务器通信类
	 */
	public class CM_SANHAO_WebServer 
	{
		
		public function CM_SANHAO_WebServer(single:SingletonEnforcer) 
		{
			if (!single)
				throw new Error('please call getInstance');
		}
		
		private static var instance:CM_SANHAO_WebServer;
		public static function getInstance():CM_SANHAO_WebServer
		{
			return instance = instance || new CM_SANHAO_WebServer(new SingletonEnforcer());
		}
		
		/**
		 * 三号互动教育机构的API
		 * {
			method: "room_record",
			desc: "视频房间上下课记录",
			params: [
			"user_session:用户识别（必需）",
			"room_id:房间编号",
			"record_type:记录类型（必需：1上课、2下课）"
			],
			return: [
			"status:0 成功、1提示、2失败"
			],
			url: "http://api.zgysyy.com/?act=client&method=room_record"
			}
			
		 * {
			method: "room_confirm",
			desc: "学生下课确认",
			params: [
			"user_session:用户识别（必需）",
			"room_id:房间编号"
			],
			return: [
			"status:0 成功、1提示、2失败"
			],
			url: "http://api.zgysyy.com/?act=client&method=room_confirm"
			}
			
			{
			method: "room_time",
			desc: "课程剩余时间",
			params: [
			"room_id:房间编号"
			],
			return: [
			"room_second:下课剩余秒数"
			],
			url: "http://api.zgysyy.com/?act=client&method=room_time"
			}
		 */
		
		//老师调用上下课API时使用
		private var _teacherLoader:CM_URLLoader;
		
		//学生调用下课API时使用
		private var _studentLoader:CM_URLLoader;
		
		//获取剩余时间
		private var _leftTimeLoader:CM_URLLoader;
		
		//上课
		public static const ATTEND_CLASS:String = '1';
		
		//下课
		public static const FINISH_CLASS:String = '2';
		
		//当前正在请求的记录类型
		private var _currentRecordType:String;
		
		//老师调用上下课API时请求的脚本地址
		private var _teacherUri:String = "http://api.sanhao.com/?act=client&method=room_record";
		
		//学生调用下课确认API时请求的脚本地址
		private var _studentUri:String = "http://api.sanhao.com/?act=client&method=room_confirm";
		
		//获取剩余时间的脚本地址
		private var _leftTimeUri:String = "http://api.sanhao.com/?act=client&method=room_time";
		
		/********************************************老师调用上下课(开始)*********************************************/
		/**
		 * 上课、下课，通知服务器，该方法只能被老师调用
		 * @param	user_session	用户识别(必须)
		 * @param	room_id			房间编号
		 * @param	record_type		记录类型(必须 1上课 2下课)
		 */
		public function teacherClassReq(user_session:String, room_id:String, record_type:String):void
		{
			if (!GlobalVars.networkFacade.hasToken)
			{
				WarningNoToken();
				return;
			}
			
			if (_teacherLoader) return;
			
			var timestamp:String = int(new Date().time / 1000).toString();
			var str:String = "";
			var strArr:Array = [];
			strArr['act'] = 'client';
			strArr['method'] = 'room_record';
			strArr['record_type'] = record_type;
			strArr['room_no'] = room_id;
			strArr['room_teacher_session'] = user_session;
			strArr['timestamp'] = timestamp;
			str += encodeURI(strArr['act']);
			str += encodeURI(strArr['method']);
			str += encodeURI(strArr['record_type']);
			str += encodeURI(strArr['room_no']);
			str += encodeURI(strArr['room_teacher_session']);
			str += encodeURI(strArr['timestamp']);
			str += encodeURI(GlobalVars.key_result);
			
			var res:ByteArray = new ByteArray();
			res.writeUTFBytes(str);
			
			var md5:MD5 = new MD5();
			var digest:ByteArray = md5.hash(res);
			var result:String = Hex.fromArray(digest);
			
			_teacherLoader = new CM_URLLoader(_teacherUri + '&timestamp=' + timestamp + '&encode=' + result, 
											 { room_teacher_session:user_session,
											   room_no:room_id,
											   record_type:_currentRecordType=record_type });
			_teacherLoader.load(complete, onSecurityError, onIOError);
			
			function complete(data:*):void
			{
				browserLog('老师上下课 data', data);
				var result:Object = JSON.parse(data);
				var status:int = result['status'];
				
				browserLog('result', result);
				
				trace('status', status);
				
				switch(_currentRecordType)
				{
					case ATTEND_CLASS:
						if (status == 0)
						{
							trace('上课成功~');
							
							//显示上课倒计时界面
							GlobalVars.uiroot.addElement(CM_ClassRunningView.getInstance());
							CM_ClassRunningView.getInstance().handleClassAttend();
							
							//请求上课剩余时间
							getLeftTime(GlobalVars.room_id);
							
							//设置房间的上课状态
							GlobalVars.networkFacade.session.room.config['classStatus'] = CM_SANHAO_WebServer.ATTEND_CLASS;
							
							//通知其他客户端开始上课
							GlobalVars.networkFacade.sendRPC(null,'cm_onClassAttend');
						}else
						{
							trace('上课未成功，错误码:', status);
							Alert.show(result['error']);
						}
						break;
					case FINISH_CLASS:
						if (status == 0)
						{
							trace('下课成功~');
							if(GlobalVars.uiroot.containsElement(CM_ClassRunningView.getInstance()))
							{
								GlobalVars.uiroot.removeElement(CM_ClassRunningView.getInstance());
								CM_ClassRunningView.getInstance().handleClassFinished();
							}
							
							GlobalVars.uiroot.stage.mouseChildren = false;
							GlobalVars.uiroot.addElement(CM_ClassOverView.getInstance());
							GlobalVars.networkFacade.sendRPC(null, 'cm_finishClass');
							GlobalVars.networkFacade.session.room.config['classStatus'] = CM_SANHAO_WebServer.FINISH_CLASS;
						}else
						{
							trace('下课未成功，错误码:', status);
							Alert.show(result['error']);
						}
						break;
					default:
						break;
				}
				
				_teacherLoader = null;
			}
			
			function onSecurityError():void
			{
				Alert.show('跨域错误！');
			}
			
			function onIOError():void
			{
				Alert.show('IO错误！');
			}
		}
		/********************************************老师调用上下课(结束)*********************************************/
		
		/********************************************学生调用下课(开始)*********************************************/
		public function finishClassConfirm(user_session:String, room_id:String):void
		{
			if (_studentLoader) return;
			
			var timestamp:String = int(new Date().time / 1000).toString();
			var str:String = "";
			var strArr:Array = [];
			
			strArr['act'] = 'client';
			strArr['method'] = 'room_confirm';
			strArr['room_no'] = room_id;
			strArr['room_student_session'] = user_session;
			strArr['timestamp'] = timestamp;
			
			str += strArr['act'];
			str += strArr['method'];
			str += strArr['room_no'];
			str += strArr['room_student_session'];
			str += strArr['timestamp'];
			str += GlobalVars.key_result;
			
			var res:ByteArray = new ByteArray();
			res.writeUTFBytes(str);
			
			var md5:MD5 = new MD5();
			var digest:ByteArray = md5.hash(res);
			var result:String = Hex.fromArray(digest);

			_studentLoader = new CM_URLLoader(_studentUri + '&timestamp=' + timestamp + '&encode=' + result, 
											 { room_student_session:user_session,
											   room_no:room_id});
			_studentLoader.load(complete, onSecurityError, onIOError);
			
			function complete(data:*):void
			{
				browserLog('学生确认下课 data', data);
				var result:Object = JSON.parse(data);
				var status:int = result['status'];
				trace('status', status);
				if (status == 0)
				{
					trace('下课成功！');
					GlobalVars.uiroot.stage.mouseChildren = false;
					GlobalVars.uiroot.addElement(CM_ClassOverView.getInstance());
					GlobalVars.networkFacade.session.close();
				}else
				{
					trace('下课失败！');
					Alert.show(result['error']);
				}
				
				_studentLoader = null;
			}
			
			function onSecurityError():void
			{
				Alert.show('跨域错误！');
			}
			
			function onIOError():void
			{
				Alert.show('IO错误！');
			}
		}
		/********************************************学生调用下课(结束)*********************************************/
		
		/********************************************获取剩余时间(开始)*********************************************/
		public function getLeftTime(room_id:String):void
		{
			if (_leftTimeLoader) return;
			
			var timestamp:String = int(new Date().time / 1000).toString();
			var str:String = "";
			var strArr:Array = [];
			
			strArr['act'] = 'client';
			strArr['method'] = 'room_confirm';
			strArr['room_id'] = room_id;
			strArr['timestamp'] = timestamp;
			
			str += strArr['act'];
			str += strArr['method'];
			str += strArr['room_id'];
			str += strArr['timestamp'];
			str += GlobalVars.key_result;
			
			var res:ByteArray = new ByteArray();
			res.writeUTFBytes(str);
			
			var md5:MD5 = new MD5();
			var digest:ByteArray = md5.hash(res);
			var result:String = Hex.fromArray(digest);

			_leftTimeLoader = new CM_URLLoader(_studentUri + '&timestamp=' + timestamp + '&encode=' + result,
											 {room_id:room_id});
			_leftTimeLoader.load(complete, onSecurityError, onIOError);
			
			function complete(data:*):void
			{
				var result:Object = JSON.parse(data);
				var roomSecond:int = result['room_second'];//秒
				trace('roomSecond', roomSecond == 0 ? 10000 : roomSecond * 1000);
				CM_ClassRunningView.getInstance().leftTime = roomSecond;
				
				_leftTimeLoader = null;
			}
			
			function onSecurityError():void
			{
				Alert.show('跨域错误！');
			}
			
			function onIOError():void
			{
				Alert.show('IO错误！');
			}
		}
	}
}

class SingletonEnforcer
{
	
}