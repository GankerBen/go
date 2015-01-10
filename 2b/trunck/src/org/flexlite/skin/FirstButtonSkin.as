package org.flexlite.skin
{
	import org.flexlite.domUI.components.Label;
	import org.flexlite.domUI.components.StateSkin;
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.domUI.states.AddItems;
	import org.flexlite.domUI.states.State;

	/**
	 * @private
	 * 此类由编译器自动生成，您应修改对应的DXML文件内容，然后重新编译，而不应直接修改其代码。
	 * @author DXMLCompiler
	 */
	public class FirstButtonSkin extends org.flexlite.domUI.components.StateSkin
	{
		//==========================================================================
		//                                定义成员变量
		//==========================================================================
		public var __FirstButtonSkin_UIAsset1:org.flexlite.domUI.components.UIAsset;

		public var __FirstButtonSkin_UIAsset2:org.flexlite.domUI.components.UIAsset;

		public var __FirstButtonSkin_UIAsset3:org.flexlite.domUI.components.UIAsset;

		public var __FirstButtonSkin_UIAsset4:org.flexlite.domUI.components.UIAsset;

		public var labelDisplay:org.flexlite.domUI.components.Label;


		//==========================================================================
		//                                定义构造函数
		//==========================================================================
		public function FirstButtonSkin()
		{
			super();
			
			this.currentState = "up";
			this.elementsContent = [labelDisplay_i()];
			__FirstButtonSkin_UIAsset1_i();
			__FirstButtonSkin_UIAsset2_i();
			__FirstButtonSkin_UIAsset3_i();
			__FirstButtonSkin_UIAsset4_i();
			
			
			states = [
				new org.flexlite.domUI.states.State ({name: "up",
					overrides: [
						new org.flexlite.domUI.states.AddItems().initializeFromObject({
							target:"__FirstButtonSkin_UIAsset3",
							propertyName:"",
							position:"before",
							relativeTo:"labelDisplay"
						})
					]
				})
				,
				new org.flexlite.domUI.states.State ({name: "over",
					overrides: [
						new org.flexlite.domUI.states.AddItems().initializeFromObject({
							target:"__FirstButtonSkin_UIAsset2",
							propertyName:"",
							position:"before",
							relativeTo:"labelDisplay"
						})
					]
				})
				,
				new org.flexlite.domUI.states.State ({name: "down",
					overrides: [
						new org.flexlite.domUI.states.AddItems().initializeFromObject({
							target:"__FirstButtonSkin_UIAsset1",
							propertyName:"",
							position:"before",
							relativeTo:"labelDisplay"
						})
					]
				})
				,
				new org.flexlite.domUI.states.State ({name: "disabled",
					overrides: [
						new org.flexlite.domUI.states.AddItems().initializeFromObject({
							target:"__FirstButtonSkin_UIAsset4",
							propertyName:"",
							position:"before",
							relativeTo:"labelDisplay"
						})
					]
				})
			];
		}


		//==========================================================================
		//                                定义成员方法
		//==========================================================================
		private function __FirstButtonSkin_UIAsset1_i():org.flexlite.domUI.components.UIAsset
		{
			var temp:org.flexlite.domUI.components.UIAsset = new org.flexlite.domUI.components.UIAsset();
			__FirstButtonSkin_UIAsset1 = temp;
			temp.bottom = 2;
			temp.left = 5;
			temp.right = 5;
			temp.skinName = "DXR__17875792";
			temp.top = 2;
			return temp;
		}

		private function __FirstButtonSkin_UIAsset2_i():org.flexlite.domUI.components.UIAsset
		{
			var temp:org.flexlite.domUI.components.UIAsset = new org.flexlite.domUI.components.UIAsset();
			__FirstButtonSkin_UIAsset2 = temp;
			temp.bottom = 2;
			temp.left = 2;
			temp.right = 2;
			temp.skinName = "DXR__36A9C55B";
			temp.top = 2;
			return temp;
		}

		private function __FirstButtonSkin_UIAsset3_i():org.flexlite.domUI.components.UIAsset
		{
			var temp:org.flexlite.domUI.components.UIAsset = new org.flexlite.domUI.components.UIAsset();
			__FirstButtonSkin_UIAsset3 = temp;
			temp.bottom = 2;
			temp.left = 2;
			temp.right = 2;
			temp.skinName = "DXR__CF692D30";
			temp.top = 2;
			return temp;
		}

		private function __FirstButtonSkin_UIAsset4_i():org.flexlite.domUI.components.UIAsset
		{
			var temp:org.flexlite.domUI.components.UIAsset = new org.flexlite.domUI.components.UIAsset();
			__FirstButtonSkin_UIAsset4 = temp;
			temp.bottom = 2;
			temp.left = 2;
			temp.right = 2;
			temp.skinName = "DXR__E9A6CBCB";
			temp.top = 2;
			return temp;
		}

		private function labelDisplay_i():org.flexlite.domUI.components.Label
		{
			var temp:org.flexlite.domUI.components.Label = new org.flexlite.domUI.components.Label();
			labelDisplay = temp;
			temp.bottom = 18;
			temp.left = 55;
			temp.right = 56;
			temp.text = "标签";
			temp.textColor = 0x0011FF;
			temp.top = 13;
			return temp;
		}

	}
}