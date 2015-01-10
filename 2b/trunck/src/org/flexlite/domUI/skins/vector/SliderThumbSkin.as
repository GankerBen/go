package org.flexlite.domUI.skins.vector
{
	import flash.display.Graphics;
	
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.skins.VectorSkin;
	
	use namespace dx_internal;
	
	/**
	 * 水平滑块thumb默认皮肤
	 * @author DOM
	 */
	public class SliderThumbSkin extends VectorSkin
	{
		public function SliderThumbSkin()
		{
			super();
			states = ["up","over","down","disabled"];
			this.currentState = "up";
			this.minHeight = 12;
			this.minWidth = 12;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			super.updateDisplayList(w, h);
			w = 2;
			h = 12;
			var g:Graphics = graphics;
			g.clear();
			switch (currentState)
			{			
				case "up":
				case "disabled":
					drawCurrentState(0,0,w,h,0x02DAAF,0x02DAAF,
						[0x02DAAF,0x02DAAF],0);
					break;
				case "over":
					drawCurrentState(0,0,w,h,0x02DAAF,0x02DAAF,
						[0x02DAAF,0x02DAAF],0);
					break;
				case "down":
					drawCurrentState(0,0,w,h,0x02DAAF,0x02DAAF,
						[0x02DAAF,0x02DAAF],0);
					break;
			}
			this.alpha = currentState=="disabled"?0.5:1;
		}
	}
}