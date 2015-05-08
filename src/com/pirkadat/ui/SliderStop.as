package com.pirkadat.ui 
{
	import com.pirkadat.display.*;
	import flash.display.*;
	
	public class SliderStop extends TrueSize
	{
		public var line:TrueSize;
		public var label:DynamicText;
		
		public function SliderStop(labelText:String) 
		{
			super();
			
			//
			
			line = new TrueSize();
			addChild(line);
			line.graphics.lineStyle(2, 0xffffff, 1, false, LineScaleMode.NORMAL, CapsStyle.ROUND);
			line.graphics.lineTo(0, 10);
			sizeMask = line;
			
			//
			
			label = new DynamicText();
			addChild(label);
			label.text = labelText;
			label.bottom = line.top - 5;
			label.xMiddle = 0;
		}
		
	}

}