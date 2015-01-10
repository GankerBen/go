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
	public class VideoToggleButtonSkin extends org.flexlite.domUI.components.StateSkin
	{
		//==========================================================================
		//                                定义成员变量
		//==========================================================================
		public var __VideoToggleButtonSkin_UIAsset1:org.flexlite.domUI.components.UIAsset;

		public var __VideoToggleButtonSkin_UIAsset2:org.flexlite.domUI.components.UIAsset;

		public var __VideoToggleButtonSkin_UIAsset3:org.flexlite.domUI.components.UIAsset;

		public var __VideoToggleButtonSkin_UIAsset4:org.flexlite.domUI.components.UIAsset;


		//==========================================================================
		//                                定义构造函数
		//==========================================================================
		public function VideoToggleButtonSkin()
		{
			super();
			
			this.currentState = "up";
			this.height = 16;
			this.width = 16;
			this.elementsContent = [__VideoToggleButtonSkin_UIAsset2_i()];
			__VideoToggleButtonSkin_UIAsset1_i();
			__VideoToggleButtonSkin_UIAsset3_i();
			__VideoToggleButtonSkin_UIAsset4_i();
			
			
			states = [
				new org.flexlite.domUI.states.State ({name: "up",
					overrides: [
						new org.flexlite.domUI.states.AddItems().initializeFromObject({
							target:"__VideoToggleButtonSkin_UIAsset1",
							propertyName:"",
							position:"before",
							relativeTo:"__VideoToggleButtonSkin_UIAsset2"
						})
						,
						new org.flexlite.domUI.states.AddItems().initializeFromObject({
							target:"__VideoToggleButtonSkin_UIAsset4",
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
							target:"__VideoToggleButtonSkin_UIAsset1",
							propertyName:"",
							position:"before",
							relativeTo:"__VideoToggleButtonSkin_UIAsset2"
						})
						,
						new org.flexlite.domUI.states.AddItems().initializeFromObject({
							target:"__VideoToggleButtonSkin_UIAsset4",
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
							target:"__VideoToggleButtonSkin_UIAsset1",
							propertyName:"",
							position:"before",
							relativeTo:"__VideoToggleButtonSkin_UIAsset2"
						})
						,
						new org.flexlite.domUI.states.AddItems().initializeFromObject({
							target:"__VideoToggleButtonSkin_UIAsset4",
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
							target:"__VideoToggleButtonSkin_UIAsset1",
							propertyName:"",
							position:"before",
							relativeTo:"__VideoToggleButtonSkin_UIAsset2"
						})
						,
						new org.flexlite.domUI.states.AddItems().initializeFromObject({
							target:"__VideoToggleButtonSkin_UIAsset4",
							propertyName:"",
							position:"last",
							relativeTo:""
						})
					]
				})
				,
				new org.flexlite.domUI.states.State ({name: "upAndSelected",
					overrides: [
						new org.flexlite.domUI.states.AddItems().initializeFromObject({
							target:"__VideoToggleButtonSkin_UIAsset3",
							propertyName:"",
							position:"last",
							relativeTo:""
						})
					]
				})
				,
				new org.flexlite.domUI.states.State ({name: "overAndSelected",
					overrides: [
						new org.flexlite.domUI.states.AddItems().initializeFromObject({
							target:"__VideoToggleButtonSkin_UIAsset3",
							propertyName:"",
							position:"last",
							relativeTo:""
						})
					]
				})
				,
				new org.flexlite.domUI.states.State ({name: "downAndSelected",
					overrides: [
						new org.flexlite.domUI.states.AddItems().initializeFromObject({
							target:"__VideoToggleButtonSkin_UIAsset3",
							propertyName:"",
							position:"last",
							relativeTo:""
						})
					]
				})
				,
				new org.flexlite.domUI.states.State ({name: "disabledAndSelected",
					overrides: [
						new org.flexlite.domUI.states.AddItems().initializeFromObject({
							target:"__VideoToggleButtonSkin_UIAsset3",
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
		private function __VideoToggleButtonSkin_UIAsset1_i():org.flexlite.domUI.components.UIAsset
		{
			var temp:org.flexlite.domUI.components.UIAsset = new org.flexlite.domUI.components.UIAsset();
			__VideoToggleButtonSkin_UIAsset1 = temp;
			temp.left = 0;
			temp.right = 0;
			temp.skinName = "SWF__FEE61B0B";
			temp.top = 0;
			return temp;
		}

		private function __VideoToggleButtonSkin_UIAsset2_i():org.flexlite.domUI.components.UIAsset
		{
			var temp:org.flexlite.domUI.components.UIAsset = new org.flexlite.domUI.components.UIAsset();
			__VideoToggleButtonSkin_UIAsset2 = temp;
			temp.skinName = "SWF__70DACE8D";
			temp.x = 29;
			temp.y = 12;
			return temp;
		}

		private function __VideoToggleButtonSkin_UIAsset3_i():org.flexlite.domUI.components.UIAsset
		{
			var temp:org.flexlite.domUI.components.UIAsset = new org.flexlite.domUI.components.UIAsset();
			__VideoToggleButtonSkin_UIAsset3 = temp;
			temp.skinName = "SWF__E65B1C65";
			temp.x = 0;
			temp.y = 0;
			return temp;
		}

		private function __VideoToggleButtonSkin_UIAsset4_i():org.flexlite.domUI.components.UIAsset
		{
			var temp:org.flexlite.domUI.components.UIAsset = new org.flexlite.domUI.components.UIAsset();
			__VideoToggleButtonSkin_UIAsset4 = temp;
			temp.bottom = 0;
			temp.left = 0;
			temp.right = 0;
			temp.skinName = "SWF__8382CE31";
			temp.top = 0;
			return temp;
		}

	}
}