package tetequ.live.modules.room.chat.common.message 
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.engine.ContentElement;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.GraphicElement;
	import flash.text.engine.GroupElement;
	import flash.text.engine.TextBlock;
	import flash.text.engine.TextElement;
	import flash.text.engine.TextLine;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.TextLineMetrics;
	import mx.core.TextFieldAsset;
	import org.bytearray.gif.player.GIFPlayer;
	import org.flexlite.domUI.components.EditableText;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.components.Rect;
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.domUI.core.IVisualElement;
	import org.flexlite.domUI.layouts.HorizontalLayout;
	import org.flexlite.domUI.layouts.VerticalAlign;
	import org.flexlite.domUI.layouts.VerticalLayout;
	import org.flexlite.domUI.skins.VectorSkin;
	import org.flexlite.domUI.utils.callLater;
	import tetequ.live.core.assets.AssetsFactory;
	import tetequ.live.modules.room.chat.common.face.FaceFactory;
	import tetequ.live.modules.room.common.GlobalVars;
	import tetequ.live.utils.HashMap;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 一条完整的聊天信息显示
	 */
	public class ChatMessageItemView extends Group 
	{
		//消息数据
		private var _vo:ChatMessageVo;
		
		//名字+日期
		private var _label:Label;
		
		//背景
		private var _background:Rect;
		
		//表情转义符集合
		private var _faceEscapes:Array;
		
		//分离出表情转义符之后纯文本消息数组
		private var _msgChars:Array;
		
		//匹配表情转义符
		private static const REG_FACE_ESCAPE:RegExp = /\/[1-9][0-9]{0,1}/g;
		
		private static const FONT:String = "微软雅黑";
		
		//消息文本格式
		private static const MSG_TEXT_FORMAT:ElementFormat = new ElementFormat(new FontDescription(FONT), 13, 0x000000);
		
		//行宽
		private static const LINE_WIDTH:int = 175;
		
		private static const LINE_WIDTH2:int = 185;
		
		//行高
		private static const LINE_HEIGHT:int = 22;
		
		//文本块
		private var _textBlock:TextBlock;
		
		//一组文本行
		private var _textLines:Vector.<TextLine>;
		
		//图文元素的容器
		private var _groupElement:GroupElement;
		
		//图文元素
		private var _elements:Vector.<ContentElement>;
		
		//表情动画
		private var _faceAnimations:Vector.<GIFPlayer>;
		
		private var _group:Group;
		private var _group1:Group;//头像+名字+时间+消息
		private var _group2:Group;//名字+时间+消息
		
		/**
		 * 为了避免表情的白色虚边，加个背景
		 */
		private var _back:VectorSkin;
		private var _backWidth:int;
		private var _backColor:uint;
		private var _headIcon:UIAsset;
		
		
		/**
		 * 构造函数
		 * @param	vo
		 */
		public function ChatMessageItemView( vo:ChatMessageVo ) 
		{
			super();
			_vo = vo;
			
			init();
		}
		
		private function getTimeString(value:Number):String
		{
			if (value < 10)
			{
				return "0" + value.toString();
			}else
			{
				return value.toString();
			}
		}
		/**
		 * 初始化
		 */
		private function init():void 
		{
			addElement( _background = new Rect() );
			_background.width = 300;
			_background.percentWidth = 100;
			_background.percentHeight = 150;
			_background.fillColor = 0xffffff;
			_background.alpha = 0;
			
			addElement(_back = new VectorSkin());
			_back.top = 26;
			_back.left = 40;
			
			addElement(_headIcon = new UIAsset());
			_headIcon.left = 0;
			_headIcon.top = 5;
			_headIcon.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
			{
				// TODO 私聊
			});
			
			addElement(_group = new Group());
			_group.layout = new HorizontalLayout();
			_group.left = 40;
			HorizontalLayout(_group.layout).gap = 15;
			
			//_group.addElement(_group1 = new Group());
			//_group1.addElement(_headIcon = new UIAsset());
			//_headIcon.skinName = "app/web/assets/uilib/headicon.png";
			//_headIcon.left = 10;
			_group.addElement(_group2 = new Group());
			_group2.layout = new VerticalLayout();
			
			_group2.addElement( _label = new Label());
			//HorizontalLayout(_group2.layout).verticalAlign = VerticalAlign
			
			var date:Date = new Date( _vo.timestamp * 1000 );
			var time:String = "  " + getTimeString(date.getHours()) + ":" + getTimeString(date.getMinutes()) + ":" + getTimeString(date.getSeconds());
			var nameFmt:TextFormat = new TextFormat();
			var isMaster:Boolean = Boolean(_vo.userLevel & 0x80);
			var headIcon:String = isMaster ? 'teacherSkin' : 'studentSkin';
			isMaster ? nameFmt.color = 0x33cc33 : nameFmt.color = 0xcccccc;
			
			if (GlobalVars.language == GlobalVars.LANG_ENGLISH)
			{
				//英文
				
				isMaster ? _vo.username = "Teacher-" + _vo.username : _vo.username = "Students-" + _vo.username;
			}else if(GlobalVars.language == GlobalVars.LANG_CHINESE)
			{
				//中文
				isMaster ? _vo.username = "老师-" + _vo.username : _vo.username = "学生-" + _vo.username;
			}else
			{
				throw new Error('无法识别的语言！');
			}
			
			isMaster ? _backColor = 0xccff00 : _backColor = 0xffffff;
			
			_headIcon.skinName = AssetsFactory.getInstance().getAsset(headIcon);
			
			_label.fontFamily = FONT;
			_label.text = _vo.username + time;
			nameFmt.bold = true;
			nameFmt.size = 13;
			nameFmt.font = FONT;
			
			_label.setFormatOfRange(nameFmt, 0, _vo.username.length);
			
			var timeFmt:TextFormat = new TextFormat();
			timeFmt.size = 13;
			timeFmt.color = 0xaaaaaa;
			timeFmt.font = FONT;
			
			_label.setFormatOfRange(timeFmt, _vo.username.length, _vo.username.length + time.length);
			
			_faceEscapes = vo.message.match( REG_FACE_ESCAPE );
			_msgChars = vo.message.split(REG_FACE_ESCAPE);
			//_msgChars = splitChars(vo.message, 50 );
			trace("_faceEscapes", _faceEscapes);
			trace("_msgChars", _msgChars);
			trace("消息长度", _vo.message.length);
			//将消息分段
			var chars:Array = [];
			for (var k:int = 0; k != _msgChars.length;++k )
			{
				var msg:String = _msgChars[k];
				//if(msg!=""&&msg!=null)
				chars = chars.concat(splitChars(msg,10));
			}
			
			var newMsgChars:Array = chars;
			//_msgChars = chars;
			//trace("_msgChars:", _msgChars);
			
			/**
			 * _faceEscapes中可能包含
			 * 虽然符合表情转义符格式
			 * 但是并不合法的字符，这
			 * 些字符需要放进_msgChars
			 * 中的适当位置.
			 */
			var len:int = _faceEscapes.length;
			for (var i:int; i != len; ++i )
			{
				var escp:String = _faceEscapes[i];
				var id:int = parseInt(escp.substring(1, escp.length));
				
				if ( id > GlobalVars.MAX_FACE_INDEX )
				{
					var nEs:String = escp.substring(0, 2);
					_faceEscapes[i] = nEs;
				}
			}
			
			_textBlock = new TextBlock();
			_groupElement = new GroupElement();
			_elements = new Vector.<ContentElement>;
			
			len = newMsgChars.length;
			if (len == 0)
			{
				len = _msgChars.length;
			}
			var fIndex:int;
			var fNum:int;
			var gElement:GraphicElement;
			var rawMsgIndex:int = 0;
			var mesg:String = "";
			trace(_msgChars.length);
			for ( i = 0; i != len; ++i )
			{
				var msgSeg:String = _msgChars[i];
				mesg += msgSeg;
				if (!msgSeg)//i可能为0或者len-1
				{
					
				}else
				{
					if(msgSeg!="")
					{
						var msgs:Array = splitChars(msgSeg, 1);
						for each( var __msg:String in msgs )
						{
							var tElement:TextElement = new TextElement(__msg, MSG_TEXT_FORMAT);
							if(tElement)
							_elements.push(tElement);
						}
						
						trace("字符串长度:", msgSeg.length * 13);
					}
				}
				
				if (mesg == _msgChars[rawMsgIndex])
				{
					trace("合并一次..");
					
					gElement = createFace(_faceEscapes[rawMsgIndex]);
					if(gElement)
						_elements.push(gElement);
					
					rawMsgIndex++;
					mesg = '';
				}
			}
			
			_groupElement.setElements(_elements);
			_textBlock.content = _groupElement;
			_textLines = new Vector.<TextLine>;
			
			len = _elements.length;
			var w:Number = 0;
			var numLines:int = 1;
			var widths:Vector.<Number> = new Vector.<Number>;
			for ( i = 0; i != len; ++i )
			{
				var ele:ContentElement = _elements[i];
				if (ele is GraphicElement)
				{
					w += 24;
				}else
				{
					w += TextElement(ele).text.length * MSG_TEXT_FORMAT.fontSize;//FIXME：此处可能还会加上字符间隔
				}
				
				trace( "当前宽度:", w );
				
				if(w>_backWidth)
					_backWidth = w;
					
				if (_backWidth > LINE_WIDTH2)
					_backWidth = LINE_WIDTH2;
				
				if ( w >= LINE_WIDTH )
				{
					widths.push(w);
					numLines++;
					w = w - LINE_WIDTH;
				}
			}
			
			if(w>0)
				numLines++;

			if (numLines == 0)
			{
				var tLine:TextLine = _textBlock.createTextLine(null, LINE_WIDTH);
				var wrp:UIAsset = new UIAsset();
				wrp.skinName = tLine;
				callLater(_group2.addElement, [wrp], 10);
			}else
			{
				for ( i = 0; i != numLines; ++i )
				{
					if( i == 0 )
					{
						tLine = _textBlock.createTextLine(null, LINE_WIDTH);
					}else
					{
						tLine = _textBlock.createTextLine(/*_textLines[_textLines.length - 1]*/tLine, LINE_WIDTH);
						trace(_textBlock.textLineCreationResult);
					}
					
					if(tLine)
					{
						tLine.y = /*33*/ 43 + i * LINE_HEIGHT;
						tLine.x = /*4*/45;
						_textLines.push(tLine);
						wrp = new UIAsset();
						wrp.skinName = tLine;
						callLater(addElement, [wrp], 10 + i * 10);
						
						if (!_faceAnimations) continue;
						var num:int = _faceAnimations.length;
						for (var j:int = 0; j != num; ++j )
						{
							var elem:DisplayObject = _faceAnimations[j];
							if (elem)
							{
								elem.y = 8;
							}
						}
					}else
					{
						break;
					}
				}
			}
			
			//_back.width = 300;
			var h:int;
			if (_faceAnimations && _faceAnimations.length > 0)
				h = _textLines.length * LINE_HEIGHT + 5;
			else
				h = _textLines.length * LINE_HEIGHT;
				
			_back.graphics.beginFill(_backColor);
			_back.graphics.drawRoundRect(0, 0, _backWidth+12, h, 5, 5 );
			_back.graphics.endFill();
			_back.graphics.beginFill(_backColor);
			_back.graphics.moveTo( -7, 10);
			_back.graphics.lineTo(0, 13);
			_back.graphics.lineTo(0, 7);
			_back.graphics.lineTo( -7, 10);
			_back.graphics.endFill();
			_background.height = _textLines.length * LINE_HEIGHT + 15;
			this.addEventListener( Event.REMOVED_FROM_STAGE, onRemoved );
		}
		
		private static function splitChars( msg:String, lineChars:int = 20 ):Array
		{
			var result:Array = [];
			var num:int = msg.length / lineChars;
			for (var i:int = 0; i != num;++i )
			{
				var str:String = msg.substring(i * lineChars, (i + 1) * lineChars);
				result.push(str);
			}
			
			result.push(msg.substring(i * lineChars, (i + 1) * lineChars));
			
			return result;
		}
		
		private function onRemoved(e:Event):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			clear();
		}
		
		/**
		 * 根据转义符创建表情
		 * @param	fEscape
		 * @return
		 */
		private function createFace( fEscape:String ):GraphicElement
		{
			if (!fEscape) return null;
			if (!_faceAnimations)
			{
				_faceAnimations = new Vector.<GIFPlayer>;
			}
			var fId:int = parseInt(fEscape.substring(1, fEscape.length));
			var face:UIAsset = FaceFactory.getInstance().cloneFace(fId);
			_faceAnimations.push(GIFPlayer(face.skinName));
			var gFmt:ElementFormat = new ElementFormat();
			var gElement:GraphicElement = new GraphicElement(face, 24, 24, gFmt);
			
			return gElement;
		}
		
		/**
		 * 消息数据
		 */
		public function get vo():ChatMessageVo 
		{
			return _vo;
		}
		
		//清除
		public function clear():void
		{
			if ( _textBlock )
			{
				_textBlock.releaseLines( _textBlock.firstLine, _textBlock.lastLine );
				_textBlock.releaseLineCreationData();
				_textBlock = null;
				
				if (_faceAnimations)
				{
					var len:int = _faceAnimations.length;
					for ( var i:int = 0; i != len; ++i )
					{
						var face:GIFPlayer = _faceAnimations[i];
						face.stopTimer();
					}
					_faceAnimations.length = 0;
				}
				
				_groupElement = null;
				_textLines.length = 0;
				_elements.length = 0;
			}
		}
		
	}

}