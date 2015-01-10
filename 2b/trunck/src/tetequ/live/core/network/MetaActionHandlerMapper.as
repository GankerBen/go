package tetequ.live.core.network 
{
	import com.e2et.datalogic.IMetaActionHandler;
	import com.e2et.datalogic.MetaAction;
	import tetequ.live.utils.HashMap;
	/**
	 * ...
	 * @author Pandazhong
	 * 映射了动作类与相应的动作处理器
	 */
	public class MetaActionHandlerMapper 
	{
		private var _mapper:HashMap;
		
		/**
		 * 构造函数
		 */
		public function MetaActionHandlerMapper() 
		{
			_mapper = new HashMap();
		}
		
		/**
		 * 映射动作到相应的处理器
		 * @param	action
		 * @param	handler
		 */
		public function map( action:Class, handler:IMetaActionHandler ):void
		{
			if ( !_mapper.containsKey( action ) )
			{
				_mapper.put( action, handler );
			}
		}
		
		/**
		 * 根据action获取对应的处理器
		 * @param	action
		 * @return
		 */
		public function getHandler( action:Class ):IMetaActionHandler
		{
			return _mapper.getValue( action );
		}
		
	}

}