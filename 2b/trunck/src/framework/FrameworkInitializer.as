package framework
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import framework.events.FrameworkEvent;
	import framework.view.UIRoot;
	import robotlegs.bender.bundles.mvcs.MVCSBundle;
	import robotlegs.bender.extensions.contextView.ContextView;
	import robotlegs.bender.framework.api.IConfig;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IInjector;
	import robotlegs.bender.framework.api.ILogger;
	import robotlegs.bender.framework.impl.Context;
	import robotlegs.bender.framework.impl.Logger;
	import tetequ.live.mutable.RobotLegs2Config;
	/**
	 * ...
	 * @author pandazhong
	 * 框架初始化器
	 */
	public class FrameworkInitializer 
	{
		private var _context:IContext;		//管理Robotlegs2
		
		/**
		 * 构造函数
		 * @param	rootClass		UI显示列表主容器类
		 * @param	rootInstance	UI显示列表主容器实例
		 */
		public function FrameworkInitializer( documentClass:Class, documentInstance:DisplayObjectContainer, config:Class )
		{
			_context = new Context()
			.install( MVCSBundle )
			.configure( config )
			.configure( new ContextView( documentInstance ) );
			
			_context.injector.map( documentClass ).toValue( documentInstance );
			
			//添加flexlite的主UI容器对象到原生显示列表
			documentInstance.addChild( (_context.injector.getInstance( UIRoot ) as UIRoot ) );
			( _context.injector.getInstance( ILogger ) as Logger ).debug( "Robotlegs2.0 框架初始化完毕!" );
			
			//框架启动完毕，初始化应用程序
			( _context.injector.getInstance( IEventDispatcher ) as EventDispatcher ).dispatchEvent( new FrameworkEvent( FrameworkEvent.FRAMEWORK_DONE ) );
		}
		
	}

}