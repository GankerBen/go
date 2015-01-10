package  
{
	import org.flexlite.domUI.core.UIComponent;
	import tetequ.live.modules.room.common.GlobalVars;
	/**
	 * 设置与语言对应的tips
	 * @param	target
	 * @param	cnTips
	 * @param	enTips
	 */
	public function langTipsConfigure(target:UIComponent, cnTips:String = '', enTips:String = ''):void 
	{
		switch(GlobalVars.language)
		{
			case GlobalVars.LANG_CHINESE:
				target.toolTip = cnTips;
				break;
			case GlobalVars.LANG_ENGLISH:
				target.toolTip = enTips;
				break;
			default:
				break;
		}
	}
}