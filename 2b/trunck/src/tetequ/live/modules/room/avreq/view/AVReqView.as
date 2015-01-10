package tetequ.live.modules.room.avreq.view 
{
	import com.e2et.datalogic.AVReq;
	import com.e2et.datalogic.User;
	import org.flexlite.domUI.components.Group;
	import org.flexlite.domUI.layouts.VerticalLayout;
	import tetequ.live.utils.HashMap;
	
	/**
	 * ...
	 * @author Pandazhong
	 * 发言申请消息显示界面
	 */
	public class AVReqView extends Group 
	{
		private var _reqs:HashMap;
		private var _reqsGroup:Group;
		
		public function AVReqView() 
		{
			super();
			initComponents();
		}
		
		private function initComponents():void 
		{
			addElement( _reqsGroup = new Group() );
			_reqsGroup.layout = new VerticalLayout();
			_reqs = new HashMap();
		}
		
		public function addAVReq( avReq:AVReq, yesCallback:Function, noCallback:Function ):void
		{
			if ( !_reqs.containsKey( avReq.user.userid ) )
			{
				var item:AVReqItem = new AVReqItem( avReq, yesCallback, noCallback );
				_reqs.put( avReq.user.userid, item );
				_reqsGroup.addElement( item );
			}
		}
		
		public function delAVReq( avReq:AVReq ):void
		{
			if ( _reqs.containsKey( avReq.user.userid ) )
			{
				var item:AVReqItem = _reqs.getValue( avReq.user.userid );
				_reqsGroup.removeElement( item );
				_reqs.remove( avReq.user.userid );
			}
		}
	}

}