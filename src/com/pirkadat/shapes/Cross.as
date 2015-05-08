package com.pirkadat.shapes 
{
	import com.pirkadat.display.*;
	
	public class Cross extends TrueSizeShape
	{
		
		public function Cross(lineStyle:LineStyle, lineGradientStyle:LineGradientStyle = null, centered:Boolean = false)
		{
			lineStyle.applyTo(graphics);
			if (lineGradientStyle != null)
			{
				lineGradientStyle.applyTo(graphics);
			}
			
			var min:Number = centered ? -50 : 0;
			var max:Number = centered ? 50 : 100;
			
			graphics.moveTo(min, min);
			graphics.lineTo(max, max);
			graphics.moveTo(min, max);
			graphics.lineTo(max, min);
		}
		
	}
	
}