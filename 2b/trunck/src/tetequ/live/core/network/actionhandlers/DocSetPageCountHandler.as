package tetequ.live.core.network.actionhandlers 
{
	import com.e2et.datalogic.DocSetPageCount;
	import com.e2et.datalogic.IMetaActionHandler;
	import com.e2et.datalogic.MetaAction;
	import robotlegs.bender.framework.api.IInjector;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 给文档设置总页数的动作处理器
	 */
	public class DocSetPageCountHandler implements IMetaActionHandler 
	{
		[Inject]
		public var injector:IInjector;
		
		public function DocSetPageCountHandler() 
		{
			
		}
		
		/* INTERFACE com.e2et.datalogic.IMetaActionHandler */
		
		public function handleMetaAction(a:MetaAction, isLocal:Boolean):void 
		{
			if ( !isLocal )
			{
				var action:DocSetPageCount = a as DocSetPageCount;
				trace( "设置总页数", action.pageCount );
			}
		}
		
	}

}