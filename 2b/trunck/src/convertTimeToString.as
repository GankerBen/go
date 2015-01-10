package  
{
	/**
	 * 将指定毫秒转换成如'00(时):00(分):00(秒)'的形式
	 * @param	ms
	 */
	public function convertTimeToString(ms:uint):String
	{
		var h:int = int(ms / (1000 * 3600));
		var m:int = int((ms - h * 1000 * 3600) / (60 * 1000) );
		var s:int = int( (ms - m * 60 * 1000 - h * 3600 * 1000 ) / 1000 );
		
		function convertUnit( u:int ):String
		{
			return u >= 10 ? u.toString() : "0" + u.toString();
		}
		
		return convertUnit( h ) + ":" + convertUnit( m ) + ":" + convertUnit( s );
	}
}