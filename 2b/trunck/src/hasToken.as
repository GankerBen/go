package  
{
	import tetequ.live.modules.room.common.GlobalVars;
	public function hasToken():Boolean
	{
		return GlobalVars.networkFacade.session.hasToken;
	}
}