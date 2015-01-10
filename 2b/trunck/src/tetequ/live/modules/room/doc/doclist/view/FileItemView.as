package tetequ.live.modules.room.doc.doclist.view 
{
	import flash.events.MouseEvent;
	import org.flexlite.domUI.components.Alert;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.components.Rect;
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.domUI.events.CloseEvent;
	import org.flexlite.domUI.layouts.VerticalLayout;
	import tetequ.live.core.assets.AssetsFactory;
	import tetequ.live.modules.room.common.GlobalVars;
	import tetequ.live.modules.room.doc.common.IFileInfo;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 单个文件的icon
	 */
	public class FileItemView extends Group 
	{
		/**
		 * 图标显示对象包装器
		 */
		private var _icon:UIAsset;
		
		/**
		 * 图标皮肤
		 */
		private var _iconSkinName:String;
		
		/**
		 * 文件名
		 */
		private var _labelName:Label;
		
		/**
		 * 文件部分信息
		 */
		private var _itemVo:IFileInfo;
		
		//删除按钮
		private var _btnDelete:UIAsset;
		
		private var _group:Group;
		
		/**
		 * 构造函数
		 */
		public function FileItemView( itemVo:IFileInfo ) 
		{
			super();
			
			_itemVo = itemVo;
			trace(_itemVo.path);
			
			
			initComponents();
		}
		
		/**
		 * 初始化组件
		 */
		private function initComponents():void 
		{
			
			addElement(_group = new Group());
			_group.layout = new VerticalLayout();
			
			_group.addElement( _icon = new UIAsset() );
			_icon.skinName = getICONUrl( getType(_itemVo.name) );
			//_icon.skinName = "app/web/assets/uilib/iconmov.png";
			
			_group.addElement( _labelName = new Label() );
			_labelName.text = _itemVo.name;
			_labelName.textColor = 0x777b80;
			_labelName.height = 25;
			_labelName.width = 50;
			
			addElement(_btnDelete = new UIAsset());
			_btnDelete.visible = false;
			_btnDelete.top = 2;
			_btnDelete.right = 2;
			_btnDelete.skinName = AssetsFactory.getInstance().getAsset('CloseButtonSkin');
			_btnDelete.scaleX = _btnDelete.scaleY = 0.6;
			_btnDelete.addEventListener(MouseEvent.CLICK, onDelete, false, 10000);
			
			this.addEventListener(MouseEvent.MOUSE_OVER, showDeleteButton);
			this.addEventListener(MouseEvent.ROLL_OVER, showDeleteButton);
			this.addEventListener(MouseEvent.MOUSE_OUT, hideDeleteButton);
			this.addEventListener(MouseEvent.ROLL_OUT, hideDeleteButton);
			
			this.toolTip = _itemVo.name;
			this.id = _itemVo.id;
		}
		
		private function hideDeleteButton(e:MouseEvent):void 
		{
			_btnDelete.visible = false;
		}
		
		private function showDeleteButton(e:MouseEvent):void 
		{
			_btnDelete.visible = true;
		}
		
		private function onDelete(e:MouseEvent):void 
		{
			e.stopImmediatePropagation();
			
			if (GlobalVars.language == GlobalVars.LANG_ENGLISH)
			{
				//英文
				Alert.show("Are you really delete it？", '', onClose, "确定", "取消");
			}else if(GlobalVars.language == GlobalVars.LANG_CHINESE)
			{
				//中文
				Alert.show("你想要删除该文件吗？", '', onClose, "确定", "取消");
			}else
			{
				throw new Error('无法识别的语言！');
			}
				
			function onClose( e:CloseEvent ):void
			{
				switch( CloseEvent(e).detail )
				{
					case Alert.FIRST_BUTTON:
						GlobalVars.webServer.deleteFile(_itemVo.id, onDeleteResult);
						break;
					case Alert.SECOND_BUTTON:case Alert.CLOSE_BUTTON:
						break;
					default:
						break;
				}
			}
		}
		
		/**
		 * 删除结果回调
		 */
		private function onDeleteResult(id:String):void 
		{
			if (id == _itemVo.id)
			{
				this.removeEventListener(MouseEvent.MOUSE_OVER, showDeleteButton);
				this.removeEventListener(MouseEvent.ROLL_OVER, showDeleteButton);
				this.removeEventListener(MouseEvent.MOUSE_OUT, hideDeleteButton);
				this.removeEventListener(MouseEvent.ROLL_OUT, hideDeleteButton);
				if(this.parent)
					Group(this.parent).removeElement(this);
			}
		}
		
		/**
		 * 根据文档名获取文档类型
		 * @param	name
		 * @return
		 */
		private static function getType(name:String):String
		{
			var dotIndex:int = name.lastIndexOf('.');
			return name.substring(dotIndex, name.length);
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
		
		public function get itemVo():IFileInfo 
		{
			return _itemVo;
		}
	}
}