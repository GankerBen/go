package org.flexlite.skin
{

	import flash.text.TextFormatAlign;
	
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.layouts.VerticalAlign;
	import org.flexlite.domUI.skins.VectorSkin;
	
	use namespace dx_internal;
	
	/**
	 * 按钮默认皮肤
	 * @author DOM
	 */
	public class NormalButtonSkin extends VectorSkin
	{
		public function NormalButtonSkin()
		{
			super();
			states = ["up","over","down","disabled"];
			this.minHeight = 21;
			this.minWidth = 21;
		}
		
		public var labelDisplay:Label;
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			labelDisplay = new Label();
			labelDisplay.textAlign = TextFormatAlign.CENTER;
			labelDisplay.verticalAlign = VerticalAlign.MIDDLE;
			labelDisplay.maxDisplayedLines = 1;
			labelDisplay.left = 18;
			labelDisplay.right = 18;
			labelDisplay.top = 3;
			labelDisplay.bottom = 3;
			addElement(labelDisplay);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			
			graphics.clear();
			var textColor:uint;
			switch (currentState)
			{			
				case "up":
				case "disabled":
					drawCurrentState(0,0,w,h,0x42e3c2,0x42e3c2,
						[0xf2f5f7,0xf2f5f7],0);
					textColor = 0x111111;
					break;
				case "over":
					drawCurrentState(0,0,w,h,0x67e9cf,0x67e9cf,
						[0xcccccc,0xcccccc],0);
					textColor = 0x555555;
					break;
				case "down":
					drawCurrentState(0,0,w,h,0x67e9cf,0x67e9cf,
						[0xcccccc,0xcccccc],0);
					textColor = 0x555555;
					break;
			}
			if(labelDisplay)
			{
				labelDisplay.textColor = textColor;
				labelDisplay.applyTextFormatNow();
				labelDisplay.filters = (currentState=="over"||currentState=="down")?textOverFilter:null;
			}
			this.alpha = currentState=="disabled"?0.5:1;
		}
	}
}