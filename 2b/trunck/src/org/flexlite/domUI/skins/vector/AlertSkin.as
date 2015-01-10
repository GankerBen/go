package org.flexlite.domUI.skins.vector
{
	import flash.display.Graphics;
	import flash.text.TextFormatAlign;
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.skin.AlerticonButtonSkin;
	import org.flexlite.skin.NormalButtonSkin;
	import tetequ.live.core.assets.AssetsFactory;
	import tetequ.live.modules.room.common.GlobalVars;
	
	import org.flexlite.domUI.components.Button;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.layouts.HorizontalAlign;
	import org.flexlite.domUI.layouts.HorizontalLayout;
	import org.flexlite.domUI.layouts.VerticalAlign;
	
	/**
	 * Alert默认皮肤
	 * @author DOM
	 */
	public class AlertSkin extends TitleWindowSkin
	{
		/**
		 * 构造函数
		 */		
		public function AlertSkin()
		{
			super();
			//this.minHeight = 100;
			//this.minWidth = 170;
			//this.maxWidth = 310;
			
			this.minHeight = 200;
			this.minWidth = 350;
			this.maxWidth = 500;
		}
		
		/**
		 * [SkinPart]文本内容显示对象
		 */		
		public var contentDisplay:Label;
		/**
		 * [SkinPart]第一个按钮，通常是"确定"。
		 */		
		public var firstButton:UIAsset;
		/**
		 * [SkinPart]第二个按钮，通常是"取消"。
		 */		
		public var secondButton:UIAsset;
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			contentDisplay = new Label;
			contentDisplay.top = 30;
			contentDisplay.left = 1;
			contentDisplay.right = 1;
			contentDisplay.bottom = 36;
			contentDisplay.verticalAlign = VerticalAlign.MIDDLE;
			contentDisplay.textAlign = TextFormatAlign.CENTER;
			contentDisplay.padding = 10;
			contentDisplay.selectable = true;
			contentDisplay.textColor = 0x888888;
			contentDisplay.fontFamily = "微软雅黑";
			addElementAt(contentDisplay,0);
			
			var hGroup:Group = new Group;
			hGroup.bottom = 20;
			hGroup.horizontalCenter = 0;
			var layout:HorizontalLayout = new HorizontalLayout();
			layout.horizontalAlign = HorizontalAlign.CENTER;
			layout.gap = 30;
			layout.paddingLeft = layout.paddingRight = 20;
			hGroup.layout = layout;
			addElement(hGroup);
			
			var logo:UIAsset = new UIAsset();
			logo.skinName = AssetsFactory.getInstance().getAsset('alerticon');
			logo.horizontalCenter = 0;
			logo.top = 35;
			addElement(logo);
			
			firstButton = new UIAsset();
			firstButton.mouseChildren = true;
			firstButton.mouseEnabled = true;
			firstButton.skinName = AssetsFactory.getInstance().getAsset('quedingSkin');
			hGroup.addElement(firstButton);
			secondButton = new UIAsset();
			secondButton.mouseChildren = true;
			secondButton.mouseEnabled = true;
			secondButton.skinName = AssetsFactory.getInstance().getAsset('quxiaoSkin');
			hGroup.addElement(secondButton);
		}
		
		override protected function updateDisplayList(w:Number,h:Number):void
		{
			super.updateDisplayList(w, h);
			
			graphics.clear();
			var g:Graphics = graphics;
			//g.lineStyle(0.1,0xaaaaaa/*borderColors[0]*/);
			//g.beginFill(0xE4E4E4,1);
			//g.beginFill(0xf2f5f7,1);//0x02DAAE
			//g.drawRoundRect(0,0,w,h,0,0);
			//g.endFill();
			//g.lineStyle();
			//drawRoundRect(
				//0, 0, w, 28,{tl:/*cornerRadius-1*/0,tr:/*cornerRadius-1*/0,bl:0,br:0},
				///*[0xf6f8f8,0xe9eeee]*/[0x02DAAE,0x02DAAE/*0xAEAFB0*/], 1,
				//verticalGradientMatrix(1, 1, w, 28)); 
			//drawLine(0,28,w,28,0xAEAFB0);
			//drawLine(1,29,w,29,0x555555);
			this.alpha = currentState == "disabled"?0.5:1;
			
			//extension-2014-7-31
			//g.beginFill(0xf2f5f7);
			g.beginFill(0xcccccc);
			g.drawRect(0, 0, w, h);
			g.endFill();
			
			var hw:Number = w >> 1;
			var hh:Number = 2 / 3 * h;
			
			//g.beginFill(0x02DAAE);
			g.beginFill(0x666666);
			g.drawRect(0, hh, w, h-hh);
			g.endFill();

			//g.beginFill(0xf2f5f7);
			g.beginFill(0xcccccc);
			g.moveTo( hw - 8, hh );
			g.lineTo( hw + 8, hh );
			g.lineTo( hw, hh + 8 );
			g.lineTo( hw - 8, hh );
			g.endFill();
		}
	}
}