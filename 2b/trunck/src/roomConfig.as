package  
{
	import com.e2et.datalogic.RoomConfig;
	import tetequ.live.modules.room.common.GlobalVars;
	public function roomConfig():RoomConfig 
	{
		return GlobalVars.networkFacade.session.room.config;
	}

}