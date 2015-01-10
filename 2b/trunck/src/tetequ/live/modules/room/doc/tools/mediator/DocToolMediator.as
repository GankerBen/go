package tetequ.live.modules.room.doc.tools.mediator 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import org.flexlite.domUI.components.Alert;
	import org.flexlite.domUI.components.Button;
	import org.flexlite.domUI.components.ToggleButton;
	import org.flexlite.domUI.components.UIAsset;
	import robotlegs.bender.bundles.mvcs.Mediator;
	import tetequ.live.core.network.NetworkFacade;
	import tetequ.live.modules.room.doc.tools.events.DocToolEvent;
	import tetequ.live.modules.room.doc.tools.model.DocToolData;
	import tetequ.live.modules.room.doc.tools.view.DocToolView;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class DocToolMediator extends Mediator 
	{
		[Inject]
		public var view:DocToolView;
		
		[Inject]
		public var networkFacade:NetworkFacade;
		
		public function DocToolMediator() 
		{
			super();
			
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			this.view.btnPencil.addEventListener( MouseEvent.CLICK, onClick );
			this.view.btnDummy.addEventListener( MouseEvent.CLICK, onClick );
			this.view.btnEraser.addEventListener( MouseEvent.CLICK, onClick );
			this.view.btnText.addEventListener( MouseEvent.CLICK, onClick );

			DocToolData.color = 0xff0000;
			DocToolData.curTool = DocToolData.TOOL_DUMMY;
			
			this.view.btnDummy.$selected = true;
			this.view.btnEraser.$selected = false;
			this.view.btnPencil.$selected = false;
			this.view.btnText.$selected = false;
			this.view.curTool = this.view.btnDummy;
			
			trace( "未选择任何画笔工具！" );
			dispatch(new DocToolEvent(0, 0, DocToolEvent.DUMMY_SELECT));
		}

		override public function destroy():void
		{
			super.destroy();
			this.view.btnPencil.removeEventListener( MouseEvent.CLICK, onClick );
			this.view.btnDummy.removeEventListener( MouseEvent.CLICK, onClick );
			this.view.btnEraser.removeEventListener( MouseEvent.CLICK, onClick );
			this.view.btnText.removeEventListener( MouseEvent.CLICK, onClick );
		}
		
		private function onClick(e:MouseEvent):void 
		{
			if ( !networkFacade.hasToken )
			{
				if ( e.currentTarget is UIAsset )
				{
					UIAsset(e.currentTarget).$selected = !UIAsset(e.currentTarget).$selected;
				}
				
				Alert.show( "对不起，您没有权限进行此操作！" );
				return;
			}
			
			DocToolData.sendTextNotice();//通知文本输入区失去焦点
			
			switch( e.currentTarget )
			{
				case this.view.btnPencil:
				case this.view.btnText:
				case this.view.btnEraser:
				case this.view.btnDummy:
					updateTool( UIAsset(e.currentTarget));
					break;
				default:
					break;
			}
		}
		
		private var _lastColorButton:UIAsset;
		private function updateColor( now:UIAsset ):void
		{
			if ( now.$selected )
			{
				if ( now != _lastColorButton )
				{
					if ( _lastColorButton )
					{
						_lastColorButton.$selected = false;
					}
					_lastColorButton = now;
					DocToolData.color = parseInt(now.id);
				}
			}else
			{
				if ( now == _lastColorButton )
				{
					now.$selected = true;
				}
			}
			
		}
		
		private function updateTool( now:UIAsset ):void
		{
			if ( now.$selected )
			{
				if ( now != this.view.curTool )
				{
					if ( this.view.curTool )
					{
						this.view.curTool.$selected = false;
					}
					this.view.curTool = now;
					
					//FIXME:设置房间画笔工具
					DocToolData.curTool = parseInt(now.id);
					
					switch( DocToolData.curTool )
					{
						case DocToolData.TOOL_DUMMY:
							dispatch(new DocToolEvent(0, 0, DocToolEvent.DUMMY_SELECT));
							break;
						case DocToolData.TOOL_ERASER:
							dispatch(new DocToolEvent(0, 0, DocToolEvent.ERASER_SELECT));
							break;
						case DocToolData.TOOL_PENCIL:
							dispatch(new DocToolEvent(0, 0, DocToolEvent.PENCIL_SELECT));
							break;
						case DocToolData.TOOL_TEXT:
							dispatch(new DocToolEvent(0, 0, DocToolEvent.TEXT_SELECT));
							break;
							default:
							break;
					}
				}
			}else
			{
				if ( now == this.view.curTool )
				{
					now.$selected = true;
				}
			}
		}
		
	}

}