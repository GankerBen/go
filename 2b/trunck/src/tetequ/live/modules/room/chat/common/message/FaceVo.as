package tetequ.live.modules.room.chat.common.message 
{
	import org.flexlite.domUI.components.UIAsset;
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class FaceVo 
	{
		private var _index:int;
		private var _face:UIAsset;
		
		public function FaceVo() 
		{
			
		}
		
		public function get index():int 
		{
			return _index;
		}
		
		public function set index(value:int):void 
		{
			_index = value;
		}
		
		public function get face():UIAsset 
		{
			return _face;
		}
		
		public function set face(value:UIAsset):void 
		{
			_face = value;
		}
		
	}

}