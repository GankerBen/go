package tetequ.live.modules.room.chat.common.face 
{
	import org.bytearray.gif.player.GIFPlayer;
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.domUI.events.UIEvent;
	import tetequ.live.utils.HashMap;
	/**
	 * ...
	 * @author Pandazhong
	 * 表情动画管理器
	 * 负责创建表情、管理表情的数据源
	 */
	public class FaceFactory 
	{
		/**
		 * 表情动画的数据源(聊天信息中的表情都是从这里克隆的)
		 * 这些动画不会被渲染
		 */
		private var _rawAnimations:HashMap;

		public function FaceFactory(single:SingletonEnforcer) 
		{
			if (!single)
				throw new Error('please call getInstance!');
			init();
		}
		
		private static var instance:FaceFactory;
		public static function getInstance():FaceFactory
		{
			return instance = instance || new FaceFactory(new SingletonEnforcer());
		}
		
		private function init():void 
		{
			_rawAnimations = new HashMap();
		}
		
		public function registerRawAnimations( animations:Vector.<GIFPlayer> ):void
		{
			for each( var anim:GIFPlayer in animations )
			{
				_rawAnimations.put( anim.id, anim );
			}
		}
		
		/**
		 * 根据id获取表情动画
		 * 必须要手动设置clone对象的宽高，不然会有BUG
		 * @param	id
		 */
		public function cloneFace( id:int ):UIAsset
		{
			var clone:GIFPlayer = cloneGIFPlayer( id );
			var face:UIAsset = new UIAsset();
			
			clone.width = clone.height = 24;
			clone.play();
			
			face.addEventListener( UIEvent.SKIN_CHANGED, onSkin );
			face.skinName = clone;
			face.id = id.toString();
			
			return face;
		}
		
		private function onSkin(e:UIEvent):void 
		{
			e.currentTarget.width = 24;
			e.currentTarget.height = 24;
		}
		
		/**
		 * 克隆一个GIFPlayer对象
		 * @param	id
		 */
		private function cloneGIFPlayer( id:int ):GIFPlayer
		{
			if ( !_rawAnimations.containsKey( id ) )
				throw new Error( "该表情不存在!id = " + id );
				
			return GIFPlayer(_rawAnimations.getValue( id )).clone();
		}
	}
}

class SingletonEnforcer
{
	
}