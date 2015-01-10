package tetequ.live.modules.room.avreq.mediator 
{
	import com.e2et.datalogic.AVReq;
	import com.e2et.datalogic.User;
	import org.flexlite.domUI.components.Alert;
	import robotlegs.bender.bundles.mvcs.Mediator;
	import tetequ.live.core.network.NetworkFacade;
	import tetequ.live.modules.room.avreq.events.AddAVReqEvent;
	import tetequ.live.modules.room.avreq.view.AVReqView;
	import tetequ.live.modules.room.common.GlobalVars;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class AVReqMediator extends Mediator 
	{
		[Inject]
		public var view:AVReqView;
		
		[Inject]
		public var networkFacade:NetworkFacade;
		
		public function AVReqMediator() 
		{
			super();
			
		}
		
		override public function initialize():void
		{
			super.initialize();
			this.addContextListener( AddAVReqEvent.ADD, onAVReqAdd, AddAVReqEvent );
			this.addContextListener( AddAVReqEvent.DEL, onAVReqDel, AddAVReqEvent );
		}
		
		private function onAVReqDel(e:AddAVReqEvent):void 
		{
			this.view.delAVReq( e.avReq );
		}
		
		private function onAVReqAdd(e:AddAVReqEvent):void 
		{
			this.view.addAVReq( e.avReq, yesCallback, noCallback );
		}
		
		private function yesCallback( avReq:AVReq ):void
		{
			networkFacade.delAvReq( avReq, networkFacade.user );
			this.view.delAVReq( avReq );
			if ( networkFacade.avListLength >= GlobalVars.max_av_num )
			{
				Alert.show( "对不起，您不能邀请该用户发言，因为本房间最多允许同时有 " +GlobalVars.max_av_num + " 人发言！" );
				noCallback(avReq);
				return;
			}
			networkFacade.sendRPC( avReq.user, 'invitedPublish' );
		}
		
		private function noCallback( avReq:AVReq ):void
		{
			//trace( avReq.user.sid, "--------------------------------" );
			//var info:* = { };
			networkFacade.sendRPC( avReq.user, 'refuseAVReq' );
			networkFacade.delAvReq( avReq, networkFacade.user );
			this.view.delAVReq( avReq );
		}
		
		override public function destroy():void
		{
			super.destroy();
			this.removeContextListener( AddAVReqEvent.ADD, onAVReqAdd, AddAVReqEvent );
			this.removeContextListener( AddAVReqEvent.DEL, onAVReqDel, AddAVReqEvent );
		}
		
	}

}