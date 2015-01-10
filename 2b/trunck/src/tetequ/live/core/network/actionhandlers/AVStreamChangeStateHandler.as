package tetequ.live.core.network.actionhandlers 
{
	import com.e2et.datalogic.AVStream;
	import com.e2et.datalogic.AVStreamChangeState;
	import com.e2et.datalogic.IMetaActionHandler;
	import com.e2et.datalogic.MetaAction;
	import tetequ.live.core.network.MediaPlayHandler;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class AVStreamChangeStateHandler implements IMetaActionHandler 
	{
		[Inject]
		public var mediaPlayHandler:MediaPlayHandler;
		
		public function AVStreamChangeStateHandler() 
		{
			
		}
		
		/* INTERFACE com.e2et.datalogic.IMetaActionHandler */
		
		public function handleMetaAction(a:MetaAction, isLocal:Boolean):void 
		{
			if ( !isLocal )
			{
				var avstm:AVStream = ( a as AVStreamChangeState ).stream;
				if ( !avstm ) return;
				if ( avstm.state == AVStream.STARTED )
				{
					avstm.mp.addHandler( mediaPlayHandler ); 
				}else if ( avstm.state == AVStream.STARTING ) 
				{

				}
			}
		}
		
	}

}