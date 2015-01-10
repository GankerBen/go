package  
{
	import flash.external.ExternalInterface;
	import org.flexlite.domUI.components.UIAsset;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	
	/**
	 * @param	logoUri
	 * @param	wrapper
	 * @return
	 */
	public function getLogo(logoUri:String, wrapper:UIAsset):Loader
	{
		var loader:Loader = new Loader();
		setup(loader.contentLoaderInfo.addEventListener);
		loader.load(new URLRequest(logoUri), new LoaderContext(true, ApplicationDomain.currentDomain, ExternalInterface.available ? SecurityDomain.currentDomain : null));
		function onComp(e:Event):void
		{
			setup(loader.contentLoaderInfo.removeEventListener);
			browserLog('加载完毕！', logoUri);
			browserLog('logo尺寸', loader.content.width, loader.content.height);
			wrapper.skinName = loader.content;
		}
		function onSecurityError(e:SecurityErrorEvent):void
		{
			setup(loader.contentLoaderInfo.removeEventListener);
			loader.unloadAndStop();
			browserLog('跨域错误', logoUri);
		}
		function ioError(e:IOErrorEvent):void
		{
			setup(loader.contentLoaderInfo.removeEventListener);
			loader.unloadAndStop();
			browserLog('io错误', logoUri);
		}
		function setup(func:Function):void
		{
			func(Event.COMPLETE, onComp);
			func(IOErrorEvent.IO_ERROR, ioError);
			func(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
		}
		return loader;
	}
}