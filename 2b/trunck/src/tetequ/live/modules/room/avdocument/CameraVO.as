package tetequ.live.modules.room.avdocument 
{
	import com.e2et.ISession;
	import flash.media.Camera;
	/**
	 * ...
	 * @author Pandazhong
	 * 单个摄像头参数配置
	 */
	public class CameraVO 
	{
		private var _name:String;
		private var _fullName:String;
		private var _index:String;
		private var _fps:Number;
		private var _resolution:String;
		private var _selected:Boolean;
		private var _isIpCam:Boolean;
		private var _session:ISession;
		private var _camera:Camera;
		private var _dummy:String;
		private var _id:String;
		private var _isUsing:Boolean;
		
		public function CameraVO() 
		{
		
		}
		
		public function get name():String 
		{
			return _name;
		}
		
		public function set name(value:String):void 
		{
			_name = value;
		}
		
		public function get fps():Number 
		{
			return _fps;
		}
		
		public function set fps(value:Number):void 
		{
			if (_fps == value) return;
			_fps = value;
		}
		
		public function get resolution():String 
		{
			return _resolution;
		}
		
		public function set resolution(value:String):void 
		{
			if (_resolution == value) return;
			_resolution = value;
		}
		
		public function get selected():Boolean 
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void 
		{
			if (_selected == value) return;
			_selected = value;
		}
		
		public function get index():String 
		{
			return _index;
		}
		
		public function set index(value:String):void 
		{
			_index = value;
		}
		
		public function get isIpCam():Boolean 
		{
			return _isIpCam;
		}
		
		public function set isIpCam(value:Boolean):void 
		{
			_isIpCam = value;
		}
		
		public function get session():ISession 
		{
			return _session;
		}
		
		public function set session(value:ISession):void 
		{
			_session = value;
		}
		
		public function get fullName():String 
		{
			return _fullName;
		}
		
		public function set fullName(value:String):void 
		{
			_fullName = value;
		}
		
		public function get camera():Camera 
		{
			return _camera;
		}
		
		public function set camera(value:Camera):void 
		{
			_camera = value;
		}
		
		private function get dummy():String 
		{
			return _dummy;
		}
		
		private function set dummy(value:String):void 
		{
			_dummy = value;
		}
		
		public function get id():String 
		{
			if (!_id)
			{
				_id = _index + ':' + _name;
			}
			return _id;
		}
		
		public function get isUsing():Boolean 
		{
			return _isUsing;
		}
		
		public function set isUsing(value:Boolean):void 
		{
			_isUsing = value;
		}
		
		public function toString():String
		{
			return null;
		}
	}
}