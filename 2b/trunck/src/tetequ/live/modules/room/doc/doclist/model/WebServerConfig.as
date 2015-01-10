package tetequ.live.modules.room.doc.doclist.model
{
	public class WebServerConfig
	{
		/**
		 * 文档列表相关数据的web服务器地址
		 */	
		public static const CONNECT_WEB_URL:String = "http://doc.tetequ.com/";
		//public static const CONNECT_WEB_URL:String = "http://106.3.36.212/";
		
		/**
		 * 文档下载代理服务器1
		 */	
		public static const CONNECT_WEB_URL2:String = 'http://222.222.194.134/';
		
		/**
		 * 文档下载代理服务器2
		 */
		public static const CONNECT_WEB_URL3:String = 'http://118.26.146.78:2080/';
		
		/**
		 * 获取文档列表脚本地址
		 * 带上用户的userID参数
		 */	
		public static const FILES_LIST_URL:String = "doclist.php";
		
		/**
		 * 上传文件地址
		 */
		public static const FILES_UPLOAD_URL:String = "upload.php?roomNO=";
		
		/**
		 * 上传文件地址2
		 */
		public static const FILES_UPLOAD_URL2:String = "upload2.php?roomNO=";
		
		/**
		 * 上传文件地址3
		 */
		public static const FILES_UPLOAD_URL3:String = "upload3.php?roomNO=";

		/**
		 * 删除文件
		 * ?id文档id
		 */		
		public static const FILES_DELETE_URL:String = "delete.php";
	}
}