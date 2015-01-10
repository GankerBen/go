package org.flexlite.domUI.skins.vector
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
	public class ButtonSkin extends VectorSkin
	{
		public function ButtonSkin()
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
			labelDisplay.left = 15;
			labelDisplay.right = 15;
			labelDisplay.top = 3;
			labelDisplay.bottom = 3;
			labelDisplay.size = 14;
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
					drawCurrentState(0,0,w,h,0x02c19b,0x02c19b,
						[0x02daaf,0x02daaf],0);
					textColor = 0x393941;
					break;
				case "over":
					drawCurrentState(0,0,w,h,0x02a685,0x02a685,
						[0x02B995,0x02B995],0);
					textColor = 0xf2f4f7;
					break;
				case "down":
					drawCurrentState(0,0,w,h,0x67e9cf,0x67e9cf,
						[0x02B5A6,0x02B5A6],0);
					textColor = 0xf2f4f7;
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