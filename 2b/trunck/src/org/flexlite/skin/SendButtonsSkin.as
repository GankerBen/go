package org.flexlite.skin
{
	import org.flexlite.domUI.components.StateSkin;
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.domUI.states.AddItems;
	import org.flexlite.domUI.states.State;

	/**
	 * @private
	 * 此类由编译器自动生成，您应修改对应的DXML文件内容，然后重新编译，而不应直接修改其代码。
	 * @author DXMLCompiler
	 */
	public class SendButtonsSkin extends org.flexlite.domUI.components.StateSkin
	{
		//==========================================================================
		//                                定义成员变量
		//==========================================================================
		public var __SendButtonsSkin_UIAsset1:org.flexlite.domUI.components.UIAsset;

		public var __SendButtonsSkin_UIAsset2:org.flexlite.domUI.components.UIAsset;

		public var __SendButtonsSkin_UIAsset3:org.flexlite.domUI.components.UIAsset;

		public var __SendButtonsSkin_UIAsset4:org.flexlite.domUI.components.UIAsset;

		public var __SendButtonsSkin_UIAsset5:org.flexlite.domUI.components.UIAsset;

		public var __SendButtonsSkin_UIAsset6:org.flexlite.domUI.components.UIAsset;

		public var __SendButtonsSkin_UIAsset7:org.flexlite.domUI.components.UIAsset;


		//==========================================================================
		//                                定义构造函数
		//==========================================================================
		public function SendButtonsSkin()
		{
			super();
			
			this.currentState = "up";
			this.height = 20;
			this.width = 31;
			this.elementsContent = [];
			__SendButtonsSkin_UIAsset1_i();
			__SendButtonsSkin_UIAsset2_i();
			__SendButtonsSkin_UIAsset3_i();
			__SendButtonsSkin_UIAsset4_i();
			__SendButtonsSkin_UIAsset5_i();
			__SendButtonsSkin_UIAsset6_i();
			__SendButtonsSkin_UIAsset7_i();
			
			
			states = [
				new org.flexlite.domUI.states.State ({name: "up",
					overrides: [
						new org.flexlite.domUI.states.AddItems().initializeFromObject({
							target:"__SendButtonsSkin_UIAsset1",
							propertyName:"",
							position:"last",
							relativeTo:""
						})
						,
						new org.flexlite.domUI.states.AddItems().initializeFromObject({
							target:"__SendButtonsSkin_UIAsset4",
							propertyName:"",
							position:"last",
							relativeTo:""
						})
						,
						new org.flexlite.domUI.states.AddItems().initializeFromObject({
							target:"__SendButtonsSkin_UIAsset5",
							propertyName:"",
							position:"last",
							relativeTo:""
						})
						,
						new org.flexlite.domUI.states.AddItems().initializeFromObject({
							target:"__SendButtonsSkin_UIAsset7",
							propertyName:"",
							position:"last",
							relativeTo:""
						})
					]
				})
				,
				new org.flexlite.domUI.states.State ({name: "over",
					overrides: [
						new org.flexlite.domUI.states.AddItems().initializeFromObject({
							target:"__SendButtonsSkin_UIAsset2",
							propertyName:"",
							position:"last",
							relativeTo:""
						})
						,
						new org.flexlite.domUI.states.AddItems().initializeFromObject({
							target:"__SendButtonsSkin_UIAsset3",
							propertyName:"",
							position:"last",
							relativeTo:""
						})
						,
						new org.flexlite.domUI.states.AddItems().initializeFromObject({
							target:"__SendButtonsSkin_UIAsset6",
							propertyName:"",
							position:"last",
							relativeTo:""
						})
					]
				})
				,
				new org.flexlite.domUI.states.State ({name: "down",
					overrides: [
						new org.flexlite.domUI.states.AddItems().initializeFromObject({
							target:"__SendButtonsSkin_UIAsset2",
							propertyName:"",
							position:"last",
							relativeTo:""
						})
						,
						new org.flexlite.domUI.states.AddItems().initializeFromObject({
							target:"__SendButtonsSkin_UIAsset3",
							propertyName:"",
							position:"last",
							relativeTo:""
						})
						,
						new org.flexlite.domUI.states.AddItems().initializeFromObject({
							target:"__SendButtonsSkin_UIAsset6",
							propertyName:"",
							position:"last",
							relativeTo:""
						})
					]
				})
				,
				new org.flexlite.domUI.states.State ({name: "disabled",
					overrides: [
						new org.flexlite.domUI.states.AddItems().initializeFromObject({
							target:"__SendButtonsSkin_UIAsset1",
							propertyName:"",
							position:"last",
							relativeTo:""
						})
						,
						new org.flexlite.domUI.states.AddItems().initializeFromObject({
							target:"__SendButtonsSkin_UIAsset4",
							propertyName:"",
							position:"last",
							relativeTo:""
						})
						,
						new org.flexlite.domUI.states.AddItems().initializeFromObject({
							target:"__SendButtonsSkin_UIAsset5",
							propertyName:"",
							position:"last",
							relativeTo:""
						})
						,
						new org.flexlite.domUI.states.AddItems().initializeFromObject({
							target:"__SendButtonsSkin_UIAsset7",
							propertyName:"",
							position:"last",
							relativeTo:""
						})
					]
				})
			];
		}


		//==========================================================================
		//                                定义成员方法
		//==========================================================================
		private function __SendButtonsSkin_UIAsset1_i():org.flexlite.domUI.components.UIAsset
		{
			var temp:org.flexlite.domUI.components.UIAsset = new org.flexlite.domUI.components.UIAsset();
			__SendButtonsSkin_UIAsset1 = temp;
			temp.bottom = 0;
			temp.left = 0;
			temp.right = 0;
			temp.skinName = "SWF__3BDFB93A";
			temp.top = 0;
			return temp;
		}

		private function __SendButtonsSkin_UIAsset2_i():org.flexlite.domUI.components.UIAsset
		{
			var temp:org.flexlite.domUI.components.UIAsset = new org.flexlite.domUI.components.UIAsset();
			__SendButtonsSkin_UIAsset2 = temp;
			temp.bottom = 0;
			temp.left = 0;
			temp.right = 0;
			temp.skinName = "SWF__BB792027";
			temp.top = 0;
			return temp;
		}

		private function __SendButtonsSkin_UIAsset3_i():org.flexlite.domUI.components.UIAsset
		{
			var temp:org.flexlite.domUI.components.UIAsset = new org.flexlite.domUI.components.UIAsset();
			__SendButtonsSkin_UIAsset3 = temp;
			temp.right = 0;
			temp.skinName = "SWF__908CFDC4";
			temp.y = 0;
			return temp;
		}

		private function __SendButtonsSkin_UIAsset4_i():org.flexlite.domUI.components.UIAsset
		{
			var temp:org.flexlite.domUI.components.UIAsset = new org.flexlite.domUI.components.UIAsset();
			__SendButtonsSkin_UIAsset4 = temp;
			temp.bottom = 0;
			temp.left = 0;
			temp.right = 0;
			temp.skinName = "SWF__F8AD937";
			temp.top = 0;
			return temp;
		}

		private function __SendButtonsSkin_UIAsset5_i():org.flexlite.domUI.components.UIAsset
		{
			var temp:org.flexlite.domUI.components.UIAsset = new org.flexlite.domUI.components.UIAsset();
			__SendButtonsSkin_UIAsset5 = temp;
			temp.bottom = 0;
			temp.left = 0;
			temp.right = 0;
			temp.skinName = "SWF__C06D558B";
			temp.top = 0;
			return temp;
		}

		private function __SendButtonsSkin_UIAsset6_i():org.flexlite.domUI.components.UIAsset
		{
			var temp:org.flexlite.domUI.components.UIAsset = new org.flexlite.domUI.components.UIAsset();
			__SendButtonsSkin_UIAsset6 = temp;
			temp.bottom = 0;
			temp.left = 0;
			temp.right = 0;
			temp.skinName = "SWF__908CFDC4";
			temp.top = 0;
			return temp;
		}

		private function __SendButtonsSkin_UIAsset7_i():org.flexlite.domUI.components.UIAsset
		{
			var temp:org.flexlite.domUI.components.UIAsset = new org.flexlite.domUI.components.UIAsset();
			__SendButtonsSkin_UIAsset7 = temp;
			temp.bottom = 0;
			temp.left = 0;
			temp.skinName = "SWF__32B44D5";
			temp.top = 0;
			temp.width = 31;
			return temp;
		}

	}
}