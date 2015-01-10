package org.flexlite.domUI.skins.vector
{

	import flash.text.TextFormatAlign;
	
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.layouts.VerticalAlign;
	import org.flexlite.domUI.skins.VectorSkin;
	
	use namespace dx_internal;
	/**
	 * ToggleButton默认皮肤
	 * @author DOM
	 */
	public class ToggleButtonSkin extends VectorSkin
	{
		public function ToggleButtonSkin()
		{
			super();
			states = ["up","over","down","disabled","upAndSelected","overAndSelected"
				,"downAndSelected","disabledAndSelected"];
			this.currentState = "up";
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
			labelDisplay.left = 5;
			labelDisplay.right = 5;
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
					drawCurrentState(0,0,w,h,0x000000,0x000000,
						[0x333333,0x333333],0);
					textColor = 0xffffff;
					break;
				case "over":
					drawCurrentState(0,0,w,h,0x000000,0x000000,
						[0x02DAAE,0x02DAAE],0);
					textColor = 0xffffff;
					break;
				case "down":
				case "overAndSelected":
				case "upAndSelected":
				case "downAndSelected":
				case "disabledAndSelected":
					drawCurrentState(0,0,w,h,0x000000,0x000000,
						[0x02DAAE,0x02DAAE],0);
					textColor = 0xffffff;
					break;
			}
			if(labelDisplay)
			{
				labelDisplay.textColor = textColor;
				labelDisplay.applyTextFormatNow();
				labelDisplay.filters = (currentState=="over"||currentState=="down")?textOverFilter:null;
			}
			this.alpha = currentState=="disabled"||currentState=="disabledAndSelected"?0.5:1;
		}
	}
}