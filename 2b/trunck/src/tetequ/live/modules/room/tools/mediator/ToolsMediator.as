package tetequ.live.modules.room.tools.mediator 
{
	import com.e2et.datalogic.AVStream;
	import com.e2et.ScreenCap;
	import flash.events.MouseEvent;
	import framework.view.UIRoot;
	import org.flexlite.domUI.components.Alert;
	import org.flexlite.domUI.events.CloseEvent;
	import robotlegs.bender.bundles.mvcs.Mediator;
	import tetequ.live.core.network.NetworkFacade;
	import tetequ.live.modules.room.common.GlobalVars;
	import tetequ.live.modules.room.common.panel.PanelID;
	import tetequ.live.modules.room.common.panel.PanelManager;
	import tetequ.live.modules.room.error.FrozenLayer;
	//import tetequ.live.modules.room.stream.video.master.event.CloseScreenCaptureEvent;
	import tetequ.live.modules.room.tools.ToolsCache;
	import tetequ.live.modules.room.tools.view.ToolsView;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class ToolsMediator extends Mediator 
	{
		[Inject]
		public var view:ToolsView;
		
		[Inject]
		public var networkFacade:NetworkFacade;
		
		[Inject]
		public var panelManager:PanelManager;
		
		[Inject]
		public var frozen:FrozenLayer;
		
		[Inject]
		public var uiroot:UIRoot;
		
		private var _screenData:*;

		public function ToolsMediator() 
		{
			super();
			
		}

		override public function initialize():void
		{
			super.initialize();
			this.view.btnRecording.addEventListener( MouseEvent.CLICK, onClick );
		}
		
		/**
		 * 关闭屏幕共享插件
		 * @param	e
		 */
		//private function onScreenCaptureClose( e:CloseScreenCaptureEvent=null ):void 
		//{
			//trace("关闭屏幕共享插件");
			//if(ToolsCache.userData['av'])
				//delete ToolsCache.userData['av'];
			//disposeScreenCapture();
		//}

		private function onClick(e:MouseEvent):void 
		{
			switch( e.currentTarget )
			{
				//case this.view.btnScreenShare:
					//if (_screenData)
					//{
						//Alert.show("您正在共享屏幕！");
					//}else
					//{
						//if (!networkFacade.hasToken)
						//{
							//Alert.show("您没有权限，不能开启屏幕共享！");
							//return;
						//}
						//
						//if ( networkFacade.avListLength >= GlobalVars.max_av_num )
						//{
							//Alert.show( "对不起，您不能发言，因为本房间最多允许同时有 " +GlobalVars.max_av_num + " 人发言！" );
							//return;
						//}
						//
						//var num:int;
						//if( networkFacade.user.hasStream )
						//{
							//for each( var avstm:AVStream in networkFacade.user.streams )
							//{
								//if ( avstm.user.userid == networkFacade.userId )
								//{
									//num++;
								//}
							//}
							//
							//if (num == 2)
							//{
								//if (GlobalVars.language == GlobalVars.LANG_ENGLISH)
								//{
									//英文
									//Alert.show("You already has two video now！");
								//}else if(GlobalVars.language == GlobalVars.LANG_CHINESE)
								//{
									//中文
									//Alert.show( "您已经占用了两路视频，不能更多！" );
								//}else
								//{
									//throw new Error('无法识别的语言！');
								//}
								//
								//return;
							//}
						//}
						//
						//_screenData = networkFacade.newScreenCapture( screenCaptureCallback, Math.random() * 1000000, {id:Math.random() * 2000000} );
						//frozen.show("正在设置屏幕共享...", uiroot);
					//}
					//
					//this.view.visible = false;
					//break;
				case this.view.btnRecording:
					//if (!networkFacade.hasToken)
					//{
						//Alert.show("您没有权限使用录制功能!");
						//return;
					//}
					//
					//FIXME:此处还应该判断videoId
					//
					//if (networkFacade.recording)
					//{
						//Alert.show("当前正在录制中...");
						//return;
					//}
					//
					//networkFacade.startRecord(Math.random().toString());
					//var videoId:String = GlobalVars.videoId;
					//if (!videoId)
					//{
						//非平台下使用
						//videoId = Math.random().toString();
					//}
//
					//networkFacade.startRecord(videoId);
					break;
				default:
					break;
			}
		}
		
		/**
		 * 屏幕共享插件的回调函数
		 * @param	code
		 * 0-ScreenCap.INIT_OK 屏幕共享初始化完成。
		 * 1-ScreenCap.INIT_CANCEL 屏幕共享初始化被用户取消了。
		 * 2-ScreenCap.STOPPED_BY_USER 屏幕共享过程中被用户手动停止了。
		 * 3-ScreenCap.STOPPED_BY_MPC 由于插件连接断开,导致屏幕共享停止了.
		 */
		//private function screenCaptureCallback( code:uint ):void
		//{
			//var dispose:Boolean;
			//switch(code)
			//{
				//case ScreenCap.INIT_OK:
					//trace("init ok!");
					//break;
				//case ScreenCap.INIT_CANCEL:
					//Alert.show("ScreenCap init cancel！");
					//dispose = true;
					//break;
				//case ScreenCap.STOPPED_BY_USER:
					//Alert.show("ScreenCap stopped by user！");
					//dispose = true;
					//break;
				//case ScreenCap.STOPPED_BY_MPC:
					//Alert.show("ScreenCap stopped by mpc！");
					//dispose = true;
					//break;
				//default:
					//Alert.show("unknown code:" + code);
					//dispose = true;
					//break;
			//}
			//
			//frozen.hide();
			//
			//if(dispose)
			//{
				//disposeScreenCapture(true);
			//}
		//}
		
		/**
		 * 释放屏幕共享插件
		 * @param	bubble 是否通知视频显示模块
		 */
		//private function disposeScreenCapture( bubble:Boolean = false ):void
		//{
			//if (_screenData)
			//{
				//if(bubble)
				//{
					//dispatch(new CloseScreenCaptureEvent( _screenData['av'] ));
				//}
				//
				//if (!_screenData) return;
				//_screenData['sc'].dispose();
				//delete _screenData['sc'];
				//delete _screenData['av'];
				//_screenData = null;
			//}
		//}
		
		/**
		 * 清除数据
		 */
		override public function destroy():void
		{
			super.destroy();
			//this.view.btnScreenShare.removeEventListener( MouseEvent.CLICK, onClick );
			this.view.btnRecording.removeEventListener( MouseEvent.CLICK, onClick );
			//this.removeContextListener( CloseScreenCaptureEvent.SCREEN_CAPTURE, onScreenCaptureClose, CloseScreenCaptureEvent );
		}
		
	}

}