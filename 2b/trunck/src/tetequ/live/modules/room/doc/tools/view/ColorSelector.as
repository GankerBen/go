package tetequ.live.modules.room.doc.tools.view 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Rect;
	import org.flexlite.domUI.components.TextInput;
	import org.flexlite.domUI.layouts.HorizontalLayout;
	import org.flexlite.domUI.layouts.TileLayout;
	import org.flexlite.domUI.layouts.VerticalLayout;
	import org.flexlite.domUI.skins.vector.TextInputSkin;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 颜色选取器
	 */
	public class ColorSelector extends Group 
	{
		private var _group1:Group;
		private var _previewColor:Rect;//当前设置的颜色预览
		private var _colorInput:TextInput;//颜色输入框
		
		private var _group2:Group;
		private var _defaultColor1:Rect;//红
		private var _defaultColor2:Rect;//绿
		private var _defaultColor3:Rect;//蓝
		private var _defaultColor4:Rect;//黄
		private var _defaultColor5:Rect;//青
		private var _defaultColor6:Rect;//紫
		private var _defaultColor7:Rect;//白
		private var _defaultColor8:Rect;//黑
		
		private var _color:uint;//设置的颜色
		private var _colorPattern:RegExp = /[^0-9a-fA-F\n]/g;
		
		public function ColorSelector() 
		{
			super();
			initComponents();
		}
		
		private function initComponents():void 
		{
			this.layout = new VerticalLayout();
			addElement( _group1 = new Group() );
			addElement( _group2 = new Group() );
			
			_group1.layout = new HorizontalLayout();
			_group2.layout = new TileLayout();
			
			TileLayout(_group2.layout).horizontalGap = 0;
			TileLayout(_group2.layout).verticalGap = 0;
			TileLayout(_group2.layout).requestedColumnCount = 4;
			
			_group1.addElement( _previewColor = createColorRect( 50, 50, 0x000000 ) );
			//_group1.addElement( _colorInput = new TextInput() );
			
			//_colorInput.skinName = TextInputSkin;
			//_colorInput.prompt = "0x000000";
			//_colorInput.addEventListener( Event.CHANGE, onInputChanged );
			
			_group2.addElement( _defaultColor1 = createColorRect( 50, 50, 0xff0000 ) );
			_group2.addElement( _defaultColor2 = createColorRect( 50, 50, 0x00ff00 ) );
			_group2.addElement( _defaultColor3 = createColorRect( 50, 50, 0x0000ff ) );
			_group2.addElement( _defaultColor4 = createColorRect( 50, 50, 0xffff00 ) );
			_group2.addElement( _defaultColor5 = createColorRect( 50, 50, 0x00ffff ) );
			_group2.addElement( _defaultColor6 = createColorRect( 50, 50, 0xff00ff ) );
			_group2.addElement( _defaultColor7 = createColorRect( 50, 50, 0xffffff ) );
			_group2.addElement( _defaultColor8 = createColorRect( 50, 50, 0x000000 ) );
			
			var index:int = 1;
			while ( index < 9 )
			{
				addEventListenerFor( Rect( this['_defaultColor' + index] ) );
				index++;
			}
		}
		
		//private function onInputChanged(e:Event):void 
		//{
			//var str:String = _colorInput.text;
			//str = str.replace( _colorPattern, null );
			//_colorInput.text = str;
		//}
		
		private function addEventListenerFor( rect:Rect ):void
		{
			rect.addEventListener( MouseEvent.ROLL_OVER, onColorRectOver );
			rect.addEventListener( MouseEvent.MOUSE_OVER, onColorRectOver );
			rect.addEventListener( MouseEvent.MOUSE_DOWN, onColorSelected );
		}
		
		private function onColorSelected(e:MouseEvent):void 
		{
			if ( _color != Rect(e.currentTarget).fillColor )
			{
				_color = Rect(e.currentTarget).fillColor;
				dispatchEvent( new Event( Event.SELECT ) );
			}else
			{
				Group(this.parent).removeElement( this );
			}
		}
		
		private function onColorRectOver(e:MouseEvent):void 
		{
			var rect:Rect = e.currentTarget as Rect;
			_previewColor.fillColor = rect.fillColor;
		}
		
		private function createColorRect( w:Number, h:Number, color:uint ):Rect
		{
			var rect:Rect = new Rect();
			rect.width = w;
			rect.height = h;
			rect.fillColor = color;
			return rect;
		}
		
		public function get color():uint 
		{
			return _color;
		}
		
	}

}