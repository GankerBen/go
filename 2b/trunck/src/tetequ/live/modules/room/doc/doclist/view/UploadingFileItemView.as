package tetequ.live.modules.room.doc.doclist.view 
{
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.components.Rect;
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.domUI.layouts.VerticalLayout;
	import tetequ.live.core.assets.AssetsFactory;
	import tetequ.live.modules.room.common.GlobalVars;
	import tetequ.live.modules.room.doc.common.IFileInfo;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 正在上传的文件项
	 */
	public class UploadingFileItemView extends Group
	{
		/**
		 * 文件图标
		 */
		private var _icon:UIAsset;
		
		/**
		 * 文件名称
		 */
		private var _fileName:String;
		
		/**
		 * 文件类型
		 */
		private var _fileType:String;
		
		/**
		 * 文档名文本
		 */
		private var _labelName:Label;
		
		/**
		 * 上传过程显示文本
		 */
		private var _labelProgress:Label;
		
		/**
		 * 构造函数
		 * @param	fileName	文件名
		 * @param	fileType	文件扩展名
		 */
		public function UploadingFileItemView( fileName:String, fileType:String ) 
		{
			_fileName = fileName;
			_fileType = fileType;
			
			initComponents();
		}
		
		/**
		 * 初始化组件
		 */
		private function initComponents():void 
		{
			this.layout = new VerticalLayout();
			
			addElement( _icon = new UIAsset() );
			_icon.skinName = getICONUrl( _fileType );
			
			addElement( _labelProgress = new Label() );
			_labelProgress.text = "正在打开文件...";
			_labelProgress.width = 50;
			_labelProgress.height = 25;
			
			this.toolTip = "正在上传文件 " + _fileName;
		}
		
		/**
		 * 根据文件类型获取对应的图标
		 * @param	fileType
		 * @return
		 */
		private function getICONUrl( fileType:String ):*
		{
			//"*.ttq;*.swf;*.flv;*.mp4;*.mp3;*.aac;*.doc;*.docx;*.ppt;*.pptx;*.pdf;*.JPG;*.jpg;*.gif;*.png;*.f4v"
			return GlobalVars.getIcon(fileType);
		}
		
		/**
		 * 刷新上传进度
		 * @param	bytesLoaded
		 * @param	bytesTotal
		 */
		public function updateProgress( bytesLoaded:Number, bytesTotal:Number ):void
		{
			if ( bytesLoaded == bytesTotal )
			{
				if (GlobalVars.language == GlobalVars.LANG_ENGLISH)
				{
					//英文
					_labelProgress.text = "translating...";
					this.toolTip = "translating... ";
				}else if(GlobalVars.language == GlobalVars.LANG_CHINESE)
				{
					//中文
					_labelProgress.text = "正在转换...";
					this.toolTip = "正在转换... ";
				}
			}else 
			{
				_labelProgress.text = int((bytesLoaded / bytesTotal) * 100) + "%";
			}
		}
		
		public function get fileName():String 
		{
			return _fileName;
		}
		
	}

}