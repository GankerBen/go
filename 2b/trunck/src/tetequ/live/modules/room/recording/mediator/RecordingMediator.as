package tetequ.live.modules.room.recording.mediator 
{
	import flash.events.Event;
	import framework.view.UIRoot;
	import robotlegs.bender.bundles.mvcs.Mediator;
	import tetequ.live.core.network.NetworkFacade;
	import tetequ.live.modules.room.recording.events.RecordEvent;
	import tetequ.live.modules.room.recording.view.RecordingView;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class RecordingMediator extends Mediator 
	{
		[Inject]
		public var view:RecordingView;
		
		[Inject]
		public var networkFacade:NetworkFacade;
		
		[Inject]
		public var uiroot:UIRoot;
		
		public function RecordingMediator() 
		{
			super();
			
		}
		
		override public function initialize():void
		{
			super.initialize();
			this.addViewListener(Event.CANCEL, onRecordCancel, Event);
			this.addContextListener(RecordEvent.STARTED, onRecordStarted, RecordEvent);
			this.addContextListener(RecordEvent.STOPED, onRecordStoped, RecordEvent);
		}
		
		private function onRecordStoped(e:RecordEvent):void 
		{
			this.view.handleRecordStopped(e.session);
			uiroot.removeElement(this.view);
			
		}
		
		private function onRecordStarted(e:RecordEvent):void 
		{
			this.view.handleRecordStarted(e.session, e.videoId);
		}
		
		private function onRecordCancel(e:Event):void 
		{
			networkFacade.stopRecord();
		}
		
		override public function destroy():void
		{
			super.destroy();
			this.removeViewListener(Event.CANCEL, onRecordCancel, Event);
			this.removeContextListener(RecordEvent.STARTED, onRecordStarted, RecordEvent);
			this.removeContextListener(RecordEvent.STOPED, onRecordStoped, RecordEvent);
		}
		
	}

}