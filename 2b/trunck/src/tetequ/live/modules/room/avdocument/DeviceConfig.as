package tetequ.live.modules.room.avdocument 
{
	import flash.media.Camera;
	import flash.media.Microphone;
	import tetequ.live.utils.HashMap;
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class DeviceConfig 
	{
		//从配置表读取数据
		
		//----FPS---
		//高清
		public static var HD:Number = 8;
		
		//标准
		public static var SD:Number = 10;
		
		//流畅
		public static var SM:Number = 15;
		
		public static var KEY_HD:String = '8';
		public static var KEY_SD:String = '10';
		public static var KEY_SM:String = '15';
		public static var KEY_RES_4_3:String = 'res-4-3';
		public static var KEY_RES_16_9:String = 'res-16-9';
		
		//----尺寸----
		//4:3
		public static var SM_RES_4_3:CameraMode = new CameraMode( 320, 240, SM );
		public static var SD_RES_4_3:CameraMode = new CameraMode( 480, 360, SD );
		public static var HD_RES_4_3:CameraMode = new CameraMode( 640, 480, HD );
		
		//16:9
		public static var SM_RES_16_9:CameraMode = new CameraMode( 320, 180, SM );
		public static var SD_RES_16_9:CameraMode = new CameraMode( 480, 270, SD );
		public static var HD_RES_16_9:CameraMode = new CameraMode( 896, 504, HD );
		
		public static var bandwidth:Number = 0;
		public static var quality:Number = 85;
		
		public static const CAMERA_MAP:HashMap = new HashMap();
		private static var hasStartup:Boolean = false;
		
		/**
		 * 初始化
		 */
		public static function startup():void
		{
			if (hasStartup) return; 
			hasStartup = true;
			
			CAMERA_MAP.put(KEY_HD + KEY_RES_4_3, HD_RES_4_3);
			CAMERA_MAP.put(KEY_HD + KEY_RES_16_9, HD_RES_16_9);
			
			CAMERA_MAP.put(KEY_SD + KEY_RES_4_3, SD_RES_4_3);
			CAMERA_MAP.put(KEY_SD + KEY_RES_16_9, SD_RES_16_9);
			
			CAMERA_MAP.put(KEY_SM + KEY_RES_4_3, SM_RES_4_3);
			CAMERA_MAP.put(KEY_SM + KEY_RES_16_9, SM_RES_16_9);
		}
	}
}