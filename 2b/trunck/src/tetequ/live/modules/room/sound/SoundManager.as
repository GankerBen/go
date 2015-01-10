package tetequ.live.modules.room.sound 
{
	import flash.media.Sound;
	import tetequ.live.core.assets.AssetsFactory;
	import tetequ.live.utils.HashMap;
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class SoundManager 
	{
		
		public function SoundManager(single:SingletonEnforcer) 
		{
			if (!single)
				throw new Error('please call getInstance');
		}
		
		private static var instance:SoundManager;
		public static function getInstance():SoundManager
		{
			return instance = instance || new SoundManager(new SingletonEnforcer());
		}
		
		/**
		 * 播放指定声音，目前只支持在库中导出了链接名的声音
		 * @param	key
		 */
		private var _rawSound:Sound;
		private var _soundMap:HashMap;
		public function playSound(key:String):void
		{return;
			if (!_soundMap)
				_soundMap = new HashMap();
			var sound:Sound = _soundMap.getValue(key);
			
			if (!sound)
			{
				_soundMap.put(key, sound = (new (AssetsFactory.getInstance().getAsset(key))) as Sound);
			}
			
			sound.play();
		}
		
	}

}

class SingletonEnforcer
{
	
}