package com.pirkadat.shapes 
{
	import com.pirkadat.display.*;
	
	public class Circle extends TrueSizeShape
	{
		public function Circle(fillStyle:FillStyle = null, gradientStyle:GradientStyle = null, lineStyle:LineStyle = null, lineGradientStyle:LineGradientStyle = null, centered:Boolean = false) 
		{
			if (fillStyle == null && gradientStyle == null && lineStyle == null && lineGradientStyle == null)
			{
				fillStyle = new FillStyle();
			}
			if (fillStyle != null)
			{
				fillStyle.applyTo(graphics);
			}
			if (gradientStyle != null)
			{
				gradientStyle.applyTo(graphics);
			}
			if (lineStyle != null)
			{
				lineStyle.applyTo(graphics);
				if (lineGradientStyle != null)
				{
					lineGradientStyle.applyTo(graphics);
				}
			}
			if (centered) graphics.drawCircle(0, 0, 50);
			else graphics.drawCircle(50, 50, 50);
			graphics.endFill();
		}
		
	}
	
}