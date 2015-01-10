package tetequ.live.modules.room.cm.sanhao 
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class CM_URLLoader 
	{
		/**
		 * 类似如下形式的键值对
		 * {user_session:'dummy_user_session', room_id:'dummy_room_id'}
		 */
		private var _args:Object;
		private var _uri:String;
		private var _ioError:Function;
		private var _securityError:Function;
		private var _complete:Function;
		private var _loader:URLLoader;
		
		public function CM_URLLoader(uri:String, args:Object) 
		{
			_uri = uri;
			_args = args;
		}
		
		public function load(completeHandler:Function, ioErrorHandler:Function=null, securityErrorHandler:Function=null):void
		{
			var req:URLRequest;
			var vars:URLVariables;
			
			if (_loader) return;
			_complete = completeHandler;
			_ioError = ioErrorHandler;
			_securityError = securityErrorHandler;
			
			req = new URLRequest(_uri);
			vars = new URLVariables();

			for (var key:* in _args)
			{
				vars[key] = _args[key];
			}
			
			req.data = vars;
			req.method = URLRequestMethod.POST;
			req.requestHeaders = [new URLRequestHeader("Channel-Id", "client")];
			
			setupEventListener((_loader = new URLLoader()).addEventListener);
			_loader.load(req);
			
			browserLog('req uri', req.url);
		}
		
		private function setupEventListener(func:Function):void
		{
			func(Event.COMPLETE, onComplete);
			func(IOErrorEvent.IO_ERROR, onIOError);
			func(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
		}
		
		private function onSecurityError(e:SecurityErrorEvent):void 
		{
			setupEventListener(_loader.removeEventListener);
			dispose();
			if (_securityError != null)
				_securityError.apply();
		}
		
		private function onIOError(e:IOErrorEvent):void 
		{
			setupEventListener(_loader.removeEventListener);
			dispose();
			if (_ioError != null)
				_ioError.apply();
		}
		
		private function onComplete(e:Event):void 
		{
			setupEventListener(_loader.removeEventListener);
			if (_complete != null)
				_complete.apply(null, [_loader.data]);
			dispose();
		}
		
		private function dispose():void
		{
			_loader.close();
			_loader = null;
		}
	}
}