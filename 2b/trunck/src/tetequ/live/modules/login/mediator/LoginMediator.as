package tetequ.live.modules.login.mediator 
{
	import flash.events.MouseEvent;
	import org.flexlite.domUI.components.Alert;
	import org.flexlite.domUI.events.ListEvent;
	import robotlegs.bender.bundles.mvcs.Mediator;
	import tetequ.live.core.network.events.ConnectServerEvent;
	import tetequ.live.modules.login.events.RemoveLoginEvent;
	import tetequ.live.modules.login.model.LoginVo;
	import tetequ.live.modules.login.view.LoginView;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class LoginMediator extends Mediator 
	{
		[Inject]
		public var view:LoginView;
		
		public function LoginMediator()
		{
			super();
		}
		
		override public function initialize():void
		{
			super.initialize();
			view.btnEnter.addEventListener( MouseEvent.CLICK, onClick );
		}
		
		private function onClick(e:MouseEvent):void 
		{
			switch( e.currentTarget )
			{
				case view.btnEnter:
					if ( view.list.selectedIndex == -1 )
					{
						Alert.show( "请选择权限!" );
						return;
					}
					
					if ( view.roomIdList.selectedIndex == -1 )
					{
						Alert.show( "请选择房间号！" );
						return;
					}
					
					var username:String = view.input;
					if ( username == "" || username == null )
					{
						Alert.show( "请输入用户名!" );
						return;
					}
					
					var loginVo:LoginVo = new LoginVo();
					loginVo.username = username;
					loginVo.userid = username;
					
					var selectIndex:int = view.list.selectedIndex;
					if ( selectIndex == 0 )
					{
						loginVo.userlevel = 0x82;
					}else {
						loginVo.userlevel = 0x41;
					}
					
					loginVo.roomid = String(view.roomIdList.selectedItem).substring(0,2);//FIXME:内部测试用
					trace(loginVo.roomid);
					dispatch( new RemoveLoginEvent() );
					dispatch( new ConnectServerEvent( loginVo, ConnectServerEvent.CONNECT_SERVER ) );
					break;
				default:
					break;
			}
		}
		
		override public function destroy():void
		{
			super.destroy();
		}	
	}
}