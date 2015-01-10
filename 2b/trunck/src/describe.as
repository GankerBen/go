package  
{
	import flash.utils.describeType;
	
	/**
	 * 遍历目标所有的公开属性，并以值对形式返回字符串
	 * @param	any
	 * @return
	 */
	public function describe(any:*):String
	{
		var message:String = '';
		var list:XMLList = describeType(any).accessor;
		for (var i:int = 0, len:int = list.length(); i != len; ++i)
		{
			var xml:XML = list[i];
			var name:String = xml.@name;
			message += '\n';
			message += name + ':' + any[name];
		}
		
		return message;
	}
}