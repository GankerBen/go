package tetequ.live.modules.room.common 
{
	import flash.events.IEventDispatcher;
	import flash.external.ExternalInterface;
	import flash.filters.DropShadowFilter;
	import framework.view.UIRoot;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.domUI.core.IVisualElement;
	import org.flexlite.domUI.core.UIComponent;
	import tetequ.live.core.assets.AssetsFactory;
	import tetequ.live.core.network.NetworkFacade;
	import tetequ.live.modules.room.doc.doclist.network.WebServerManager;
	/**
	 * ...
	 * @author Pandazhong
	 * 应用程序全局变量，PS:全局变量不能多用
	 */
	public class GlobalVars 
	{
		/***********************************************通用****************************************************/
		
		public static const LANG_CHINESE:String = "cn_";
		public static const LANG_ENGLISH:String = "en_";
		public static const MAX_FACE_INDEX:int = 30;
		public static const LAYOUT_ELEMENT_FILTERS:DropShadowFilter = new DropShadowFilter( 0, 0, 0, 0.1, 2, 2, 10 );
		
		public static var language:String = LANG_CHINESE;// FIXME:测试
		public static var networkFacade:NetworkFacade;
		public static var eventDispatcher:IEventDispatcher;
		public static var userId:String = Math.random().toString();
		public static var idleAnimation:IVisualElement;
		public static var webServer:WebServerManager;
		public static var avdoc:Group;
		public static var av:Group;
		public static var doc:Group;
		public static var media:IVisualElement;
		public static var document:UIComponent;
		public static var centerGroup:Group;
		public static var leftGroup:Group;
		public static var topUri:String = "";
		public static var videoId:String = null;
		public static var scene:UIAsset;
		public static var avnum:int;
		public static var version:String = "1.0.0.201409091457";
		public static var uiroot:UIRoot;
		
		//文档上传到的地址key
		public static const DOC_UPLOAD_KEY:String = '520';

		//机构logo，默认是bukav的logo
		public static var orgLogoUri:String = 'http://www.bukav.com/statics/image/bukav/mascot_260.png?' + Math.random() * 1000;
		//public static var orgLogoUri:String = 'http://img4.imgtn.bdimg.com/it/u=2028098202,2749336058&fm=21&gp=0.jpg';
		
		//机构名字
		public static var orgName:String = 'buka';
		
		//房间最多上传几路视频，默认4
		public static var max_av_num:uint = 4;
		
		//每个参与者(老师、学生)最多上传几路视频，默认2
		public static var per_actor_av_num:uint = 2;
		
		//每个游客最多上传几路视频，默认0
		public static var per_visitor_av_num:uint = 0;
		
		/**
		 * 是否需要聊天模块
		 */
		public static var hasChat:Boolean = true;
		
		public static var my_first_publish:Boolean = true;
		public static var last_invited:Boolean = false;
		
		/*******************************************************定制***************************************************/
		
		//三好互动
		//密钥结尾
		public static var key_result:String = 'whoisyourdaddyohohohoho2014';
		public static var user_session:String = 'dummy_user_session';
		public static var room_id:String = 'dummy_room_id';
		
		public static function getIcon(fileType:String):*
		{
			switch( fileType )
			{
				case ".docx":
					return AssetsFactory.getInstance().getAsset('icon_docx');
				case ".flv":
					return AssetsFactory.getInstance().getAsset('icon_mov');
				case ".mp4":
					return AssetsFactory.getInstance().getAsset('icon_mpeg');
				case ".mp3":
					return AssetsFactory.getInstance().getAsset('icon_mp3');
				case ".doc":
					return AssetsFactory.getInstance().getAsset('icon_doc');
				case ".ppt":
					return AssetsFactory.getInstance().getAsset('icon_ppt');
				case ".pptx":
					return AssetsFactory.getInstance().getAsset('icon_pptx');
				case ".pdf":
					return AssetsFactory.getInstance().getAsset('icon_pdf');
				case ".JPG":
					return AssetsFactory.getInstance().getAsset('icon_jpeg');
				case ".jpg":
					return AssetsFactory.getInstance().getAsset('icon_jpeg');
				case ".png":
					return AssetsFactory.getInstance().getAsset('icon_png');
				case ".f4v":
					return AssetsFactory.getInstance().getAsset('icon_mov');
				case ".gif":
					return AssetsFactory.getInstance().getAsset('icon_gif');
				case ".ttq":
					return AssetsFactory.getInstance().getAsset('icon_pptx');
					break;
				default:
					return AssetsFactory.getInstance().getAsset('icon_gif');
					break;
			}
		}
	}

}