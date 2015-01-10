package tetequ.live.modules.room.doc.players.img.normal.mediator 
{
	import robotlegs.bender.bundles.mvcs.Mediator;
	import tetequ.live.modules.loading.view.LoadingView;
	import tetequ.live.modules.loading.view.LoadingView2;
	import tetequ.live.modules.room.doc.players.common.events.CallPlayerEvent;
	import tetequ.live.modules.room.doc.players.common.events.DocCloseEvent;
	import tetequ.live.modules.room.doc.players.common.StudentPlayerManager;
	import tetequ.live.modules.room.doc.players.img.common.IMGData;
	import tetequ.live.modules.room.doc.players.img.common.IMGDataCenter;
	import tetequ.live.modules.room.doc.players.img.normal.view.NormalSingleIMGGroupsPlayer;
	
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class NormalSIMGGPlayerMediator extends Mediator 
	{
		[Inject]
		public var view:NormalSingleIMGGroupsPlayer;
		
		[Inject]
		public var dataCenter:IMGDataCenter;
		
		[Inject]
		public var playerManager:StudentPlayerManager;
		
		[Inject]
		public var loading:LoadingView2;
		
		private var _data:IMGData;
		
		public function NormalSIMGGPlayerMediator() 
		{
			super();
			
		}
		
		override public function initialize():void
		{
			super.initialize();
			
			this.addContextListener( CallPlayerEvent.NORMAL_IMAGE, onPlayerCalled, CallPlayerEvent );
			
			//远程关闭
			this.addContextListener( DocCloseEvent.CLOSE_IMAGE_NORMAL, onRemoteClose, DocCloseEvent );
		}
		
		private function onRemoteClose(e:DocCloseEvent):void 
		{
			playerManager.closePlayerById( this.view.id );
		}
		
		override public function destroy():void
		{
			super.destroy();
			
			playerManager = null;
			_data = null;
			dataCenter = null;
			view = null;
			this.removeContextListener( CallPlayerEvent.NORMAL_IMAGE, onPlayerCalled, CallPlayerEvent );
			this.removeContextListener( DocCloseEvent.CLOSE_IMAGE_NORMAL, onRemoteClose, DocCloseEvent );
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
		 * 播放图片
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
				_data = dataCenter.getIMGData( e.fileInfo.path );
			}
			
			/**
			 * 设置播放器标题为文档名
			 */
			view.title = e.fileInfo.name;
			
			/**
			 * 打开了一个新的文档，注册到文档数据中心
			 */
			if ( !_data || !dataCenter.getIMGData( e.fileInfo.path ) )
			{
				dataCenter.registerIMGData( e.fileInfo );
			}
			
			/**
			 * 即将要播放的文档数据
			 */
			_data = dataCenter.getIMGData( e.fileInfo.path );
			
			/**
			 * 设置当前文档内容的尺寸变化回调
			 */
			_data.setResizeDelayCall( view.onStageResize );

			/**
			 * 替换显示内容为即将播放的文档
			 */
			view.setVisualContent( _data );
			_data.onLoadComplete = onLoadComplete;
			_data.onLoadStart = onLoadStart;
			_data.startup();
			
			/**
			 * 强制刷新文档内容尺寸适应播放器尺寸
			 */
			view.onStageResize();
		}
		
	}

}