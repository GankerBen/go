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
	public class ShengyinToggleSkin extends org.flexlite.domUI.components.StateSkin
	{

		//==========================================================================
		//                                定义构造函数
		//==========================================================================
		public function ShengyinToggleSkin()
		{
			super();
			
			this.currentState = "up";
			this.height = 24;
			this.width = 32;
			this.elementsContent = [__ShengyinToggleSkin_UIAsset1_i()];
			
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


		private function __ShengyinToggleSkin_UIAsset1_i():org.flexlite.domUI.components.UIAsset
		{
			var temp:org.flexlite.domUI.components.UIAsset = new org.flexlite.domUI.components.UIAsset();
			temp.bottom = 4;
			temp.left = 0;
			temp.right = 17;
			temp.skinName = "DXR__8BAA2EF3";
			temp.top = 0;
			return temp;
		}

	}
}