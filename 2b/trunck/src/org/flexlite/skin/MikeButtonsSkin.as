package org.flexlite.skin
{
	import org.flexlite.domUI.components.StateSkin;
	import org.flexlite.domUI.states.State;

	/**
	 * @private
	 * 此类由编译器自动生成，您应修改对应的DXML文件内容，然后重新编译，而不应直接修改其代码。
	 * @author DXMLCompiler
	 */
	public class MikeButtonsSkin extends org.flexlite.domUI.components.StateSkin
	{

		//==========================================================================
		//                                定义构造函数
		//==========================================================================
		public function MikeButtonsSkin()
		{
			super();
			
			this.currentState = "normal";
			
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


	}
}