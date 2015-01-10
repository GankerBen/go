package org.flexlite.skin
{
	import org.flexlite.domUI.components.StateSkin;
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.domUI.states.State;

	/**
	 * @private
	 * 此类由编译器自动生成，您应修改对应的DXML文件内容，然后重新编译，而不应直接修改其代码。
	 * @author DXMLCompiler
	 */
	public class DocButtonSkin extends org.flexlite.domUI.components.StateSkin
	{

		//==========================================================================
		//                                定义构造函数
		//==========================================================================
		public function DocButtonSkin()
		{
			super();
			
			this.currentState = "up";
			this.elementsContent = [__DocButtonSkin_UIAsset1_i()];
			
			states = [
				new org.flexlite.domUI.states.State ({name: "up",
					overrides: [
					]
				})
				,
				new org.flexlite.domUI.states.State ({name: "over",
					overrides: [
					]
				})
				,
				new org.flexlite.domUI.states.State ({name: "down",
					overrides: [
					]
				})
				,
				new org.flexlite.domUI.states.State ({name: "disabled",
					overrides: [
					]
				})
			];
		}


		private function __DocButtonSkin_UIAsset1_i():org.flexlite.domUI.components.UIAsset
		{
			var temp:org.flexlite.domUI.components.UIAsset = new org.flexlite.domUI.components.UIAsset();
			temp.bottom = 0;
			temp.left = 0;
			temp.right = 0;
			temp.skinName = "DXR__2FA943C9";
			temp.top = 0;
			return temp;
		}

	}
}