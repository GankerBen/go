package tetequ.live.core.network 
{
	import com.e2et.datalogic.IMetaActionHandler;
	import com.e2et.datalogic.MetaAction;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class MetaActionHandlerFacade implements IMetaActionHandler 
	{
		[Inject]
		public var mapper:MetaActionHandlerMapper;
		
		public function MetaActionHandlerFacade() 
		{
			
		}
		
		/* INTERFACE com.e2et.datalogic.IMetaActionHandler */
		
		/**
		 * 处理动作
		 * @param	a
		 * @param	isLocal	是否是本地操作引起的
		 */
		public function handleMetaAction(a:MetaAction, isLocal:Boolean):void 
		{
			trace( a['constructor'] );
			if( mapper.getHandler( a['constructor'] ) )
			mapper.getHandler( a['constructor'] ).handleMetaAction( a, isLocal );
		}
		
	}

}