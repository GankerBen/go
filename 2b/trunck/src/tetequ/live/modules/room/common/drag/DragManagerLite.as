package tetequ.live.modules.room.common.drag 
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	import org.flexlite.domUI.core.IVisualElement;
	import org.flexlite.domUI.core.UIComponent;
	import tetequ.live.utils.HashMap;
	/**
	 * ...
	 * @author Pandazhong
	 * 简单的拖放操作管理器
	 */
	public class DragManagerLite 
	{
		private static var targets:HashMap = new HashMap();;
		private static var stage:Stage;
		private static var target:UIComponent;
		
		public function DragManagerLite() 
		{

		}
		
		public static function registerDraggable( inst:UIComponent ):void
		{
			targets.put( inst.id, inst );
			inst.addEventListener( MouseEvent.MOUSE_DOWN, onDragStart );
			
			if ( !stage )
			{
				inst.addEventListener( Event.ADDED_TO_STAGE, onStage );
			}
		}

		static private function onDragStart(e:MouseEvent):void 
		{
			if ( !stage ) return;
			target = e.currentTarget as UIComponent;
			target.startDrag();
			stage.addEventListener( MouseEvent.MOUSE_UP, onDragStop );
		}
		
		static private function onDragStop(e:MouseEvent):void 
		{
			target.stopDrag();
			target = null;
			stage.removeEventListener( MouseEvent.MOUSE_UP, onDragStop );
		}
		
		static private function onStage(e:Event):void 
		{
			e.currentTarget.removeEventListener(Event.ADDED_TO_STAGE, onStage);
			stage = e.currentTarget.stage;
		}
		
	}

}