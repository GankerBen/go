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
	public class CloseButtonSkin extends org.flexlite.domUI.components.StateSkin
	{
		//==========================================================================
		//                                定义成员变量
		//==========================================================================
		public var __CloseButtonSkin_UIAsset1:org.flexlite.domUI.components.UIAsset;

		public var __CloseButtonSkin_UIAsset2:org.flexlite.domUI.components.UIAsset;


		//==========================================================================
		//                                定义构造函数
		//==========================================================================
		public function CloseButtonSkin()
		{
			super();
			
			this.currentState = "up";
			this.height = 17;
			this.width = 18;
			this.elementsContent = [];
			__CloseButtonSkin_UIAsset1_i();
			__CloseButtonSkin_UIAsset2_i();
			
			
			states = [
				new org.flexlite.domUI.states.State ({name: "up",
					overrides: [
						new org.flexlite.domUI.states.AddItems().initializeFromObject({
							target:"__CloseButtonSkin_UIAsset2",
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
							target:"__CloseButtonSkin_UIAsset1",
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
							target:"__CloseButtonSkin_UIAsset1",
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
							target:"__CloseButtonSkin_UIAsset2",
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
		private function __CloseButtonSkin_UIAsset1_i():org.flexlite.domUI.components.UIAsset
		{
			var temp:org.flexlite.domUI.components.UIAsset = new org.flexlite.domUI.components.UIAsset();
			__CloseButtonSkin_UIAsset1 = temp;
			temp.bottom = 0;
			temp.left = 0;
			temp.right = 1;
			temp.skinName = "SWF__B7160422";
			temp.top = 0;
			return temp;
		}

		private function __CloseButtonSkin_UIAsset2_i():org.flexlite.domUI.components.UIAsset
		{
			var temp:org.flexlite.domUI.components.UIAsset = new org.flexlite.domUI.components.UIAsset();
			__CloseButtonSkin_UIAsset2 = temp;
			temp.bottom = 0;
			temp.left = 0;
			temp.right = 1;
			temp.skinName = "SWF__E53F7812";
			temp.top = 0;
			return temp;
		}

	}
}