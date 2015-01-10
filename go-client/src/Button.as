package  
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class Button extends Sprite 
	{
		private var _label:String;
		private var _txtLabel:TextField;
		private var _bg:Shape;
		public function Button(label:String) 
		{
			super();
			_label = label;
			mouseChildren = false;
			draw();
		}
		
		private function draw():void
		{
			addChild(_bg = new Shape());
			drawBg(0xffffff);
			_txtLabel = new TextField();
			_txtLabel.text = _label;
			_txtLabel.width = 50;
			_txtLabel.height = 25;
			_txtLabel.border = true;
			_txtLabel.selectable = false;
			addEventListener(MouseEvent.MOUSE_OVER, onOver);
			addEventListener(MouseEvent.ROLL_OVER, onOver);
			addEventListener(MouseEvent.MOUSE_OUT, onOut);
			addEventListener(MouseEvent.ROLL_OUT, onOut);
			addChild(_txtLabel);
		}
		
		private function drawBg(color:uint):void {
			_bg.graphics.clear();
			_bg.graphics.beginFill(color, 1);
			_bg.graphics.drawRect(0, 0, 50, 25);
			_bg.graphics.endFill();
		}
		
		private function onOut(e:MouseEvent):void 
		{
			_txtLabel.textColor = 0;
			drawBg(0xffffff);
		}
		
		private function onOver(e:MouseEvent):void 
		{
			_txtLabel.textColor = 0x0000ff;
			drawBg(0x00ffff);
		}
		
	}

}