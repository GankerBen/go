package tetequ.live.modules.room.doc.common 
{
	
	/**
	 * ...
	 * @author Pandazhong
	 * 定义了flash与php进行文档交互的接口
	 */
	public interface IFileInfo 
	{
		function set name( value:String ):void;					//设置文件名
		function get name():String;								//获取文件名
		function set type( value:String ):void;					//设置文件类型
		function get type():String;								//获取文件类型
		function set path( value:String ):void;					//设置文件url
		function get path():String;								//获取文件url
		function set pages( value:int ):void;					//设置文件页数
		function get pages():int;								//获取文件页数
		function set id( value:String ):void;					//设置文档id
		function get id():String;								//获取文档id
	}
	
}