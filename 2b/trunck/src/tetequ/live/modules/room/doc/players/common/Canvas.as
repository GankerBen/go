package tetequ.live.modules.room.doc.players.common 
{
	import com.e2et.datalogic.DocLine;
	import com.e2et.datalogic.DocLineAddPoint;
	import com.e2et.datalogic.DocLineEnd;
	import com.e2et.datalogic.DocLineStart;
	import com.e2et.datalogic.DocLineUpdate;
	import com.e2et.datalogic.DocPencilTool;
	import com.e2et.datalogic.DocText;
	import com.e2et.datalogic.DocTextChangePosition;
	import com.e2et.datalogic.DocTextChangeText;
	import com.e2et.datalogic.DocTextTool;
	import com.e2et.datalogic.Document;
	import com.e2et.datalogic.Point;
	import com.e2et.datalogic.Rect;
	import com.e2et.datalogic.RoomObjectPurge;
	import com.e2et.datalogic.Size;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.getDefinitionByName;
	import org.flexlite.domUI.components.Alert;
	import org.flexlite.domUI.components.EditableText;
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.components.TextInput;
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.domUI.core.UITextField;
	import org.flexlite.domUI.events.UIEvent;
	import org.flexlite.domUI.skins.vector.TextInputSkin;
	import org.flexlite.domUI.utils.callLater;
	import tetequ.live.modules.room.doc.players.common.interfaces.ICanvas;
	import tetequ.live.modules.room.doc.tools.model.DocToolData;
	import tetequ.live.utils.HashMap;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class Canvas extends UIAsset implements ICanvas
	{
		private var _num:int;
		private var _pages:Vector.<UIAsset>;
		private var _curWidth:Number;
		private var _curHeight:Number;
		private var _canvasH:Number;
		private var _curFrame:int;
		private var _bindDocUri:String;
		private var _bindDocument:Document;
		
		//用于转换线条的坐标位置的系数
		private static const FACTOR:int = 10000;
		
		private var _localLineMapper:HashMap;
		private var _remoteLineMapper:HashMap;
		
		private var _localTextMapper:HashMap;
		private var _remoteTextMapper:HashMap;
		
		public function Canvas( num:int ) 
		{
			super();
			_num = num;
			
			initComponents();
		}
		
		private function initComponents():void 
		{
			this.left = 0;
			this.top = 0;
			this.mouseChildren = true;
			this.mouseEnabled = true;
			
			_localLineMapper = new HashMap();
			_remoteLineMapper = new HashMap();
			
			_localTextMapper = new HashMap();
			_remoteTextMapper = new HashMap();
			
			DocToolData.setTextObserver( textObserver );
			
			_pages = new Vector.<UIAsset>;
		}
		
		/**
		 * 绑定到文档
		 */
		public function set bindDocument( doc:Document ):void
		{
			_bindDocument = doc;
		}
		
		/**
		 * 获取绑定的文档
		 */
		public function get bindDocument():Document
		{
			return _bindDocument;
		}
		
		/**
		 * 画线开始
		 * @param	action
		 */
		public function handleDocLineStart( action:DocLineStart ):void
		{
			var canvas:Sprite = Sprite(_pages[_curFrame].skinName);
			var thickness:uint = action.docLine.pencil.thickness;
			var color:uint = action.docLine.pencil.color;

			_line = new Sprite();
			_line.graphics.lineStyle( thickness, color );//FIXME:暂时用常数代替
			
			var localX:int = action.point.x / FACTOR * _curWidth;
			var localY:int = action.point.y / FACTOR * _curHeight;
			_line.graphics.moveTo( localX, localY );
			
			//docline.id是绝对唯一的，将线条映射到该id上，可以方便擦除
			_localLineMapper.put( action.docLine.id, _line );
			
			canvas.addChild( _line );
		}
		
		/**
		 * 画线结束
		 * @param	action
		 */
		public function handleDocLineEnd( action:DocLineEnd ):void
		{

			_line = _localLineMapper.getValue( action.docLine.id );
			if( _line )
				_line.graphics.endFill();
		}
		
		/**
		 * 更新画线
		 * @param	action
		 */
		public function handleDocLineUpdate( action:DocLineUpdate ):void
		{
			//TODO:目前的应用场合还使用不到这个，它描述当一个线条发生形变时的动作。
		}
		
		/**
		 * 添加新的描点
		 * @param	action
		 */
		public function handleDocLineAddPoint( action:DocLineAddPoint ):void
		{
			_line = _localLineMapper.getValue( action.docLine.id );
			if ( !_line ) return;
			var localX:int = action.point.x / FACTOR * _curWidth;
			var localY:int = action.point.y / FACTOR * _curHeight;
			_line.graphics.lineTo( localX, localY );
		}
		
		/**
		 * 文本位置改变
		 * 新增一个文本
		 * @param	action
		 */
		public function handleDocTextChangePosition( action:DocTextChangePosition ):void
		{
			var canvas:Sprite = Sprite(_pages[_curFrame].skinName);
			var txtSpr:Sprite = new Sprite();
			var localX:int =  action.rect.point().x / FACTOR * _curWidth;
			var localY:int = action.rect.point().y / FACTOR * _curHeight;
			var tf:Label = new Label();
			var docText:DocText = DocText(action.subject);
			tf.text = DocText(action.subject).text;
			tf.textColor = DocText(action.subject).textTool.color;
			tf.fontFamily = DocText(action.subject).textTool.font;
			tf.selectable = false;
			tf.mouseEnabled = false;
			tf.x = localX;
			tf.y = localY;
			txtSpr.addChild(tf);
			canvas.addChild(txtSpr);
			
			_localTextMapper.put( docText.id, txtSpr );
		}
		
		/**
		 * 当前文本内容改变
		 * @param	action
		 */
		public function handleDocTextChangeText( action:DocTextChangeText ):void
		{
			var txtSpr:Sprite = _localTextMapper.getValue( DocText(action.subject).id );
			if ( !txtSpr ) return;
			var tf:Label = txtSpr.getChildAt(0) as Label;
			tf.text = DocText(action.subject).text;
		}
		
		/**
		 * 擦除文本
		 * @param	docText
		 */
		public function handlePurgeDocText( docText:DocText ):void
		{
			var tfSpr:Sprite = _localTextMapper.getValue(docText.id);
			if ( !tfSpr ) return;
			var tf:Label = tfSpr.getChildAt(0) as Label;
			if(tf.hasEventListener(Event.CHANGE))
				tf.removeEventListener( Event.CHANGE, onTextChanged );
			tfSpr.graphics.clear();
			tfSpr.parent.removeChild(tfSpr);
			tfSpr.removeChildAt(0);
			tf.text = "";
			_localTextMapper.remove(docText.id);
			if (_remoteTextMapper.containsKey(docText.id))
				_remoteTextMapper.remove(docText.id);
		}
		
		/**
		 * 擦除线条
		 * @param	docLine
		 */
		public function handlePurgeDocLine( docLine:DocLine ):void
		{
			var line:Sprite = _localLineMapper.getValue(docLine.id);
			if ( !line ) return;
			line.graphics.clear();
			line.parent.removeChild(line);
			_localLineMapper.remove(docLine.id);
			if (_remoteLineMapper.containsKey(docLine.id))
				_remoteLineMapper.remove(docLine.id);
		}
		
		/**
		 * 绘图层所在容器尺寸发生变化
		 * @param	newWidth
		 * @param	newHeight
		 */
		public function onResize( newWidth:Number, newHeight:Number, canvasH:Number ):void
		{
			if (!_pages[_curFrame]) return;
			
			_curWidth = newWidth;
			_curHeight = newHeight;
			_canvasH = canvasH;

			if ( _curWidth <= 0 || _curHeight <= 0 ) return;
			
			var page:Sprite = Sprite(_pages[_curFrame].skinName);
			var oldW:Number = page.width;
			var oldH:Number = page.height;
			if ( oldW <= 0 || oldH <= 0 ) return;
			
			page.graphics.clear();
			page.graphics.beginFill(0xff0000, 0);
			page.graphics.drawRect(0, 0, _curWidth, _curHeight);
			page.graphics.endFill();
			
			
			var num:int = page.numChildren;

			for ( var i:int = 0; i != num; ++i )
			{
				var child:DisplayObject = page.getChildAt(i);
				child.width = child.width * _curWidth / oldW;
				child.height = child.height * _curHeight / oldH;
			}
		}
		
		/**
		 * 文档翻页后绘图层更新
		 * @param	frame
		 */
		public function drawPage( frame:int ):void
		{
			isNaN(_curWidth) ? _curWidth = 200 : null;
			isNaN(_curHeight) ? _curHeight = 200 : null;
			
			if (_pages.length < frame+1)
			{
				_pages.length = frame + 1; 
			}
			
			_curFrame = frame;
			
			var page:UIAsset = _pages[frame];
			var canvas:Sprite;
			
			if ( page )
			{
				canvas = Sprite(page.skinName);
				canvas.graphics.clear();
			}else
			{
				_pages[frame] = page = new UIAsset();
				page.mouseChildren = true;
				page.mouseEnabled = true;
				
				canvas = new Sprite();
				page.skinName = canvas;
				canvas.addEventListener( MouseEvent.MOUSE_DOWN, onCanvasDown );
			}
			
			canvas.graphics.beginFill( 0xff0000, 0 );
			canvas.graphics.drawRect( 0, 0, _curWidth, _curHeight);
			canvas.graphics.endFill();
			
			this.skinName = page;
		}
		
		private var _line:Sprite;//临时用
		private var _docLine:DocLine;
		private function onCanvasDown(e:MouseEvent):void 
		{
			switch( DocToolData.curTool )
			{
				case DocToolData.TOOL_DUMMY:
					trace( "当前没有选择任何画笔工具！" );
					return;
					break;
				case DocToolData.TOOL_ERASER:
					if ( !DocToolData.hasToken )
					{
						//Alert.show( "对不起，您没有权限，不能使用橡皮擦工具！" );
						return;
					}
					onUseEraser( e );
					return;
					break;
				case DocToolData.TOOL_PENCIL:
					if ( !DocToolData.hasToken )
					{
						//Alert.show( "对不起，您没有权限，不能使用铅笔工具！" );
						return;
					}
					onUsePencil( e );
					break;
				case DocToolData.TOOL_TEXT:
					if ( !DocToolData.hasToken )
					{
						//Alert.show( "对不起，您没有权限，不能使用文本工具！" );
						return;
					}
					onUseText( e );
					return;
					break;
				default:
					break;
			}
		}
		
		private var _docText:DocText;
		
		private function textObserver():void
		{
			if ( _lastTF )
			{
				_lastTF.removeEventListener( Event.CHANGE, onTextChanged );
				_lastTF.removeEventListener( Event.ADDED_TO_STAGE, onStageAdded );
				_lastTF.selectable = false;
				_lastTF.mouseEnabled = false;
				_lastTF.mouseChildren = false;
			}
		}
		
		private var _lastTF:EditableText;
		/**
		 * 使用文本工具
		 * 开始写字
		 */
		private function onUseText( e:MouseEvent ):void
		{
			_canvas = Sprite(e.currentTarget);
			var createNew:Boolean;
			if ( _lastTF )
			{
				if (_lastTF.parent.getBounds(_lastTF.parent.parent).contains( _canvas.mouseX, _canvas.mouseY ))
				{
					return;
				}else
				{
					createNew = true;
					_lastTF.removeEventListener( Event.CHANGE, onTextChanged );
					_lastTF.removeEventListener( Event.ADDED_TO_STAGE, onStageAdded );
					_lastTF.selectable = false;
					_lastTF.mouseEnabled = false;
					_lastTF.mouseChildren = false;
				}
			}else
			{
				createNew = true;
			}
			
			if ( !createNew ) return;
			
			var tf:EditableText = _lastTF = new EditableText();
			tf.text = "";
			tf.multiline = false;
			tf.textColor = DocToolData.color;
			tf.textAlign = TextFormatAlign.LEFT;
			tf.width = 200;
			tf.size = DocToolData.TEXT_SIZE;
			tf.addEventListener( Event.ADDED_TO_STAGE, onStageAdded );
			tf.addEventListener( Event.CHANGE, onTextChanged );
			tf.maxChars = 20;
			tf.x = _canvas.mouseX;
			tf.y = _canvas.mouseY;
			
			var tfSpr:Sprite = new Sprite();
			tfSpr.addChild(tf);

			_canvas.addChild(tfSpr);
			
			var percent:Number = _canvas.mouseX / _curWidth;
			var remoteX:int = percent * FACTOR;
			
			percent = _canvas.mouseY / _curHeight;
			var remoteY:int = percent * FACTOR;
		
			var tool:DocTextTool =  _bindDocument.room.newDocTextTool( DocToolData.color, 0, "微软雅黑"/*FIXME:暂时写死字体*/ );
			var rect:Rect = new Rect( new Point( remoteX, remoteY ), new Size(DocToolData.TEXT_SIZE,DocToolData.TEXT_SIZE));//FIXME:暂时不确定要这样设置文本大小

			_docText = _bindDocument.page.newDocText('', tool, rect );
			_docText.changePosition(rect);
			
			tf.id = _docText.id.toString();
			
			_localTextMapper.put( _docText.id, tf );
			_remoteTextMapper.put( _docText.id, _docText );
		}
		
		private function onStageAdded(e:Event):void 
		{
			e.currentTarget.removeEventListener(Event.ADDED_TO_STAGE, onStageAdded);
			_canvas.stage.focus = EditableText(e.currentTarget);
			callLater(function():void {
				EditableText(e.currentTarget).setSelection(0, 0);
				EditableText(e.currentTarget).setFocus();
			});
		}
		
		private function onTextChanged(e:Event):void 
		{
			var tf:EditableText = EditableText(e.currentTarget);
			var docText:DocText = _remoteTextMapper.getValue(tf.id);
			docText.text = tf.text;
		}
		
		/**
		 * 使用橡皮擦工具
		 * 开始擦除
		 * @param	e
		 */
		private function onUseEraser(e:MouseEvent):void
		{
			var lines:Array = _localLineMapper.getValues();
			var canvas:Sprite = Sprite(_pages[_curFrame].skinName);
			var num:int = canvas.numChildren; if (num == 0) return;
			var tf:*;
			var find:Boolean;
			for (var i:int = num - 1; i != -1; --i )
			{
				var target:Sprite = Sprite(canvas.getChildAt(i));
				var pClass:Class = getDefinitionByName('flash.geom.Point') as Class;
				var gp:* = target.localToGlobal((new pClass(target.mouseX, target.mouseY)));
				if (target.hitTestPoint(gp.x,gp.y))
				{
					if( target.numChildren > 0 )
					{
						tf = target.removeChildAt(0);
						tf.removeEventListener( Event.CHANGE, onTextChanged );
						tf.removeEventListener( Event.ADDED_TO_STAGE, onStageAdded );
					}
					
					if ( tf == _lastTF )
						_lastTF = null;
					target.graphics.clear();
					target.parent.removeChild(target);
					find = true;
					break;
				}
			}
			
			if ( find )
			{
				if ( !tf )
				{
					//删除线条
					var keys:Array = _localLineMapper.getKeys();
					for each( var key:* in keys )
					{
						if (_localLineMapper.getValue(key) == target )
						{
							_docLine = _remoteLineMapper.getValue( key );
							_localLineMapper.remove(key);
							_remoteLineMapper.remove(key);
							_docLine.purge();
							break;
						}
					}
				}else
				{
					//删除文本
					var docText:DocText = _remoteTextMapper.getValue( tf.id );
					_localTextMapper.remove(tf.id);
					_remoteTextMapper.remove(tf.id);
					docText.purge();
				}
			}
		}
		
		/**
		 * 使用铅笔工具
		 * 开始画线
		 */
		private var _canvas:Sprite;
		private function onUsePencil( e:MouseEvent ):void
		{
			_canvas = Sprite(e.currentTarget);
			_canvas.stage.addEventListener( MouseEvent.MOUSE_MOVE, onCanvasMove );
			_canvas.addEventListener( MouseEvent.MOUSE_UP, onCanvasUp );
			
			_line = new Sprite();
			_line.graphics.lineStyle( DocToolData.thickness, DocToolData.color );//FIXME:线条粗细需要根据画笔属性来设置
			_line.graphics.moveTo(_canvas.mouseX, _canvas.mouseY);
			_canvas.addChild( _line );
			
			//同步画图动作
			var pencil:DocPencilTool =  _bindDocument.room.newDocPencilTool( DocToolData.color, 0, 0, DocToolData.thickness );
			_docLine = _bindDocument.page.newDocLine( pencil );
			/**
			 * 如果直接同步本地的鼠标位置，远端模拟划线的时候会显示不正确，
			 * 因为不同的客户端的文档显示区域可能不一样，拿同样的点画出来
			 * 的线看起来也可能不一样，所以必须要约定一种方式，传递当前点
			 * 在画布中的百分比位置，远端根据这个约定，算出本机位置，再模拟。
			 */
			//_docLine.start( canvas.mouseX, canvas.mouseY );
			var percent:Number = _canvas.mouseX / _curWidth;
			var remoteX:int = percent * FACTOR;
			
			percent = _canvas.mouseY / _curHeight;
			var remoteY:int = percent * FACTOR;
			
			_localLineMapper.put( _docLine.id, _line );
			_remoteLineMapper.put(_docLine.id, _docLine);
			
			_docLine.start( remoteX, remoteY );
		}

		private function onCanvasMove(e:MouseEvent):void 
		{
			if ( _canvas.mouseX <= 0 || _canvas.mouseY <= 0 || _canvas.mouseX >= _curWidth || _canvas.mouseY >= _curHeight )
			{
				onCanvasUp(null); return;
			}

			_line.graphics.lineTo( _canvas.mouseX, _canvas.mouseY );
			
			var percent:Number = _canvas.mouseX / _curWidth;
			var remoteX:int = percent * FACTOR;
			
			percent = _canvas.mouseY / _curHeight;
			var remoteY:int = percent * FACTOR;
			
			_docLine.addPoint(remoteX, remoteY);
		}
		
		private function onCanvasUp(e:MouseEvent):void 
		{
			_canvas.stage.removeEventListener( MouseEvent.MOUSE_MOVE, onCanvasMove );
			_canvas.removeEventListener( MouseEvent.MOUSE_UP, onCanvasUp );
			_line.graphics.endFill();
			_canvas = null;
			_line = null;
			_docLine.end();
			_docLine = null;
		}
		
	}

}