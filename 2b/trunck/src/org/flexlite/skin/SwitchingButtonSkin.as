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
	public class SwitchingButtonSkin extends org.flexlite.domUI.components.StateSkin
	{
		//==========================================================================
		//                                定义成员变量
		//==========================================================================
		public var __SwitchingButtonSkin_UIAsset1:org.flexlite.domUI.components.UIAsset;

		public var __SwitchingButtonSkin_UIAsset2:org.flexlite.domUI.components.UIAsset;


		//==========================================================================
		//                                定义构造函数
		//==========================================================================
		public function SwitchingButtonSkin()
		{
			super();
			
			this.currentState = "up";
			this.elementsContent = [];
			__SwitchingButtonSkin_UIAsset1_i();
			__SwitchingButtonSkin_UIAsset2_i();
			
			
			states = [
				new org.flexlite.domUI.states.State ({name: "up",
					overrides: [
						new org.flexlite.domUI.states.AddItems().initializeFromObject({
							target:"__SwitchingButtonSkin_UIAsset1",
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
							target:"__SwitchingButtonSkin_UIAsset1",
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
							target:"__SwitchingButtonSkin_UIAsset1",
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
							target:"__SwitchingButtonSkin_UIAsset1",
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
							target:"__SwitchingButtonSkin_UIAsset2",
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
							target:"__SwitchingButtonSkin_UIAsset2",
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
							target:"__SwitchingButtonSkin_UIAsset2",
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
							target:"__SwitchingButtonSkin_UIAsset2",
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
		private function __SwitchingButtonSkin_UIAsset1_i():org.flexlite.domUI.components.UIAsset
		{
			var temp:org.flexlite.domUI.components.UIAsset = new org.flexlite.domUI.components.UIAsset();
			__SwitchingButtonSkin_UIAsset1 = temp;
			temp.bottom = 8;
			temp.left = 0;
			temp.right = 5;
			temp.skinName = "DXR__B1E44331";
			temp.top = 0;
			return temp;
		}

		private function __SwitchingButtonSkin_UIAsset2_i():org.flexlite.domUI.components.UIAsset
		{
			var temp:org.flexlite.domUI.components.UIAsset = new org.flexlite.domUI.components.UIAsset();
			__SwitchingButtonSkin_UIAsset2 = temp;
			temp.bottom = 8;
			temp.left = 0;
			temp.right = 5;
			temp.skinName = "DXR__F39DE38A";
			temp.top = 0;
			return temp;
		}

	}
}