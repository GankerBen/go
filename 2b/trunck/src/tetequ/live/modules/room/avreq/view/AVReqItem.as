package tetequ.live.modules.room.avreq.view 
{
	import com.e2et.datalogic.AVReq;
	import com.e2et.datalogic.User;
	import flash.display.Graphics;
	import flash.events.MouseEvent;
	import org.flexlite.domUI.components.Button;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.components.Rect;
	import org.flexlite.domUI.components.TitleWindow;
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.domUI.layouts.HorizontalLayout;
	import org.flexlite.domUI.skins.vector.ButtonSkin;
	import tetequ.live.core.assets.AssetsFactory;
	import tetequ.live.modules.room.common.GlobalVars;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 一条发言申请
	 */
	public class AVReqItem extends Group 
	{
		private var _txtMessage:Label;
		private var _btnYes:UIAsset;
		private var _btnNo:UIAsset;
		private var _bg:Rect;
		private var _yesCallback:Function;
		private var _noCallback:Function;
		private var _avReq:AVReq;
		private var _btnsGroup:Group;
		
		public function AVReqItem( avReq:AVReq, yesCallback:Function, noCallback:Function ) 
		{
			super();

			_avReq = avReq;
			_yesCallback = yesCallback;
			_noCallback = noCallback;
			
			this.width = 350;
			this.height = 200;

			initComponents();
		}
		
		override protected function updateDisplayList(w:Number,h:Number):void
		{
			super.updateDisplayList(w, h);
			graphics.clear();
			var g:Graphics = graphics;
			g.beginFill(0xcccccc);
			g.drawRect(0, 0, w, h);
			g.endFill();
			
			var logo:Button = new Button();
			logo.skinName = AssetsFactory.getInstance().getAsset('alerticon');
			logo.maintainAspectRatio = true;
			logo.horizontalCenter = 0;
			logo.top = 35;
			addElement(logo);
			
			var hw:Number = w >> 1;
			var hh:Number = 2 / 3 * h;
			
			g.beginFill(0x666666);
			g.drawRect(0, hh, w, h-hh);
			g.endFill();

			g.beginFill(0xcccccc);
			g.moveTo( hw - 8, hh );
			g.lineTo( hw + 8, hh );
			g.lineTo( hw, hh + 8 );
			g.lineTo( hw - 8, hh );
			g.endFill();
		}
		
		private function initComponents():void 
		{
			addElement( _txtMessage = new Label() );
			
			if (GlobalVars.language == GlobalVars.LANG_ENGLISH)
			{
				//英文
				_txtMessage.text = "Users " + _avReq.user.name + " application to speak, you agree?";
			}else if(GlobalVars.language == GlobalVars.LANG_CHINESE)
			{
				//中文
				_txtMessage.text = "用户 " + _avReq.user.name + " 申请发言，您同意吗？";

			}else
			{
				throw new Error('无法识别的语言！');
			}
			
			_txtMessage.textColor = 0x888888;
			_txtMessage.verticalCenter = 0;
			_txtMessage.horizontalCenter = 0;
			
			addElement( _btnsGroup = new Group() );
			_btnsGroup.layout = new HorizontalLayout();
			_btnsGroup.horizontalCenter = 0;
			_btnsGroup.bottom = 12;
			HorizontalLayout(_btnsGroup.layout).gap = 10;
			HorizontalLayout(_btnsGroup.layout).paddingLeft = 20;
			HorizontalLayout(_btnsGroup.layout).paddingLeft = 20;
			
			_btnsGroup.addElement( _btnYes = new UIAsset() );
			_btnYes.mouseChildren = true;
			_btnYes.mouseEnabled = true;
			_btnYes.skinName = AssetsFactory.getInstance().getAsset('tongyiSkin');
			
			_btnsGroup.addElement( _btnNo = new UIAsset() );
			_btnNo.mouseChildren = true;
			_btnNo.mouseEnabled = true;
			_btnNo.skinName = AssetsFactory.getInstance().getAsset('jujueSkin');
			
			_btnYes.addEventListener( MouseEvent.CLICK, onClick );
			_btnNo.addEventListener( MouseEvent.CLICK, onClick );
		}
		
		private function onClick(e:MouseEvent):void 
		{
			if ( e.currentTarget == _btnYes )
			{
				if ( _yesCallback != null )
				{
					_yesCallback.apply( null, [_avReq] );
				}
			}else
			{
				if ( _noCallback != null )
				{
					_noCallback.apply( null, [_avReq] );
				}
			}
		}
		
	}

}