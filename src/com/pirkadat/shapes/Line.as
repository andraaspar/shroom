package com.pirkadat.shapes 
{
	import com.pirkadat.display.TrueSizeShape;
	
	public class Line extends TrueSizeShape
	{
		
		public function Line(lineStyle:LineStyle, lineGradientStyle:LineGradientStyle = null, centered:Boolean = false)
		{
			lineStyle.applyTo(graphics);
			if (lineGradientStyle != null)
			{
				lineGradientStyle.applyTo(graphics);
			}
			if (centered) 
			{
				graphics.moveTo(-50, 0);
				graphics.lineTo(50, 0);
			}
			else graphics.lineTo(100, 0);
		}
		
	}
	
}