package tetequ.live.modules.room.chat.input.mediator 
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.domUI.events.CloseEvent;
	import robotlegs.bender.bundles.mvcs.Mediator;
	import tetequ.live.core.network.NetworkFacade;
	import tetequ.live.modules.room.chat.common.face.FaceFactory;
	import tetequ.live.modules.room.chat.common.face.FaceConfig;
	import tetequ.live.modules.room.chat.common.face.FaceLoader;
	import tetequ.live.modules.room.chat.common.message.ChatMessageVo;
	import tetequ.live.modules.room.chat.input.events.InsertEscapeCharEvent;
	import tetequ.live.modules.room.chat.input.events.OpenFacePanelEvent;
	import tetequ.live.modules.room.chat.input.events.SendGroupChatMessageEvent;
	import tetequ.live.modules.room.chat.input.view.GroupChatInputView;
	import tetequ.live.modules.room.common.GlobalVars;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class GroupChatInputMediator extends Mediator 
	{
		[Inject]
		public var view:GroupChatInputView;
		
		[Inject]
		public var networkFacade:NetworkFacade;
		
		[Inject]
		public var faceLoader:FaceLoader;
		
		public function GroupChatInputMediator() 
		{
			super();
			
		}
		
		/**
		 * 初始化
		 */
		override public function initialize():void
		{
			super.initialize();
			this.addContextListener( InsertEscapeCharEvent.INSERT_ESCAPE_CHAR, onInsertEscapeChar, InsertEscapeCharEvent);
			view.btnPhiz.addEventListener( MouseEvent.CLICK, onClick );
			view.btnSend.addEventListener( MouseEvent.CLICK, onClick );
			view.faceSelector.addEventListener( Event.SELECT, onFaceSelected );
			//view.input.maxChars = 100;
			view.input.addEventListener( FocusEvent.FOCUS_IN, onFocusIn );
			view.input.addEventListener( FocusEvent.FOCUS_OUT, onFocusOut );
			view.input.restrict = "^/";
		}
		
		private function onFocusOut(e:FocusEvent):void 
		{
			if(view &&view.stage)
				view.stage.removeEventListener( KeyboardEvent.KEY_UP, onKeyup );
		}
		
		private function onFocusIn(e:FocusEvent):void 
		{
			if(view && view.stage )
				view.stage.addEventListener( KeyboardEvent.KEY_UP, onKeyup );
		}
		
		private function onKeyup(e:KeyboardEvent):void 
		{
			switch(e.keyCode)
			{
				case Keyboard.ENTER:
					sendMessage();
					break;
				default:
					break;
			}
		}
		
		private function sendMessage():void
		{
			//输入框内容可能是粘贴进去的，所以需要截断为100个字符
			var msg:String = String(view.input.text);
			if( msg != "" )
			{
				dispatch( new SendGroupChatMessageEvent( createChatMessage( msg ) ) );
				 view.input.text = "";
				 view.input.setFocus();
				 view.input.setSelection(0,0);
			}
		}
		
		private function onFaceSelected(e:Event):void 
		{
			trace( "选择表情：" + view.faceSelector.faceId );
			view.hideFaceSelector();
			onInsertEscapeChar(new InsertEscapeCharEvent("/" + view.faceSelector.faceId));
		}
		
		/**
		 * 选择聊天表情后在输入框插入转义符
		 * @param	e
		 */
		private function onInsertEscapeChar(e:InsertEscapeCharEvent):void 
		{
			var rawMsg:String = view.input.text;
			var msg:String = rawMsg.substring( view.input.selectionBeginIndex, view.input.selectionEndIndex );
			var careIndex:int;
			if ( msg != "" )
			{
				careIndex = rawMsg.indexOf(msg);
				rawMsg = rawMsg.replace( msg, e.escapeChar );
			}else
			{
				if ( rawMsg != "" )
				{
					var msg1:String = rawMsg.substring( 0, view.input.caretIndex );
					var msg2:String = rawMsg.substring( view.input.caretIndex, rawMsg.length );
					rawMsg = msg1 + e.escapeChar + msg2;
					careIndex = view.input.caretIndex + e.escapeChar.length;
				}else
				{
					rawMsg = e.escapeChar;
					careIndex = e.escapeChar.length;
				}
			}
			
			view.input.text = rawMsg;
			view.input.setFocus();
			view.input.setSelection(careIndex, careIndex);
		}
		
		/**
		 * 按钮点击事件
		 * @param	e
		 */
		private function onClick(e:MouseEvent):void 
		{
			switch( e.currentTarget )
			{
				case view.btnPhiz:
					if ( !view.hasFace )
					{
						for (var i:int = 1; i != GlobalVars.MAX_FACE_INDEX+1; ++i )
						{
							var face:UIAsset = FaceFactory.getInstance().cloneFace(i);
							
							if (GlobalVars.language == GlobalVars.LANG_CHINESE)
							{
								face.toolTip = FaceConfig.ESCAPE_MAP[i];
							}else if (GlobalVars.language == GlobalVars.LANG_ENGLISH)
							{
								face.toolTip = FaceConfig.EN_ESCAPE_MAP[i];
							}else
							{
								throw new Error('无法识别的语言！');
							}
							
							view.registerFace(face);
						}
					}
					view.showFaceSelector();
					break;
				case view.btnSend:
					sendMessage();
					break;
				default:
					break;
			}
		}
		
		/**
		 * 创建一条聊天消息数据
		 * @param	msg
		 * @return
		 */
		private function createChatMessage( msg:String ):ChatMessageVo
		{
			var msgVo:ChatMessageVo = new ChatMessageVo();
			msgVo.userId = networkFacade.userId;
			msgVo.username = networkFacade.userName;
			msgVo.message = msg;
			msgVo.timestamp = new Date().time / 1000;
			msgVo.userLevel = networkFacade.user.level;
			return msgVo;
		}
		
		
		/**
		 * 清除数据
		 */
		override public function destroy():void
		{
			super.destroy();
			view.btnPhiz.removeEventListener( MouseEvent.CLICK, onClick );
			view.btnSend.removeEventListener( MouseEvent.CLICK, onClick );
			this.removeContextListener( InsertEscapeCharEvent.INSERT_ESCAPE_CHAR, onInsertEscapeChar, InsertEscapeCharEvent);
			view.stage.removeEventListener( KeyboardEvent.KEY_UP, onKeyup );
		}
		
	}

}