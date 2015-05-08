package com.pirkadat.shapes
{
	import com.pirkadat.display.*;
	
	public class RoundedBox extends TrueSizeShape
	{
		public var cornerRadius:Number = 0;
		public var fillStyle:FillStyle;
		public var gradientStyle:GradientStyle;
		public var lineStyle:LineStyle;
		public var lineGradientStyle:LineGradientStyle;
		
		private var _xSize:Number = 100;
		private var _ySize:Number = 100;
		
		public function RoundedBox(cornerRadius:Number = 0, fillStyle:FillStyle = null, gradientStyle:GradientStyle = null, lineStyle:LineStyle = null, lineGradientStyle:LineGradientStyle = null)
		{
			this.cornerRadius = cornerRadius;
			if (fillStyle == null && gradientStyle == null && lineStyle == null && lineGradientStyle == null)
			{
				fillStyle = new FillStyle();
			}
			this.fillStyle = fillStyle;
			this.gradientStyle = gradientStyle;
			this.lineStyle = lineStyle;
			this.lineGradientStyle = lineGradientStyle;
			
			update();
		}
		
		override public function set width(value:Number):void
		{
			if (isNaN(value)) value = 0;
			_xSize = value;
			update();
		}
		
		override public function set height(value:Number):void
		{
			if (isNaN(value)) value = 0;
			_ySize = value;
			update();
		}
		
		override public function set xSize(value:Number):void
		{
			if (isNaN(value)) value = 0;
			_xSize = value;
			update();
		}
		
		override public function set ySize(value:Number):void
		{
			if (isNaN(value)) value = 0;
			_ySize = value;
			update();
		}
		
		public function setSizeAndRadius(xSize:Number = NaN, ySize:Number = NaN, cornerRadius:Number = NaN):void
		{
			if (!isNaN(xSize)) _xSize = xSize;
			if (!isNaN(ySize)) _ySize = ySize;
			
			if (!isNaN(cornerRadius)) this.cornerRadius = cornerRadius;
			
			update();
		}
		
		public function update():void
		{
			graphics.clear();
			
			if (fillStyle) fillStyle.applyTo(graphics);
			if (gradientStyle) 
			{
				gradientStyle.modifyMatrix(_xSize,_ySize);
				gradientStyle.applyTo(graphics);
			}
			if (lineStyle) 
			{
				lineStyle.applyTo(graphics);
				if (lineGradientStyle) 
				{
					lineGradientStyle.modifyMatrix(_xSize,_ySize);
					lineGradientStyle.applyTo(graphics);
				}
			}
			graphics.drawRoundRect(0, 0, _xSize, _ySize, cornerRadius * 2);
			graphics.endFill();
		}
	}
}