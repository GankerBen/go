package tetequ.live.modules.room.doc.players.docx.master.mediator 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import framework.view.UIRoot;
	import org.flexlite.domUI.components.Alert;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.events.CloseEvent;
	import robotlegs.bender.bundles.mvcs.Mediator;
	import tetequ.live.core.network.NetworkFacade;
	import tetequ.live.modules.loading.view.LoadingView;
	import tetequ.live.modules.loading.view.LoadingView2;
	import tetequ.live.modules.room.common.GlobalVars;
	import tetequ.live.modules.room.doc.players.common.CanvasManager;
	import tetequ.live.modules.room.doc.players.common.events.BindDocumentToCanvasEvent;
	import tetequ.live.modules.room.doc.players.common.events.CallPlayerEvent;
	import tetequ.live.modules.room.doc.players.common.events.DocCloseEvent;
	import tetequ.live.modules.room.doc.players.common.events.DocGotoEvent;
	import tetequ.live.modules.room.doc.players.common.MasterPlayerManager;
	import tetequ.live.modules.room.doc.players.common.MultiFramesContent;
	import tetequ.live.modules.room.doc.players.docx.common.model.DocxDataCenter;
	import tetequ.live.modules.room.doc.players.docx.master.view.MasterDocxGroupsPlayer;
	import tetequ.live.modules.room.doc.tools.view.DocToolView;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 主讲版本的普通文档播放器中介者
	 */
	public class MasterDocxGroupsPlayerMediator extends Mediator 
	{
		[Inject]
		public var view:MasterDocxGroupsPlayer;
		
		[Inject]
		public var dataCenter:DocxDataCenter;
		
		[Inject]
		public var networkFacade:NetworkFacade;
		
		[Inject]
		public var uiroot:UIRoot;
		
		[Inject]
		public var playerManager:MasterPlayerManager;
		
		[Inject]
		public var canvasManager:CanvasManager;
		
		private var _data:MultiFramesContent;
		
		[Inject]
		public var loading:LoadingView2;
		
		public function MasterDocxGroupsPlayerMediator() 
		{
			super();
		}
		
		/**
		 * 当view被添加到舞台时，mediator被创建，并调用该方法
		 */
		override public function initialize():void
		{
			super.initialize();
			this.view.network = networkFacade;
			/**
			 * robotlegs2.0中的mediator会随着view添加到舞台而自动被创建，随着view从舞台移除自动销毁
			 * 在这里，当view第一次被创建时，外部会传递事件给mediator，view的相关数据被初始化，而以后
			 * view可能只是和其他UI动态交换位置，当view从舞台上移除时，当前的mediator会被销毁，_data字段
			 * 被清除，当下一次view再添加到舞台时，_data数据需要从外界重新获取，在此之前，view的相关数据
			 * 其实已经初始化好了，而mediator不再是前一次的mediator的，而是全新的mediator，此时
			 */
			if ( !_data && view.getVisualContent() )
			{
				_data = dataCenter.getDocument( view.getVisualContent().getSource() );
			}
			
			//文档调用
			this.addContextListener( CallPlayerEvent.MASTER_DOCX, onPlayerCalled, CallPlayerEvent );
			
			//设置文档对象
			this.addContextListener( BindDocumentToCanvasEvent.BIND_DOCUMENT, onBindDocument, BindDocumentToCanvasEvent );
			
			//文档翻页
			this.addContextListener( DocGotoEvent.MASTER_DOCX, onDocGotoCalled, DocGotoEvent );
			
			//远程关闭播放器
			this.addContextListener( DocCloseEvent.CLOSE_DOCX_MASTER, onDocCloseCalled, DocCloseEvent );
			
			this.addContextListener( TokenChangedEvent.TOKEN_CHANGED, onTokenChanged, TokenChangedEvent );
			
			//文档操作
			this.view.getBtnNext().addEventListener( MouseEvent.CLICK, onNextPage );
			this.view.getBtnPrev().addEventListener( MouseEvent.CLICK, onPrevPage );
			this.view.getInputPageNum().addEventListener( Event.CHANGE, onInputChanged );

			//本地关闭播放器
			this.view.addEventListener( CloseEvent.CLOSE, onCloseCalled );
		}
		
		private function onTokenChanged(e:TokenChangedEvent):void 
		{
			//如果是主讲 打开画笔工具
			if ( networkFacade.hasToken )
			{
				this.view.addElement( DocToolView.getInstance() );
			}else
			{
				if (this.view.containsElement(DocToolView.getInstance()))
				{
					this.view.removeElement(DocToolView.getInstance());
				}
			}
		}
		
		/**
		 * 绑定文档到绘图层
		 * @param	e
		 */
		private function onBindDocument(e:BindDocumentToCanvasEvent):void 
		{
			_data.bindDocument = e.doc;
			canvasManager.registerCanvas( e.doc, _data.getCanvas() );
		}
		
		/**
		 * 远程关闭本地文档
		 * @param	e
		 */
		private function onDocCloseCalled(e:DocCloseEvent):void 
		{
			playerManager.closePlayerById( this.view.id );
		}
		
		/**
		 * 关闭播放器
		 * @param	e
		 */
		private function onCloseCalled(e:CloseEvent):void 
		{
			if ( !networkFacade.hasToken )
			{
				if (GlobalVars.language == GlobalVars.LANG_ENGLISH)
				{
					//英文
					Alert.show( "Sorry, you do not have permission, you can not close the document!" );
				}else if(GlobalVars.language == GlobalVars.LANG_CHINESE)
				{
					//中文
					Alert.show( "对不起，您没有权限，不能关闭文档!" );
				}else
				{
					throw new Error('无法识别的语言！');
				}
				return;
			}
			
			networkFacade.closePrevDoc();
			playerManager.closePlayerById( this.view.id );
		}
		
		/**
		 * 文档翻页(远端通知本地翻页)
		 * @param	e
		 */
		private function onDocGotoCalled(e:DocGotoEvent):void 
		{
			view.getInputPageNum().text = e.pageNo.toString();
			_data.gotoAndStop( e.pageNo );
		}
		
		/**
		 * 处理文档调用请求
		 * 注意：该方法在第一次
		 * 调用时，会初始化播放器view
		 * 的相关数据，同时初始化mediator
		 * 的_data字段，而当view被移除舞台然后
		 * 再次添加到舞台时，view的相关数据不再需要
		 * 初始化了，而此刻的mediator则是全新的，_data
		 * 字段需要重新初始化。
		 * [PS:robotlegs2.0框架中，mediator会随着view添加到舞台而自动被创建，
		 * 随着view移除舞台而自动被销毁]
		 * @param	e
		 */
		private function onPlayerCalled(e:CallPlayerEvent):void 
		{
			//如果是主讲 打开画笔工具
			if ( networkFacade.hasToken )
			{
				this.view.addElement( DocToolView.getInstance() );
			}else
			{
				if (this.view.containsElement(DocToolView.getInstance()))
				{
					this.view.removeElement(DocToolView.getInstance());
				}
			}
			
			/**
			 * 文档播放请求时，可能是由于选择了与当前文档
			 * 不同的其他文档，此时，播放器的可视内容是存在
			 * 的，只是_data需要重新获取，因为此时_data将不再
			 * 是当前正在播放文档的data
			 */
			if ( view.getVisualContent() ) {
				_data = dataCenter.getDocument( e.fileInfo.path );
			}
			
			/**
			 * 设置播放器标题为文档名
			 */
			view.title = e.fileInfo.name;
			
			/**
			 * 打开了一个新的文档，注册到文档数据中心
			 */
			if ( !_data || !dataCenter.getDocument( e.fileInfo.path ) )
			{
				dataCenter.registerDocument( e.fileInfo );
			}
			
			/**
			 * 即将要播放的文档数据
			 */
			_data = dataCenter.getDocument( e.fileInfo.path );
			
			/**
			 * 设置当前文档内容的尺寸变化回调
			 */
			_data.setResizeDelayCall( view.onStageResize );
			
			//通过添加加载等待界面，尝试优化加载文档时的用户体验
			_data.onLoadStart = onLoadStart;
			_data.onLoadComplete = onLoadComplete;
			
			/**
			 * 设置文档总页数
			 */
			view.getLabelPageTotal().text = _data.totalFrames.toString();
			
			/**
			 * 设置文档的输入区域的页码
			 */
			view.getInputPageNum().text = "1";
			
			/**
			 * 替换显示内容为即将播放的文档
			 */
			view.setVisualContent( _data );
			
			/**
			 * 默认跳转至新文档的第一页
			 */
			_data.gotoAndStop( 1 );
			
			/**
			 * 强制刷新文档内容尺寸适应播放器尺寸
			 */
			view.onStageResize();
		}
		
		/**
		 * 移除加载等待界面
		 */
		private function onLoadComplete():void
		{
			if (this.view)
			{
				if (this.view.containsElement(loading))
				{
					this.view.removeElement(loading);
				}
			}
		}
		
		/**
		 * 添加加载等待界面
		 */
		private function onLoadStart():void
		{
			if(this.view)
			{
				this.view.addElement(loading);
			}
		}
		
		/**
		 * 文本输入框内容发生改变
		 * @param	e
		 */
		private function onInputChanged( e:Event ):void 
		{
			//if ( !networkFacade.hasToken )
			//{
				//Alert.show( "对不起，您没有权限，不能翻页!" );
				//this.view.getInputPageNum().text = _data.currentFrame.toString();
				//return;
			//}
			
			var totalPages:int = _data.totalFrames;
			var currentPage:int = _data.currentFrame;
			var inputPage:int = parseInt( this.view.getInputPageNum().text );
			
			if ( inputPage < 1 || inputPage > totalPages ) 
			{
				this.view.getInputPageNum().text = currentPage.toString();
				return;
			}
			
			if(networkFacade.hasToken)
				networkFacade.gotoPage( inputPage - 1/** 内部页码比UI页码少1 **/ );//FIXME:此处只是简单地将翻页动作同步出去
			
			_data.gotoAndStop( inputPage );
		}
		
		/**
		 * 上一页
		 * @param	e
		 */
		private function onPrevPage( e:MouseEvent ):void 
		{
			//if ( !networkFacade.hasToken )
			//{
				//Alert.show( "对不起，您没有权限，不能翻页!" );
				//return;
			//}
			
			var totalPages:int = _data.totalFrames;
			var currentPage:int = _data.currentFrame;
			
			if ( currentPage == 1 ) return;
			this.view.getInputPageNum().text = (--currentPage).toString();
			
			if(networkFacade.hasToken)
				networkFacade.gotoPage( _data.currentFrame - 1/** 在当前页基础上递减1 **/ - 1/** 内部页码比UI页码少1 **/ );//FIXME:此处只是简单地将翻页动作同步出去
			
			_data.prevFrame();
		}
		
		/**
		 * 下一页
		 * @param	e
		 */
		private function onNextPage( e:MouseEvent ):void 
		{
			//if ( !networkFacade.hasToken )
			//{
				//Alert.show( "对不起，您没有权限，不能翻页!" );
				//return;
			//}
			
			var totalPages:int = _data.totalFrames;
			var currentPage:int = _data.currentFrame;
			
			if ( currentPage == totalPages ) return;
			this.view.getInputPageNum().text = (++currentPage).toString();
			
			if(networkFacade.hasToken)
				networkFacade.gotoPage( _data.currentFrame + 1/** 在当前页基础上递增1 **/ - 1/** 内部页码比UI页码少1 **/ );//FIXME:此处只是简单地将翻页动作同步出去
			
			_data.nextFrame();
		}
		
		/**
		 * 进行清理操作
		 */
		override public function destroy():void
		{
			this.removeContextListener( CallPlayerEvent.MASTER_DOCX, onPlayerCalled, CallPlayerEvent );
			this.removeContextListener( BindDocumentToCanvasEvent.BIND_DOCUMENT, onBindDocument, BindDocumentToCanvasEvent );
			this.removeContextListener( DocGotoEvent.MASTER_DOCX, onDocGotoCalled, DocGotoEvent );
			this.removeContextListener( DocCloseEvent.CLOSE_DOCX_MASTER, onDocCloseCalled, DocCloseEvent );
			this.removeContextListener( TokenChangedEvent.TOKEN_CHANGED, onTokenChanged, TokenChangedEvent );
			this.view.getBtnNext().removeEventListener( MouseEvent.CLICK, onNextPage );
			this.view.getBtnPrev().removeEventListener( MouseEvent.CLICK, onPrevPage );
			this.view.getInputPageNum().removeEventListener( Event.CHANGE, onInputChanged );
			this.view.removeEventListener( CloseEvent.CLOSE, onCloseCalled );
			if ( this.view.containsElement(DocToolView.getInstance()))
			{
				this.view.removeElement(DocToolView.getInstance());
			}
			_data = null;
			view = null;
			dataCenter = null;
			networkFacade = null;
		}
		
	}

}