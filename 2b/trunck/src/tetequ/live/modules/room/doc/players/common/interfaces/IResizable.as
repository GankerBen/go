package tetequ.live.modules.room.doc.players.common.interfaces 
{
	
	/**
	 * ...
	 * @author Pandazhong
	 * 组件实现该接口，当其宿主UI尺寸发生变化时，组件可以收到通知
	 * 组件内容可能是异步加载的，当加载完成时需要进行一次尺寸调
	 * 整，以适应所在的主机组件，setResizeDelayCall接受一个回调
	 * 参数，当内容加载完毕后，可以主动调用该方法，该方法的格式
	 * 可能为 function delaycall():void{ content.onHostResize( 
	 * stageWidth, stageHeight ); }
	 */
	public interface IResizable extends IVisualContent
	{
		function onHostResize( width:Number, height:Number, delay:Boolean = true ):void;
		function setResizeDelayCall( delay:Function ):void;
	}
	
}