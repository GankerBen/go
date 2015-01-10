package  
{
	import com.e2et.datalogic.User;
	import tetequ.live.modules.room.common.GlobalVars;
	/**
	 * 用户是否是游客身份
	 * @param	user
	 * @return
	 */
	public function isVisitor(user:User):Boolean
	{
		return user.level == 0x40;
	}
}