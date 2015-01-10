package tetequ.live.modules.room.chat.privates.view 
{
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import org.flexlite.domUI.components.Button;
	import org.flexlite.domUI.components.EditableText;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Rect;
	import org.flexlite.domUI.components.TextInput;
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.domUI.layouts.HorizontalLayout;
	import org.flexlite.domUI.skins.vector.ButtonSkin;
	import org.flexlite.domUI.skins.vector.TextInputSkin;
	import org.flexlite.domUI.skins.VectorSkin;
	import org.flexlite.domUI.utils.callLater;
	import org.flexlite.skin.PhizButtonSkin;
	import org.flexlite.skin.PhizButtonsSkin;
	import org.flexlite.skin.SendButtonSkin;
	import org.flexlite.skin.SendButtonsSkin;
	import tetequ.live.core.assets.AssetsFactory;
	import tetequ.live.modules.room.chat.common.face.FaceSelector;
	import tetequ.live.modules.room.common.GlobalVars;
	import tetequ.live.modules.room.common.layouts.LayoutElementsID;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 群聊天输入框界面
	 */
	public class PrivateInputView extends Group 
	{
		/**
		 * 表情按钮
		 */
		private var _btnPhiz:UIAsset;
		
		/**
		 * 输入框
		 */
		private var _input:TextInput;
		
		/**
		 * 发送按钮
		 */
		private var _btnSend:UIAsset;
		
		//布局容器
		private var _layoutGroup:Group;
		
		//背景
		private var _bg:VectorSkin;
		
		//表情
		private var _faceSelector:FaceSelector;
		
		//是否已经加载表情素材
		private var _hasFace:Boolean;
		
		/**
		 * 构造函数
		 */
		public function PrivateInputView() 
		{
			super();
			initComponents();
		}
		
		/**
		 * 初始化组件
		 */
		private function initComponents():void 
		{
			addElement( _bg = new VectorSkin() );
			_bg.percentWidth = 100;
			_bg.graphics.beginFill(0x333333);
			_bg.graphics.drawRoundRect(0, 0, 200, 32, 5, 5);
			_bg.graphics.endFill();
			_bg.left = 48;
			_bg.right = 41;
			_bg.bottom = 30;
			
			addElement( _layoutGroup = new Group() );
			_layoutGroup.layout = new HorizontalLayout();
			_layoutGroup.percentWidth = 100;
			_layoutGroup.left = 20;
			_layoutGroup.right = 60;
			_layoutGroup.verticalCenter = 0;
	
			this.addElement( _btnPhiz = new UIAsset() );
			_btnPhiz.maintainAspectRatio = true;
			_btnPhiz.mouseChildren = true;
			_btnPhiz.skinName = AssetsFactory.getInstance().getAsset('PhizButtonSkin');
			_btnPhiz.left = 8;
			_btnPhiz.bottom = -3;
			
			this.addElement( _input = new TextInput() );
			_input.skinName = TextInputSkin;
			
			if (GlobalVars.language == GlobalVars.LANG_ENGLISH)
			{
				//英文
				_input.prompt = "Please enter text";
			}else if(GlobalVars.language == GlobalVars.LANG_CHINESE)
			{
				//中文
				_input.prompt = "请输入文字";

			}else
			{
				throw new Error('无法识别的语言！');
			}
			
			_input.left = 53;
			_input.right = 60;
			_input.bottom = 2;
			
			_input.textColor = 0x888888;
			
			this.addEventListener( MouseEvent.MOUSE_DOWN, onFocusIn );
			
			this.addElement( _btnSend = new UIAsset() );
			_btnSend.maintainAspectRatio = true;
			_btnSend.mouseChildren = true;
			_btnSend.skinName = AssetsFactory.getInstance().getAsset('SendButtonSkin');
			_btnSend.right = 13;
			_btnSend.bottom = -3;
			
			
			_faceSelector = new FaceSelector()
			_faceSelector.y = -24 * (GlobalVars.MAX_FACE_INDEX/3) + 88;
			
			this.percentWidth = 100;
			this.height = 34;
		}
		
		private function onFocusIn(e:MouseEvent):void 
		{
			if ( _onFocusIn != null )
			{
				_onFocusIn.apply();
			}
		}
		
		private var _onFocusIn:Function;
		
		public function setOnFocusIn( callback:Function ):void
		{
			_onFocusIn = callback;
		}
		
		public function get btnPhiz():UIAsset 
		{
			return _btnPhiz;
		}
		
		public function get input():TextInput 
		{
			return _input;
		}
		
		public function get btnSend():UIAsset 
		{
			return _btnSend;
		}
		
		public function registerFace( face:UIAsset ):void
		{
			if ( !_hasFace )
				_hasFace = true;
			_faceSelector.registerFace( face );
		}
		
		public function showFaceSelector():void
		{
			if ( !containsElement(_faceSelector))
			{
				addElement( _faceSelector );
			}else
			{
				hideFaceSelector();
			}
		}
		
		public function hideFaceSelector():void
		{
			if ( containsElement(_faceSelector))
			{
				removeElement( _faceSelector );
			}
		}
		
		public function get hasFace():Boolean 
		{
			return _hasFace;
		}
		
		public function get faceSelector():FaceSelector 
		{
			return _faceSelector;
		}
		
	}

}