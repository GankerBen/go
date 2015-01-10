package tetequ.live.modules.room.userlist.view 
{
	import com.e2et.datalogic.User;
	import org.flexlite.domUI.components.Button;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.components.Rect;
	import org.flexlite.domUI.components.ToggleButton;
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.domUI.layouts.HorizontalLayout;
	import org.flexlite.domUI.skins.vector.ButtonSkin;
	import org.flexlite.domUI.skins.vector.ToggleButtonSkin;
	import org.flexlite.skin.InviteButtonSkin;
	import org.flexlite.skin.MikeToggleButtonSkin;
	import org.flexlite.skin.OpenButtonSkin;
	import org.flexlite.skin.ShengyinToggleSkin;
	import org.flexlite.skin.ShipinToggleSkin;
	import org.flexlite.skin.VideoToggleButtonSkin;
	import tetequ.live.core.assets.AssetsFactory;
	import tetequ.live.modules.room.common.GlobalVars;
	import tetequ.live.modules.room.userlist.model.UserInfoItemVo;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 用户列表的一项
	 */
	public class UserInfoItemView extends Group 
	{
		/**
		 * 用户名文本
		 */
		private var _username:Label;
		
		/**
		 * 菜单栏
		 */
		private var _btnGroup:Group;
		
		/**
		 * 打开菜单栏的按钮
		 */
		private var _btnOpen:UIAsset;
		
		/**
		 * 表示麦克风状态的按钮(不可点击)
		 */
		private var _mikeToggle:UIAsset;
		
		/**
		 * 表示摄像头状态的按钮(不可点击)
		 */
		private var _cameraToggle:UIAsset;
		
		/**
		 * 用于布局的容器组，包含打开菜单栏的按钮+麦克风状态+摄像头状态
		 */
		private var _group1:Group;
		
		/**
		 * 用户相关数据
		 */
		private var _vo:User;
		
		/**
		 * 背景条
		 */
		private var _bg:Rect;
		
		/**
		 * 邀请发言
		 */
		private var _btnInvite:UIAsset;
		
		/**
		 * 权限图标
		 */
		private var _levelIcon:UIAsset;
		
		/**
		 * 状态栏组(是否有摄像头、麦克风)
		 */
		private var _statsGroup:Group;
		
		/**
		 * 构造函数
		 */
		public function UserInfoItemView( itemVo:User ) 
		{
			super();
			
			_vo = itemVo;
			
			initComponents();
		}
		
		/**
		 * 初始化组件
		 */
		private function initComponents():void 
		{
			this.percentWidth = 100;
			
			addElement( _bg = new Rect() );
			_bg.verticalCenter = 0;
			_bg.percentWidth = 100;
			_bg.height = 30;
			_bg.fillColor = 0xcccccc;
			_bg.fillAlpha = 0;
			
			addElement(_levelIcon = new UIAsset());
			_levelIcon.left = 10;
			_levelIcon.verticalCenter = 0;
			
			if (vo.level & 0x80)
			{
				_levelIcon.skinName = AssetsFactory.getInstance().getAsset('teacherSkin');
				langTipsConfigure(_levelIcon, '我是老师，点我私聊吧:)', "I'm teacher,chat me:)");
				
			}else
			{
				_levelIcon.skinName = AssetsFactory.getInstance().getAsset('studentSkin');
				langTipsConfigure(_levelIcon, '我是学生，点我私聊吧:)', "I'm student,chat me:)");
			}
			
			var color:uint = (vo.level & 0x80) ? 0xff3300 : 0x999999;
			
			addElement( _username = new Label() );
			_username.text = _vo.name;
			_username.textColor = color;
			_username.bold = true;
			_username.size = 13;
			_username.verticalCenter = 0;
			_username.left = 45;
			_username.fontFamily = "微软雅黑";

			addElement( _btnInvite = new UIAsset() );
			_btnInvite.maintainAspectRatio = true;
			_btnInvite.mouseChildren = true;
			_btnInvite.skinName = AssetsFactory.getInstance().getAsset('InviteButtonSkin');
			_btnInvite.right = 25;
			_btnInvite.verticalCenter = 0;
			
			langTipsConfigure(_btnInvite, '打开他(她)的视频以分享给所有人', 'open her/his devices to share');
			
			addElement(_statsGroup = new Group());
			_statsGroup.layout = new HorizontalLayout();
			_statsGroup.verticalCenter = 0;
			_statsGroup.horizontalCenter = 0;
			HorizontalLayout(_statsGroup.layout).gap = 5;
			
			_statsGroup.addElement( _mikeToggle = new UIAsset() );
			_mikeToggle.skinName = AssetsFactory.getInstance().getAsset('ShengyinToggleSkin');
			_mikeToggle.mouseChildren = true;
			_mikeToggle.maintainAspectRatio = true;
			_mikeToggle.$selected = false;

			langTipsConfigure(_mikeToggle, '该用户有麦克风', "The user has a microphone");
			
			_statsGroup.addElement( _cameraToggle = new UIAsset() );
			_cameraToggle.skinName = AssetsFactory.getInstance().getAsset('ShipinToggleSkin');
			_cameraToggle.mouseChildren = true;
			_cameraToggle.maintainAspectRatio = true;
			_cameraToggle.$selected = true;

			langTipsConfigure(_cameraToggle, '该用户有摄像头', "The user has camera");
			
			this.hasCam = _vo.hasCam;
			this.hasMic = _vo.hasMic;
		}
		
		
		
		public function set selected( value:Boolean ):void
		{
			_bg.fillAlpha = value ? 1 : 0;
		}
		
		/**
		 * 获取用户数据
		 */
		public function get vo():User 
		{
			return _vo;
		}
		
		private var _hasMic:Boolean;
		public function set hasMic( value:Boolean ):void
		{
			_hasMic = value;
			if(value)
			{
				_mikeToggle.visible = true;
			}else
			{
				_mikeToggle.visible = false;
			}
			
			update();
		} 
		
		private var _hasCam:Boolean;
		public function set hasCam( value:Boolean ):void
		{
			_hasCam = value;
			if(value)
			{
				_cameraToggle.visible = true;
			}else
			{
				_cameraToggle.visible = false;
			}
			
			update();
		}
		
		private function update():void
		{
			if (_hasMic || _hasCam)
			{
				if (!_btnInvite.visible)
				{
					_btnInvite.visible = true;
				}
			}else
			{
				if (_btnInvite.visible)
				{
					_btnInvite.visible = false;
				}
			}
		}
		
		public function get btnInvite():UIAsset 
		{
			return _btnInvite;
		}
		public function get mikeToggle():UIAsset 
		{
			return _mikeToggle;
		}
		public function get cameraToggle():UIAsset 
		{
			return _cameraToggle;
		}
		
		public function get levelIcon():UIAsset 
		{
			return _levelIcon;
		}
		
	}

}