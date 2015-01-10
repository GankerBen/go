package tetequ.live.modules.room.chat.common.face 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	import org.bytearray.gif.player.GIFPlayer;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Rect;
	import org.flexlite.domUI.components.TitleWindow;
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.domUI.layouts.TileLayout;
	import org.flexlite.domUI.utils.callLater;
	import tetequ.live.modules.room.common.drag.DragManagerLite;
	import tetequ.live.utils.HashMap;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 表情选择器
	 */
	public class FaceSelector extends Group 
	{
		private var _faces:HashMap;
		private var _faceGroup:Group;
		private var _faceId:String;
		private var _bg:Rect;
		
		public function FaceSelector() 
		{
			super();
			initComponents();
		}
		
		private function initComponents():void 
		{
			//this.title = "选择表情";
			
			addElement(_bg = new Rect());
			_bg.minWidth = 250;
			_bg.minHeight = 120;
			_bg.fillColor = 0xffffff;
			
			_faces = new HashMap();
			_faceGroup = new Group();
			_faceGroup.layout = new TileLayout();
			_faceGroup.minWidth = 250;
			_faceGroup.maxHeight = 120;
			
			TileLayout(_faceGroup.layout).horizontalGap = 5;
			TileLayout(_faceGroup.layout).verticalGap = 5;
			TileLayout(_faceGroup.layout).paddingLeft = 5;
			TileLayout(_faceGroup.layout).paddingRight = 5;
			
			addElement(_faceGroup);
			
			//DragManagerLite.registerDraggable( this );
			//this.showCloseButton = false;
			
			this.addEventListener( Event.REMOVED_FROM_STAGE, onStageRemoved );
			this.addEventListener( Event.ADDED_TO_STAGE, onStageAdded );
		}
		
		private function onStageAdded(e:Event):void 
		{
			this.stage.addEventListener( MouseEvent.MOUSE_DOWN, onDown );
		}
		
		private function onDown(e:MouseEvent):void 
		{
			if ( this.mouseX < 0 || this.mouseY < 0 )
			{
				Group(this.parent).removeElement(this);
			}
		}
		
		private var _index:int = 0;
		private var _facesAnim:Array;
		
		private function onStageRemoved(e:Event):void 
		{
			this.stage.removeEventListener( MouseEvent.MOUSE_DOWN, onDown );
			if ( !_facesAnim )
				_facesAnim = _faces.getValues();
			_index = 0;
			addEventListener( Event.ENTER_FRAME, onEnterframe );
		}
		
		private function onEnterframe(e:Event):void 
		{
			if (_index == _facesAnim.length)
			{
				removeEventListener( Event.ENTER_FRAME, onEnterframe );
			}else
			{
				GIFPlayer(_facesAnim[_index++].skinName).gotoAndStop(1);
			}
		}
		
		public function registerFace( face:UIAsset ):void
		{
			if ( !_faces.containsKey(face.id))
			{
				_faces.put( face.id, face );
				callLater(delayCall, [face], 10);
				face.addEventListener( MouseEvent.MOUSE_DOWN, onFaceSelected );
				face.addEventListener( MouseEvent.ROLL_OVER, onPlay );
				face.addEventListener( MouseEvent.MOUSE_OVER, onPlay );
				face.addEventListener( MouseEvent.MOUSE_OUT, onStop );
				face.addEventListener( MouseEvent.ROLL_OUT, onStop );
			}
			
		}
		
		private function delayCall(face:UIAsset):void
		{
			_faceGroup.addElement(face);
		}
		
		private function onPlay(e:MouseEvent):void 
		{
			GIFPlayer(e.currentTarget.skinName).play();
		}
		
		private function onStop(e:MouseEvent):void 
		{
			GIFPlayer(e.currentTarget.skinName).gotoAndStop(1);
		}
		
		private function onFaceSelected(e:MouseEvent):void 
		{
			_faceId = e.currentTarget.id;
			dispatchEvent(new Event(Event.SELECT));
		}
		
		public function get faceId():String 
		{
			return _faceId;
		}
		
	}

}