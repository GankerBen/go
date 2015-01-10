package tetequ.live.modules.room.doc.players.media.audio.common 
{
	import tetequ.live.modules.room.doc.common.IFileInfo;
	import tetequ.live.utils.HashMap;
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class AudioDataCenter 
	{
		private var _data:HashMap;
		
		public function AudioDataCenter() 
		{
			_data = new HashMap();
		}
		
		public function registerAudioData( metadata:IFileInfo ):void
		{
			if( !_data.containsKey( metadata.path ) )
				_data.put( metadata.path, new AudioData( metadata ) );
		}
		
		public function getAudioData( path:String ):AudioData
		{
			return _data.getValue( path );
		}
		
	}

}