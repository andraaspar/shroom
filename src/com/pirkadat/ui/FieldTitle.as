package com.pirkadat.ui 
{
	import com.pirkadat.display.ITrueSize;
	import com.pirkadat.display.TrueSize;
	import com.pirkadat.shapes.Box;
	import com.pirkadat.shapes.FillStyle;
	import com.pirkadat.shapes.LineStyle;
	import com.pirkadat.shapes.RoundedBoxComplex;
	
	public class FieldTitle extends Extender 
	{
		public var field:DynamicText;
		public var frame:RoundedBoxComplex;
		
		public function FieldTitle(title:String) 
		{
			super(field = new DynamicText(title), 5, 5, 5, 10);
			
			frame = new RoundedBoxComplex(Button.CORNER_RADIUS - .5, 0, Button.CORNER_RADIUS - .5, 0, null, null, new LineStyle(1, 0xffffff));
			addChild(frame);
			frame.x = frame.y = .5;
		}
		
		override protected function createExtension():ITrueSize 
		{
			return new RoundedBoxComplex(Button.CORNER_RADIUS, 0, Button.CORNER_RADIUS, 0, new FillStyle(0, .6));
		}
		
		override protected function correctExtension(xSize:Number, ySize:Number):void 
		{
			super.correctExtension(xSize, ySize);
			
			frame.xSize = extension.xSize - 1;
			frame.ySize = extension.ySize - 1;
		}
	}

}