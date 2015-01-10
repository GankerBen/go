package  
{
	import org.flexlite.domUI.components.Rect;
	public function drawRect(percentWidth:Number, percentHeight:Number, width:Number, height:Number, left:Number, right:Number, top:Number, bottom:Number, color:uint):Rect
	{
		var rect:Rect = new Rect();
		rect.percentWidth = percentWidth;
		rect.percentHeight = percentHeight;
		rect.width = width;
		rect.height = height;
		rect.fillColor = color;
		rect.left = left;
		rect.right = right;
		rect.top = top;
		rect.bottom = bottom;
		return rect;
	}
}