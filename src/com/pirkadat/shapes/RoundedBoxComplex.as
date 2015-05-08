package com.pirkadat.shapes
{
	import com.pirkadat.display.*;
	
	public class RoundedBoxComplex extends TrueSizeShape
	{
		public var topLeftRadius:Number = 0;
		public var topRightRadius:Number = 0;
		public var bottomRightRadius:Number = 0;
		public var bottomLeftRadius:Number = 0;
		public var fillStyle:FillStyle;
		public var gradientStyle:GradientStyle;
		public var lineStyle:LineStyle;
		public var lineGradientStyle:LineGradientStyle;
		
		private var _xSize:Number = 100;
		private var _ySize:Number = 100;
		
		public function RoundedBoxComplex(topLeftRadius:Number = 0, topRightRadius:Number = 0, bottomLeftRadius:Number = 0, bottomRightRadius:Number = 0, fillStyle:FillStyle = null, gradientStyle:GradientStyle = null, lineStyle:LineStyle = null, lineGradientStyle:LineGradientStyle = null)
		{
			this.topLeftRadius = topLeftRadius;
			this.topRightRadius = topRightRadius;
			this.bottomRightRadius = bottomRightRadius;
			this.bottomLeftRadius = bottomLeftRadius;
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
			_xSize = value;
			update();
		}
		
		override public function set height(value:Number):void
		{
			_ySize = value;
			update();
		}
		
		override public function set xSize(value:Number):void
		{
			_xSize = value;
			update();
		}
		
		override public function set ySize(value:Number):void
		{
			_ySize = value;
			update();
		}
		
		public function setSizeAndRadiuses(xSize:Number = NaN, ySize:Number = NaN, topLeftRadius:Number = NaN, topRightRadius:Number = NaN, bottomLeftRadius:Number = NaN, bottomRightRadius:Number = NaN):void
		{
			if (!isNaN(xSize)) _xSize = xSize;
			if (!isNaN(ySize)) _ySize = ySize;
			
			if (!isNaN(topLeftRadius)) this.topLeftRadius = topLeftRadius;
			if (!isNaN(topRightRadius)) this.topRightRadius = topRightRadius;
			if (!isNaN(bottomRightRadius)) this.bottomRightRadius = bottomRightRadius;
			if (!isNaN(bottomLeftRadius)) this.bottomLeftRadius = bottomLeftRadius;
			
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
			graphics.drawRoundRectComplex(0, 0, _xSize, _ySize, topLeftRadius, topRightRadius, bottomLeftRadius, bottomRightRadius);
			graphics.endFill();
		}
	}
}