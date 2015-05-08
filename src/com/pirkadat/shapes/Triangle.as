package com.pirkadat.shapes
{
	import com.pirkadat.display.*;
	
	public class Triangle extends TrueSizeShape
	{
		public function Triangle(fillStyle:FillStyle = null, gradientStyle:GradientStyle = null, lineStyle:LineStyle = null, lineGradientStyle:LineGradientStyle = null, centered:Boolean = false)
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
			
			if (centered)
			{
				graphics.moveTo(-50, -50);
				graphics.lineTo(50, 0);
				graphics.lineTo(-50, 50);
				graphics.lineTo(-50, -50);
				graphics.endFill();
			}
			else
			{
				graphics.lineTo(100, 50);
				graphics.lineTo(0, 100);
				graphics.lineTo(0, 0);
				graphics.endFill();
			}
		}
	}
}