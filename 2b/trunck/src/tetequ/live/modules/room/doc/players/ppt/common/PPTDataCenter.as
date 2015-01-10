package tetequ.live.modules.room.doc.players.ppt.common 
{
	import tetequ.live.modules.room.doc.common.IFileInfo;
	import tetequ.live.modules.room.doc.players.common.DocumentFrameStepper;
	import tetequ.live.modules.room.doc.players.common.interfaces.IFrameStep;
	import tetequ.live.utils.HashMap;
	/**
	 * ...
	 * @author Pandazhong
	 * PPT动画文档数据中心
	 */
	public class PPTDataCenter 
	{
		private var _dataset:HashMap;		//_dataset.put( data.url : String, data : DocxData );
		
		/**
		 * 构造函数
		 */
		public function PPTDataCenter() 
		{
			initialization();
		}
		
		/**
		 * 初始化
		 */
		private function initialization():void 
		{
			_dataset = new HashMap();
		}
		
		/**
		 * 注册一个文档信息
		 * @param	metadata
		 */
		public function registerDocument( metadata:IFileInfo ):void
		{
			if ( _dataset.containsKey( metadata.path ) ) return;
			
			var stepper:IFrameStep 		= 		new PPTFramesStepper( metadata.path, metadata.pages, -1 );
			var docxData:PPTData		=		new PPTData( metadata, stepper );
			
			_dataset.put( metadata.path, docxData );
		}
		
		/**
		 * 撤销一个文档信息
		 * @param	url
		 */
		public function unregisterDocument( url:String ):void
		{
			if ( _dataset.containsKey( url ) )
			{
				_dataset.remove( url );
				
				//FIXME:可能还需要调用文档信息的dispose来完成彻底的清除工作，这部分接口暂时没写。
			}
		}
		
		/**
		 * 根据url获取文档数据
		 * @param	url
		 */
		public function getDocument( url:String ):PPTData
		{
			if ( _dataset.containsKey( url ) )
			{
				return _dataset.getValue( url );
			}
			
			return null;
		}
		
	}

}