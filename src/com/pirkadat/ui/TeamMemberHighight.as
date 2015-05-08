package com.pirkadat.ui 
{
	import com.pirkadat.display.TrueSizeShape;
	import com.pirkadat.shapes.GradientStyle;
	import flash.display.BlendMode;
	import flash.display.GradientType;
	import flash.geom.Matrix;
	
	public class TeamMemberHighight extends TrueSizeShape
	{
		public var alphaChange:Number = -.05;
		
		public function TeamMemberHighight(colour:int, radius:Number) 
		{
			var m:Matrix = new Matrix();
			m.createGradientBox(radius * 2, radius * 2, 0, -radius, -radius);
			graphics.beginGradientFill(GradientType.RADIAL, [colour, colour], [1, 0], [64, 255], m);
			graphics.drawRect( -radius, -radius, radius * 2, radius * 2);
			
			blendMode = BlendMode.ADD;
		}
		
		public function update():void
		{
			alpha += alphaChange;
			if (alpha >= 1 || alpha <= 0) alphaChange = -alphaChange;
		}
	}

}