package org.flexlite.skin
{
	import org.flexlite.domUI.components.ProgressBar;
	import org.flexlite.domUI.components.StateSkin;
	import org.flexlite.domUI.components.UIAsset;
	import org.flexlite.domUI.states.State;

	/**
	 * @private
	 * 此类由编译器自动生成，您应修改对应的DXML文件内容，然后重新编译，而不应直接修改其代码。
	 * @author DXMLCompiler
	 */
	public class LoadingSkin extends org.flexlite.domUI.components.StateSkin
	{
		public var progressBar:org.flexlite.domUI.components.ProgressBar;


		//==========================================================================
		//                                定义构造函数
		//==========================================================================
		public function LoadingSkin()
		{
			super();
			
			this.currentState = "normal";
			this.elementsContent = [__LoadingSkin_UIAsset1_i(),progressBar_i()];
			
			states = [
				new org.flexlite.domUI.states.State ({name: "normal",
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


		//==========================================================================
		//                                定义成员方法
		//==========================================================================
		private function __LoadingSkin_UIAsset1_i():org.flexlite.domUI.components.UIAsset
		{
			var temp:org.flexlite.domUI.components.UIAsset = new org.flexlite.domUI.components.UIAsset();
			temp.bottom = 2;
			temp.left = 2;
			temp.right = 2;
			temp.skinName = "DXR__29C315AC";
			temp.top = 2;
			return temp;
		}

		private function progressBar_i():org.flexlite.domUI.components.ProgressBar
		{
			var temp:org.flexlite.domUI.components.ProgressBar = new org.flexlite.domUI.components.ProgressBar();
			progressBar = temp;
			temp.bottom = 107;
			temp.left = 154;
			temp.right = 156;
			temp.top = 107;
			return temp;
		}

	}
}