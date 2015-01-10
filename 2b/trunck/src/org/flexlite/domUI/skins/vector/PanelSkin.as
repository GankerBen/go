package org.flexlite.domUI.skins.vector
{
	import flash.display.Graphics;
	import flash.text.TextFormatAlign;
	
	import org.flexlite.domCore.dx_internal;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.components.RectangularDropShadow;
	import org.flexlite.domUI.layouts.VerticalAlign;
	import org.flexlite.domUI.skins.VectorSkin;
	
	use namespace dx_internal;
	/**
	 * Panel默认皮肤
	 * @author DOM
	 */
	public class PanelSkin extends VectorSkin
	{
		public function PanelSkin()
		{
			super();
			this.minHeight = 60;
			this.minWidth = 80;
		}
		
		public var titleDisplay:Label;
		
		public var contentGroup:Group;
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			var dropShadow:RectangularDropShadow = new RectangularDropShadow();
			dropShadow.tlRadius=dropShadow.tlRadius=dropShadow.trRadius=dropShadow.blRadius=dropShadow.brRadius = cornerRadius;
			dropShadow.blurX = 15;
			dropShadow.blurY = 15;
			dropShadow.alpha = 0.5;
			dropShadow.distance = 0;
			dropShadow.angle = 90;
			dropShadow.color = 0x000000;
			dropShadow.left = 0;
			dropShadow.top = 0;
			dropShadow.right = 0;
			dropShadow.bottom = 0;
			addElement(dropShadow);
			
			contentGroup = new Group();
			contentGroup.top = 30;
			contentGroup.left = 1;
			contentGroup.right = 1;
			contentGroup.bottom = 1;
			contentGroup.clipAndEnableScrolling = true;
			addElement(contentGroup);
			
			titleDisplay = new Label();
			titleDisplay.maxDisplayedLines = 1;
			titleDisplay.left = 5;
			titleDisplay.right = 5;
			titleDisplay.top = 2;
			//titleDisplay.bold = true;
			titleDisplay.minHeight = 28;
			titleDisplay.fontFamily = "微软雅黑";
			titleDisplay.verticalAlign = VerticalAlign.MIDDLE;
			titleDisplay.textAlign = TextFormatAlign.CENTER;
			titleDisplay.textColor = 0x000000;
			addElement(titleDisplay);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList(w:Number,h:Number):void
		{
			super.updateDisplayList(w, h);
			
			graphics.clear();
			var g:Graphics = graphics;
			//g.lineStyle(0.1,0xaaaaaa/*borderColors[0]*/);
			//g.beginFill(0xE4E4E4,1);
			//g.beginFill(0x02DAAE,1);
			g.beginFill(0xcccccc,1);
			g.drawRoundRect(0,0,w,h,0,0);
			g.endFill();
			//g.lineStyle();
			//drawRoundRect(
				//0, 0, w, 28,{tl:/*cornerRadius-1*/0,tr:/*cornerRadius-1*/0,bl:0,br:0},
				///*[0xf6f8f8,0xe9eeee]*/[0x02DAAE,0x02DAAE/*0xAEAFB0*/], 1,
				//verticalGradientMatrix(1, 1, w, 28)); 
			//drawLine(0,28,w,28,0xAEAFB0);
			//drawLine(1,29,w,29,0x555555);
			this.alpha = currentState == "disabled"?0.5:1;
			
			//extension-2014-7-31
			g.beginFill(0xcccccc);
			g.drawRect(0, 28, w, h - 28);
			g.endFill();
		}
	}
}