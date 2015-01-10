package org.flexlite.domUI.skins.vector
{
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.skins.VectorSkin;
	
	use namespace dx_internal;
	/**
	 * 
	 * @author DOM
	 */
	public class ProgressBarThumbSkin extends VectorSkin
	{
		public function ProgressBarThumbSkin()
		{
			super();
			this.minHeight = 10;
			this.minWidth = 5;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			
			graphics.clear();
			graphics.beginFill(0xc65256,0);
			graphics.drawRect(0,0,w,h);
			graphics.endFill();
			graphics.lineStyle();
			drawRoundRect(
				0, 0, w, h, 0,
				0xc65256, 5,
				verticalGradientMatrix(0, 0, w, h)); 
			if(w>5)
				drawLine(1,0,w-1,0,0xc65256);
		}
	}
}