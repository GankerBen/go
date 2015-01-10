package tetequ.live.core.network.actionhandlers 
{
	import com.e2et.datalogic.DocPageGoto;
	import com.e2et.datalogic.IMetaActionHandler;
	import com.e2et.datalogic.MetaAction;
	import flash.events.IEventDispatcher;
	import robotlegs.bender.framework.api.IInjector;
	import tetequ.live.modules.room.doc.players.common.events.DocGotoEvent;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 设置当前页动作处理器
	 */
	public class DocPageGotoHandler implements IMetaActionHandler 
	{
		[Inject]
		public var eventDispatcher:IEventDispatcher;
		
		public function DocPageGotoHandler() 
		{
			
		}
		
		/* INTERFACE com.e2et.datalogic.IMetaActionHandler */
		
		public function handleMetaAction(a:MetaAction, isLocal:Boolean):void 
		{
			if ( !isLocal )
			{
				var action:DocPageGoto = a as DocPageGoto;
				var playerId:String = ( action.room.user.level & 0x80 ) ? action.room.doc.docInfo['master'] : action.room.doc.docInfo['normal'];
				eventDispatcher.dispatchEvent( new DocGotoEvent( action.pageNo + 1, action.step, playerId ) );
			}
		}
		
	}
}