package tetequ.live.modules.room.doc.players.img.common 
{
	import tetequ.live.modules.room.doc.common.IFileInfo;
	import tetequ.live.utils.HashMap;
	/**
	 * ...
	 * @author Pandazhong
	 */
	public class IMGDataCenter 
	{
		private var _data:HashMap;
		
		public function IMGDataCenter() 
		{
			_data = new HashMap();
		}
		
		public function registerIMGData( metadata:IFileInfo ):void
		{
			if( !_data.containsKey( metadata.path ) )
				_data.put( metadata.path, new IMGData( metadata ) );
		}
		
		public function getIMGData( path:String ):IMGData
		{
			return _data.getValue( path );
		}
		
	}

}