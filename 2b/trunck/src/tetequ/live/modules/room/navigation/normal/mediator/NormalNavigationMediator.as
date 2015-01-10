package tetequ.live.modules.room.navigation.normal.mediator 
{
	import com.e2et.datalogic.AVStream;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import framework.view.UIRoot;
	import org.flexlite.domUI.components.Alert;
	import robotlegs.bender.bundles.mvcs.Mediator;
	import tetequ.live.core.network.NetworkFacade;
	import tetequ.live.modules.room.avdocument.DeviceSettingManager;
	import tetequ.live.modules.room.common.GlobalVars;
	import tetequ.live.modules.room.common.panel.PanelID;
	import tetequ.live.modules.room.common.panel.PanelManager;
	import tetequ.live.modules.room.navigation.common.events.OpenIncPowerEvent;
	import tetequ.live.modules.room.navigation.common.events.OpenContactUSEvent;
	import tetequ.live.modules.room.navigation.common.events.OpenHelpEvent;
	import tetequ.live.modules.room.navigation.normal.view.NormalNavigationView;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class NormalNavigationMediator extends Mediator 
	{
		[Inject]
		public var view:NormalNavigationView;
		
		[Inject]
		public var networkFacade:NetworkFacade;
		
		[Inject]
		public var panelManager:PanelManager;
		
		[Inject]
		public var uiroot:UIRoot;
		
		public function NormalNavigationMediator() 
		{
			super();
			
		}
		
		/**
		 * 初始化
		 */
		override public function initialize():void
		{
			super.initialize();

			this.view.btnAVReq.addEventListener( MouseEvent.CLICK, onClick );
			this.view.btnSysSettings.addEventListener( MouseEvent.CLICK, onClick );
			DeviceSettingManager.getInstance().network = networkFacade;
		}
		
		/**
		 * 按钮点击
		 * @param	e
		 */
		private function onClick(e:MouseEvent):void 
		{
			switch( e.currentTarget )
			{
				case this.view.btnAVReq:
					if (uiroot.containsElement(DeviceSettingManager.getInstance())) return;
					DeviceSettingManager.getInstance().startup(false, true);
					DeviceSettingManager.getInstance().publish();
					break;
				case this.view.btnSysSettings :
					
					if (uiroot.containsElement(DeviceSettingManager.getInstance()))
					{
						uiroot.removeElement(DeviceSettingManager.getInstance());
					}else
					{
						uiroot.addElement(DeviceSettingManager.getInstance());
						DeviceSettingManager.getInstance().startup(true);
					}
					break;
				default:
					break;
			}
		}
		
		
		
		/**
		 * 清除操作
		 */
		override public function destroy():void
		{
			super.destroy();
			this.view.btnAVReq.removeEventListener( MouseEvent.CLICK, onClick );
			this.view.btnSysSettings.removeEventListener( MouseEvent.CLICK, onClick );
		}
		
	}

}