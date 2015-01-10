package  
{
	import com.e2et.datalogic.User;
	import tetequ.live.modules.room.common.GlobalVars;
	public function tokenUser() :User
	{
		return GlobalVars.networkFacade.tokenUser;
	}
}