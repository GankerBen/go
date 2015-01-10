package tetequ.live.modules.room.doc.players.ppt.normal.mediator 
{
	import com.e2et.datalogic.DocPage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import framework.view.UIRoot;
	import org.flexlite.domUI.components.Alert;
	import org.flexlite.domUI.events.CloseEvent;
	import robotlegs.bender.bundles.mvcs.Mediator;
	import tetequ.live.core.network.NetworkFacade;
	import tetequ.live.modules.loading.view.LoadingView;
	import tetequ.live.modules.loading.view.LoadingView2;
	import tetequ.live.modules.room.doc.players.common.CanvasManager;
	import tetequ.live.modules.room.doc.players.common.events.BindDocumentToCanvasEvent;
	import tetequ.live.modules.room.doc.players.common.events.CallPlayerEvent;
	import tetequ.live.modules.room.doc.players.common.events.DocCloseEvent;
	import tetequ.live.modules.room.doc.players.common.events.DocGotoEvent;
	import tetequ.live.modules.room.doc.players.common.MasterPlayerManager;
	import tetequ.live.modules.room.doc.players.common.StudentPlayerManager;
	import tetequ.live.modules.room.doc.players.docx.common.model.DocxDataCenter;
	import tetequ.live.modules.room.doc.players.docx.master.view.MasterDocxGroupsPlayer;
	import tetequ.live.modules.room.doc.players.ppt.common.PPTData;
	import tetequ.live.modules.room.doc.players.ppt.common.PPTDataCenter;
	import tetequ.live.modules.room.doc.players.ppt.master.view.MasterPPTPlayer;
	import tetequ.live.modules.room.doc.players.ppt.normal.view.NormalPPTPlayer;
	import tetequ.live.modules.room.doc.tools.events.DocToolEvent;
	import tetequ.live.modules.room.doc.tools.view.DocToolView;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 主讲版本的PPT动画文档播放器中介者
	 */
	public class NormalPPTPlayerMediator extends Mediator 
	{
		[Inject]
		public var view:NormalPPTPlayer;
		
		[Inject]
		public var dataCenter:PPTDataCenter;
		
		[Inject]
		public var networkFacade:NetworkFacade;
		
		[Inject]
		public var uiroot:UIRoot;
		
		[Inject]
		public var playerManager:StudentPlayerManager;
		
		[Inject]
		public var canvasManager:CanvasManager;
		
		[Inject]
		public var loading:LoadingView2;
		
		private var _data:PPTData;
		
		private var _enabledCanvas:Boolean;
		
		public function NormalPPTPlayerMediator() 
		{
			super();
		}
		
		/**
		 * 当view被添加到舞台时，mediator被创建，并调用该方法
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
			
			//文档调用
			this.addContextListener( CallPlayerEvent.NORMAL_PPT, onPlayerCalled, CallPlayerEvent );
			
			//设置文档对象
			this.addContextListener( BindDocumentToCanvasEvent.BIND_DOCUMENT, onBindDocument, BindDocumentToCanvasEvent );
			
			//文档翻页
			this.addContextListener( DocGotoEvent.NORMAL_PPT, onDocGotoCalled, DocGotoEvent );
			
			//远程关闭播放器
			this.addContextListener( DocCloseEvent.CLOSE_PPT_NORMAL, onDocCloseCalled, DocCloseEvent );
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
		 * 文档翻页(远端通知本地翻页)
		 * @param	e
		 */
		private function onDocGotoCalled(e:DocGotoEvent):void 
		{
			_data.gotoAndStop( e.pageNo - 1, e.pageStep );
			this.view.labelCurPage.text = e.pageNo.toString();
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
			//if ( networkFacade.hasToken )
			//{
				//uiroot.addElement( DocToolView.getInstance() );
			//}else
			//{
				//if (uiroot.containsElement(DocToolView.getInstance()))
				//{
					//uiroot.removeElement(DocToolView.getInstance());
				//}
			//}
			
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
			
			/**
			 * 设置当前文档内容的动画改变回调
			 */
			_data.onAnimationChanged( changedCallback );
			
			/**
			 * 设置当前文档内容的动画初始化完毕时回调
			 */
			_data.onAnimationInited( initCallback );
			
			/**
			 * 下一步时回调
			 */
			_data.onNextStep( nextStepCallback );
			
			/**
			 * 是否禁用画布
			 */
			_data.enabledCanvas(_enabledCanvas);
			
			_data.onLoadStart = onLoadStart;
			_data.onLoadComplete = onLoadComplete;
			_data.startLoad();
			
			/**
			 * 替换显示内容为即将播放的文档
			 */
			view.setVisualContent( _data );
			
			/**
			 * 默认跳转至新文档的第一页
			 */
			//_data.gotoAndStop( 0, 0 );
			
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
		 * PPT文档翻页、下一步时回调的方法
		 * @param	frame
		 * @param	step
		 */
		private function changedCallback( frame:int, step:uint ):void
		{
			trace( "PPT文档：", frame, step );
			if(networkFacade.hasToken)
				networkFacade.gotoPage(frame, step);
			this.view.labelCurPage.text = '' + (frame + 1);
		}
		
		/**
		 * PPT文档初始化完毕后回调的方法
		 * @param	totalframes
		 */
		private function initCallback( totalframes:uint ):void
		{
			trace( '总共', totalframes, "页！" );
			this.view.labelPageTotal.text = totalframes.toString();
			view.onStageResize();
		}
		
		/**
		 * 下一步回调
		 */
		private function nextStepCallback():void
		{
			if ( networkFacade.hasToken )
			{
				_data.nextStep();
			}
		}
		
		/**
		 * 进行清理操作
		 */
		override public function destroy():void
		{
			this.removeContextListener( CallPlayerEvent.NORMAL_PPT, onPlayerCalled, CallPlayerEvent );
			this.removeContextListener( BindDocumentToCanvasEvent.BIND_DOCUMENT, onBindDocument, BindDocumentToCanvasEvent );
			this.removeContextListener( DocGotoEvent.NORMAL_PPT, onDocGotoCalled, DocGotoEvent );
			this.removeContextListener( DocCloseEvent.CLOSE_PPT_NORMAL, onDocCloseCalled, DocCloseEvent );
		
			_data = null;
			view = null;
			dataCenter = null;
			networkFacade = null;
		}
		
	}

}