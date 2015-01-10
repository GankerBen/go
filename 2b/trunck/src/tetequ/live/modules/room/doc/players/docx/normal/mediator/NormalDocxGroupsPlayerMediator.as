package tetequ.live.modules.room.doc.players.docx.normal.mediator 
{
	import robotlegs.bender.bundles.mvcs.Mediator;
	import tetequ.live.modules.loading.view.LoadingView;
	import tetequ.live.modules.loading.view.LoadingView2;
	import tetequ.live.modules.room.doc.players.common.CanvasManager;
	import tetequ.live.modules.room.doc.players.common.events.BindDocumentToCanvasEvent;
	import tetequ.live.modules.room.doc.players.common.events.CallPlayerEvent;
	import tetequ.live.modules.room.doc.players.common.events.DocCloseEvent;
	import tetequ.live.modules.room.doc.players.common.events.DocGotoEvent;
	import tetequ.live.modules.room.doc.players.common.MultiFramesContent;
	import tetequ.live.modules.room.doc.players.common.PlayerManager;
	import tetequ.live.modules.room.doc.players.common.StudentPlayerManager;
	import tetequ.live.modules.room.doc.players.docx.common.model.DocxDataCenter;
	import tetequ.live.modules.room.doc.players.docx.normal.view.NormalDocxGroupsPlayer;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class NormalDocxGroupsPlayerMediator extends Mediator 
	{
		[Inject]
		public var view:NormalDocxGroupsPlayer;
		
		[Inject]
		public var dataCenter:DocxDataCenter;
		
		[Inject]
		public var playerManager:StudentPlayerManager;
		
		[Inject]
		public var canvasManager:CanvasManager;
		
		[Inject]
		public var loading:LoadingView2;
		
		private var _data:MultiFramesContent;
		
		public function NormalDocxGroupsPlayerMediator() 
		{
			super();
			
		}
		
		/**
		 * 初始化
		 */
		override public function initialize():void
		{
			super.initialize();
			
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
			
			//调用播放器
			this.addContextListener( CallPlayerEvent.NORMAL_DOCX, onPlayerCalled, CallPlayerEvent );
			
			//设置文档对象
			this.addContextListener( BindDocumentToCanvasEvent.BIND_DOCUMENT, onBindDocument, BindDocumentToCanvasEvent );
			
			//文档翻页
			this.addContextListener( DocGotoEvent.NORMAL_DOCX, onDocGotoCalled, DocGotoEvent );
			
			//远程关闭本地播放器
			this.addContextListener( DocCloseEvent.CLOSE_DOCX_NORMAL, onDocCloseCalled, DocCloseEvent );
			
			//隐藏窗口的关闭按钮
			this.view.showCloseButton = false;
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
		 * 远程关闭本地播放器
		 * @param	e
		 */
		private function onDocCloseCalled(e:DocCloseEvent):void 
		{
			playerManager.closePlayerById( this.view.id );
		}
		
		/**
		 * 远端通知本地翻页
		 * @param	e
		 */
		private function onDocGotoCalled(e:DocGotoEvent):void 
		{
			view.setCurrentPage( e.pageNo );
			_data.gotoAndStop( e.pageNo );
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
		 * 播放多页静态文档
		 * @param	e
		 */
		private function onPlayerCalled(e:CallPlayerEvent):void 
		{
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

			_data.onLoadStart = onLoadStart;
			_data.onLoadComplete = onLoadComplete;
			
			/**
			 * 设置文档总页数
			 */
			view.setTotalPages( _data.totalFrames );
			
			/**
			 * 设置文档当前页
			 */
			view.setCurrentPage( 1 );
			
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
		 * 清除数据
		 */
		override public function destroy():void
		{
			this.removeContextListener( CallPlayerEvent.NORMAL_DOCX, onPlayerCalled, CallPlayerEvent );
			this.removeContextListener( DocGotoEvent.NORMAL_DOCX, onDocGotoCalled, DocGotoEvent );
			view = null;
			dataCenter = null;
			_data = null;
		}
		
	}

}