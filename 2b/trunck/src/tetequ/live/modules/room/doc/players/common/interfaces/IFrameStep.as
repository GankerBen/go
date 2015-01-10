package tetequ.live.modules.room.doc.players.common.interfaces 
{
	import com.e2et.datalogic.Document;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.UIAsset;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public interface IFrameStep
	{
		function nextFrame():void;
		function prevFrame():void;
		function gotoAndStop( frame:int, step:uint = 0 ):void;
		function get currentFrame():int;
		function get totalFrames():int;
		function onHostResize( width:Number, height:Number, delay:Boolean = true ):void;
		function set onLoadStart(value:Function):void;
		function set onLoadComplete(value:Function):void;
		function setResizeDelayCall( delay:Function ):void;
		function setContainer( container:Group ):void;
		function set bindDocument( doc:Document ):void;
		function get bindDocument():Document
		function getCanvas():ICanvas;
	}
	
}