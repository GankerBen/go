package tetequ.live.modules.room.doc.players.docx.common 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import org.flexlite.domUI.components.Button;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.components.Rect;
	import org.flexlite.domUI.components.TextInput;
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.domUI.events.ResizeEvent;
	import org.flexlite.domUI.skins.vector.ButtonSkin;
	import org.flexlite.domUI.skins.vector.TextInputSkin;
	import org.flexlite.skin.PrevSkin;
	import tetequ.live.core.assets.AssetsFactory;
	import tetequ.live.modules.room.doc.players.common.view.VisualPlayer;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 文档播放器基类(包括普通文档[DOCX族文档]、PPT)
	 */
	public class MasterDocumentPlayer extends VisualPlayer
	{
		protected var btnPrev:UIAsset;					//翻页导航区域-上一页按钮
		protected var btnNext:UIAsset;					//翻页导航区域-下一页按钮
		
		protected var inputPageNum:TextInput;			//翻页导航区域-页码输入框
		protected var labelPageTotal:Label;				//翻页导航区域-总页码文本
		protected var labelSlash:Label;					//翻页导航区域-斜线文本
		protected var naviBackground:Rect;			//翻页导航区域-背景框
		protected var naviContainer:Group;				//翻页导航区域-容器
		protected var numberAss:UIAsset;
		protected var numberBoot:UIAsset;               //底部数字;
		protected var flipPlots:UIAsset ;               //翻页地块
		/**
		 * 构造函数
		 */
		public function MasterDocumentPlayer() 
		{
			super();
		}
		
		/* -------------------------------------播放器UI控件对外接口----------------------------------- */
		
		public function getBtnPrev():UIAsset 
		{
			return btnPrev;
		}
		
		public function getBtnNext():UIAsset
		{
			return btnNext;
		}
		
		public function getInputPageNum():TextInput
		{
			return inputPageNum;
		}
		
		public function getLabelPageTotal():Label
		{
			return labelPageTotal;
		}
		
		/*	---------------------------------------初始化播放器组件------------------------------------ */

		override protected function initComponents():void
		{
			super.initComponents();
			
			//整个播放器水平、垂直居中
			this.horizontalCenter = 0;
			this.verticalCenter = 0;
			
			//翻页导航区域-容器
			addElement( naviContainer = new Group() );
			naviContainer.horizontalCenter = 0;
			naviContainer.bottom = 0;
			naviContainer.percentWidth = 100;
			
			//翻页导航区域-背景框
			naviBackground = new Rect();
			naviBackground.fillColor = 0Xcccccc;
			naviBackground.height = 40;
			naviBackground.percentWidth = 100;
			//naviBackground.fillAlpha = 0;
			
			
			//翻页导航区域-上一页按钮
			btnPrev = new UIAsset();
			btnPrev.maintainAspectRatio = true;
			btnPrev.mouseChildren = true;
			btnPrev.skinName = AssetsFactory.getInstance().getAsset('prevPageButton');
			btnPrev.horizontalCenter = -60;
			btnPrev.bottom = 5;
			
			//翻页导航区域-下一页按钮
			btnNext = new UIAsset();
			btnNext.maintainAspectRatio = true;
			btnNext.mouseChildren = true;
			btnNext.skinName = AssetsFactory.getInstance().getAsset('prevPageButton');
			btnNext.scaleX = -1;
			btnNext.horizontalCenter = 60;
			btnNext.bottom = 5;
			
			
			//翻页导航区域-页码输入框
			inputPageNum = new TextInput();
			inputPageNum.skinName = TextInputSkin;
			inputPageNum.horizontalCenter = -4;
			inputPageNum.verticalCenter = 0;
			inputPageNum.maxChars = 4;
			inputPageNum.restrict = "0123456789";
			inputPageNum.width = 35;
			
			//翻页导航区域-斜线文本
			labelSlash = new Label();
			labelSlash.text = "/";
			labelSlash.horizontalCenter = 0;
			labelSlash.verticalCenter = 0;
			
			//翻页导航区域-总页码显示文本
			labelPageTotal = new Label();
			labelPageTotal.text = "1";
			labelPageTotal.horizontalCenter = 13;
			labelPageTotal.verticalCenter = 0;
			
			
			naviContainer.addElement( naviBackground );
			naviContainer.addElement( btnPrev );
			naviContainer.addElement( btnNext );
			naviContainer.addElement( inputPageNum );
			naviContainer.addElement( labelSlash );
			naviContainer.addElement( labelPageTotal );
		}

	}

}