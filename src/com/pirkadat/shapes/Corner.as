package com.pirkadat.shapes 
{
	import com.pirkadat.display.TrueSizeShape;
	
	public class Corner extends TrueSizeShape
	{
		
		public function Corner(lineStyle:LineStyle, lineGradientStyle:LineGradientStyle = null, centered:Boolean = false)
		{
			lineStyle.applyTo(graphics);
			if (lineGradientStyle != null)
			{
				lineGradientStyle.applyTo(graphics);
			}
			if (centered) 
			{
				graphics.moveTo(-25, -50);
				graphics.lineTo(25, 0);
				graphics.lineTo(-25, 50);
			}
			else 
			{
				graphics.lineTo(50, 50);
				graphics.lineTo(0, 100);
			}
		}
		
	}
	
}