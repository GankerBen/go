package  
{
	import flash.external.ExternalInterface;
	import tetequ.live.modules.room.common.GlobalVars;
	public function browserLog(...msg):void 
	{
		var i:int, len:int = msg.length;
		var msgs:String = '';
		
		for ( ; i != len ; ++i )
		{
			msgs += msg[i] + '\n';
		}
		
		if (ExternalInterface.available)
		{
			ExternalInterface.call('console.log', msgs);
		}
		
		trace(msgs);
	}
}