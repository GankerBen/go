package org.flexlite.domUI.skins.vector
{
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.skins.VectorSkin;
	
	use namespace dx_internal;
	
	/**
	 * 进度条轨道默认皮肤
	 * @author DOM
	 */
	public class ProgressBarTrackSkin extends VectorSkin
	{
		public function ProgressBarTrackSkin()
		{
			super();
			this.minHeight = 10;
			this.minWidth = 30;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			
			graphics.clear();
			graphics.beginFill(0x444859,0);
			graphics.drawRect(0,0,w,h);
			graphics.endFill();
			graphics.lineStyle();
			drawRoundRect(
				0, 0, w, h, 0,
				0x444859, 5,
				verticalGradientMatrix(0, 0, w, h)); 
			if(w>4)
				drawLine(1,0,w-1,0,0x444859);
			this.alpha = currentState=="disabled"?0.5:1;
		}
	}
}