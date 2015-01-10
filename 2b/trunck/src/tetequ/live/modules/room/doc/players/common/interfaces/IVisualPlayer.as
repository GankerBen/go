package tetequ.live.modules.room.doc.players.common.interfaces 
{
	import tetequ.live.modules.room.doc.players.common.interfaces.IVisualContent;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 可视化内容播放器接口
	 */
	public interface IVisualPlayer 
	{
		function getVisualContent():IResizable;
		function removeVisualContent():IResizable;
		function setVisualContent( value:IResizable ):void;
	}
	
}