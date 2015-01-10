package tetequ.live.modules.room.avdocument 
{
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class CameraMode 
	{
		private var _width:Number;
		private var _height:Number;
		private var _fps:Number;
		
		public function CameraMode( w:Number, h:Number, fps:Number ) 
		{
			_width = w;
			_height = h;
			_fps = fps;
		}
		
		public function get width():Number 
		{
			return _width;
		}
		
		public function set width(value:Number):void 
		{
			_width = value;
		}
		
		public function get height():Number 
		{
			return _height;
		}
		
		public function set height(value:Number):void 
		{
			_height = value;
		}
		
		public function get fps():Number 
		{
			return _fps;
		}
		
		public function set fps(value:Number):void 
		{
			_fps = value;
		}
		
	}

}