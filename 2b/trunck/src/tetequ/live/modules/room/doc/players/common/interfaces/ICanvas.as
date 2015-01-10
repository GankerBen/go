package tetequ.live.modules.room.doc.players.common.interfaces 
{
	import com.e2et.datalogic.DocLine;
	import com.e2et.datalogic.DocLineAddPoint;
	import com.e2et.datalogic.DocLineEnd;
	import com.e2et.datalogic.DocLineStart;
	import com.e2et.datalogic.DocLineUpdate;
	import com.e2et.datalogic.DocText;
	import com.e2et.datalogic.DocTextChangePosition;
	import com.e2et.datalogic.DocTextChangeText;
	import com.e2et.datalogic.Document;
	import com.e2et.datalogic.RoomObjectPurge;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 绘图层接口
	 */
	public interface ICanvas 
	{
		/**
		 * 绘图层所在的容器尺寸发生改变时通知绘图层
		 * @param	pWidth	绘图层容器的宽度
		 * @param	pHeight	绘图层容器的高度
		 * @param	canvasH	绘图层视口的高度
		 */
		function onResize( pWidth:Number, pHeight:Number, canvasH:Number ):void;
		
		/**
		 * 绘图层转至某帧，绘图层用在文档播放器中，
		 * 并与文档内容页对页的绑定，当播放器翻页时，
		 * 文档内容与绘图层需要同时跳转以完成同步。
		 * @param	frame
		 */
		function drawPage( frame:int ):void;

		/**
		 * 与绘图层绑定的文档
		 */
		function set bindDocument( doc:Document ):void;
		function get bindDocument():Document;
		
		/**
		 * 画线开始
		 * @param	action
		 */
		function handleDocLineStart( action:DocLineStart ):void;
		
		/**
		 * 画线结束
		 * @param	action
		 */
		function handleDocLineEnd( action:DocLineEnd ):void;
		
		/**
		 * 更新画线
		 * @param	action
		 */
		function handleDocLineUpdate( action:DocLineUpdate ):void;
		
		/**
		 * 添加新的描点
		 * @param	action
		 */
		function handleDocLineAddPoint( action:DocLineAddPoint ):void;
		
		/**
		 * 文本位置改变
		 * 新增一个文本
		 * @param	action
		 */
		function handleDocTextChangePosition( action:DocTextChangePosition ):void;
		
		/**
		 * 当前文本内容改变
		 * @param	action
		 */
		function handleDocTextChangeText( action:DocTextChangeText ):void;
		
		/**
		 * 擦除文本
		 * @param	docText
		 */
		function handlePurgeDocText( docText:DocText ):void;
		
		/**
		 * 擦除线条
		 * @param	docLine
		 */
		function handlePurgeDocLine( docLine:DocLine ):void;
	}
	
}