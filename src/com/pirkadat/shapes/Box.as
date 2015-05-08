package com.pirkadat.shapes
{
	import com.pirkadat.display.*;
	
	public class Box extends TrueSizeShape
	{
		public function Box(fillStyle:FillStyle = null, gradientStyle:GradientStyle = null, lineStyle:LineStyle = null, lineGradientStyle:LineGradientStyle = null, centered:Boolean = false)
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
				if (centered) gradientStyle.modifyMatrix(NaN, NaN, NaN, NaN, NaN, 1, 225);
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
			if (centered) graphics.drawRect(-50, -50, 100, 100);
			else graphics.drawRect(0, 0, 100, 100);
			graphics.endFill();
		}
	}
}