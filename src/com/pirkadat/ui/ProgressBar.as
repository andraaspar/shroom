package com.pirkadat.ui 
{
	import com.pirkadat.display.TrueSize;
	import com.pirkadat.display.TrueSizeShape;
	import com.pirkadat.shapes.FillStyle;
	import com.pirkadat.shapes.LineStyle;
	import com.pirkadat.shapes.RoundedBox;
	import flash.text.TextFieldAutoSize;
	
	public class ProgressBar extends TrueSize
	{
		public var label:DynamicText;
		public var background:TrueSizeShape;
		public var foreground:TrueSizeShape;
		public var progress:Number = 0;
		
		public function ProgressBar() 
		{
			super();
			
			label = new DynamicText();
			addChild(label);
			label.text = " ";
			
			background = new RoundedBox(3, new FillStyle(), null, new LineStyle(2, 0xffffff));
			addChild(background);
			background.ySize = 8;
			background.y = label.bottom + 4;
			
			foreground = new RoundedBox(3, new FillStyle(0xffffff));
			addChild(foreground);
			foreground.ySize = background.ySize;
			foreground.y = background.y;
		}
		
		public function setLabel(text:String):void
		{
			label.text = text;
			
			background.xSize = label.width;
			
			setProgress(progress);
		}
		
		public function setProgress(value:Number):void
		{
			if (value < 0) value = 0;
			else if (value > 1) value = 1;
			progress = value;
			
			foreground.xSize = background.xSize * value;
		}
	}

}