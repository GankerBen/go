package tetequ.live.modules.room.common.keyboard 
{
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import framework.view.UIRoot;
	import org.flexlite.domUI.core.IVisualElement;
	import org.flexlite.domUI.managers.PopUpManager;
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class KeyboardManager 
	{
		[Inject]
		public var ui:UIRoot;
		
		public function KeyboardManager() 
		{
			
		}
		
		private var _stage:Stage;
		public function initStage( stage:Stage ):void
		{
			_stage = stage;
			_stage.addEventListener( KeyboardEvent.KEY_UP, onStageKeyup );
		}
		
		private function onStageKeyup(e:KeyboardEvent):void 
		{
			switch( e.keyCode )
			{
				case Keyboard.ESCAPE:
					var panel:IVisualElement = ui.popUpContainer.getElementAt(ui.popUpContainer.numElements - 1);
					if ( panel )
					{
						PopUpManager.removePopUp( panel );
					}
					break;
				default:
					break;
			}
		}
		
	}

}