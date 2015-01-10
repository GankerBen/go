package tetequ.live.modules.room.remotelogin.view 
{
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.components.Rect;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 用户帐号在别处登陆时提醒
	 */
	public class RemoteLoginWarningView extends Group 
	{
		private var _bg:Rect;
		private var _txt:Label;
		
		public function RemoteLoginWarningView() 
		{
			super();
			initComponents();
		}
		
		private function initComponents():void 
		{
			this.percentWidth = 100;
			this.percentHeight = 100;
			
			_bg = new Rect();
			_bg.fillColor = 0x000000;
			_bg.percentWidth = 100;
			_bg.percentHeight = 100;
			addElement( _bg );
			
			addElement( _txt = new Label() );
			_txt.text = "对不起，您已经离线，因为您的帐号已经在别处登陆了...";
			_txt.size = 25;
			_txt.textColor = 0x00ff00;
			_txt.horizontalCenter = 0;
			_txt.verticalCenter = 0;
		}
		
	}

}