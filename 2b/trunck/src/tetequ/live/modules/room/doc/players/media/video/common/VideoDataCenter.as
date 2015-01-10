package tetequ.live.modules.room.doc.players.media.video.common 
{
	import tetequ.live.modules.room.doc.common.IFileInfo;
	import tetequ.live.utils.HashMap;
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class VideoDataCenter 
	{
		private var _data:HashMap;
		
		public function VideoDataCenter() 
		{
			_data = new HashMap();
		}
		
		public function registerVideoData( metadata:IFileInfo ):void
		{
			if( !_data.containsKey( metadata.path ) )
				_data.put( metadata.path, new VideoData( metadata ) );
		}
		
		public function getVideoData( path:String ):VideoData
		{
			return _data.getValue( path );
		}
		
	}

}