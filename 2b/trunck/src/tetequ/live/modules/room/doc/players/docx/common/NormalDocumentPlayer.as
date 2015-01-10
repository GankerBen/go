package tetequ.live.modules.room.doc.players.docx.common 
{
	import flash.display.Sprite;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.components.Rect;
	import org.flexlite.domUI.components.UIAsset;
	import tetequ.live.modules.room.doc.players.common.view.VisualPlayer;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 普通文档播放器的基类
	 */
	public class NormalDocumentPlayer extends VisualPlayer 
	{
		protected var _labelCurPage:Label;				//翻页导航区域-当前页数文本
		protected var _labelPageTotal:Label;				//翻页导航区域-总页数文本
		protected var labelSlash:Label;					//翻页导航区域-斜线文本
		protected var naviBackground:Rect;			//翻页导航区域-背景框
		protected var naviContainer:Group;				//翻页导航区域-容器
		
		/**
		 * 构造函数
		 */
		public function NormalDocumentPlayer()
		{
			super();
		}
		
		/**
		 * 初始化组件
		 */
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
			naviBackground.fillColor = 0xcccccc;
			naviBackground.height = 40;
			naviBackground.percentWidth = 100;
			
			//翻页导航区域-当前页数
			_labelCurPage = new Label();
			_labelCurPage.text = "0";
			_labelCurPage.horizontalCenter = -35;
			_labelCurPage.verticalCenter = 0;
			
			//翻页导航区域-斜线文本
			labelSlash = new Label();
			labelSlash.text = "/";
			labelSlash.horizontalCenter = 0;
			labelSlash.verticalCenter = 0;
			
			//翻页导航区域-总页码显示文本
			_labelPageTotal = new Label();
			_labelPageTotal.text = "1";
			_labelPageTotal.horizontalCenter = 35;
			_labelPageTotal.verticalCenter = 0;
			
			naviContainer.addElement( naviBackground );
			naviContainer.addElement( _labelCurPage );
			naviContainer.addElement( labelSlash );
			naviContainer.addElement( _labelPageTotal );
		}
		
		public function get labelPageTotal():Label 
		{
			return _labelPageTotal;
		}
		
		public function get labelCurPage():Label 
		{
			return _labelCurPage;
		}
		
	}

}