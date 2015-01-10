package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.Security;
	import framework.FrameworkInitializer;
	import org.flexlite.domUtils.Debugger;
	import tetequ.live.modules.room.common.GlobalVars;
	import tetequ.live.mutable.RobotLegs2Config;
	/**
	 * ...
	 * @author pandazhong
	 * 应用程序入口
	 * 该应用程序内部采用RobotLegs2进行模块间通信，类似PureMvc
	 * 核心原理就是:
	 * 通过全局唯一的、由RobotLegs2提供的eventDispatcher实例
	 * 派发事件->触发与事件挂钩的command或者监听了该事件的处理器(如mediator内部的contextEventListener)来完成一次模块间通信，
	 * 整个框架采用【依赖注入】的模式，方便使用者使用各种对象而无需手动创建.
	 */
	
	[SWF(width="1280", height="720", frameRate="24")]
	public class Application extends Sprite 
	{
		[Embed(source = "../bin/app/web/assets/uilib/logoleft.png")]
		public static const LOGO_LEFT:Class;
		
		[Embed(source = "../bin/app/web/assets/uilib/logoright.png")]
		public static const LOGO_RIGHT:Class;
		
		[Embed(source = "../bin/app/web/assets/uilib/loadingbackground.jpg")]
		public static const LOADING_BACKGROUND:Class;
		
		[Embed(source="../bin/app/web/assets/uilib/logoani.swf", mimeType="application/octet-stream")]
		public static const LOGO_ANI:Class;
		
		public function Application():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			try {
				Security.allowDomain( '*' );
			}catch (e:SecurityError)
			{
				
			}

			//GlobalVars.full_screen_width = stage.fullScreenWidth;
			//GlobalVars.FULL_SCREEN_HEIGHT = stage.fullScreenHeight;
			
			new FrameworkInitializer( Application, this, RobotLegs2Config );
			//Debugger.initialize( stage );//FIXME:发布时不需要UI调试器!
		}
	}
}