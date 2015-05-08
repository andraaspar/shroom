package com.pirkadat.ui 
{
	public class Separator extends UIElement 
	{
		
		public function Separator() 
		{
			super();
			
			contentsMinSizeX = 12;
			contentsMinSizeY = 12;
			
			graphics.beginFill(Colors.BLACK, .6);
			graphics.drawRect(0, 0, contentsMinSizeX, contentsMinSizeY);
		}
		
		override public function fitToSpace(xSpace:Number = NaN, ySpace:Number = NaN):void 
		{
			sizeChanged = false;
			
			xSize = xSpace;
			ySize = ySpace;
		}
	}

}