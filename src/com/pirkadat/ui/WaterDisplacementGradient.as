package com.pirkadat.ui 
{
	import com.pirkadat.display.TrueSize;
	import com.pirkadat.display.TrueSizeShape;
	import com.pirkadat.logic.Util;
	import flash.display.*;
	import flash.geom.Matrix;
	
	public class WaterDisplacementGradient extends TrueSize
	{
		public var waves:Shape;
		public var dampen:TrueSizeShape;
		
		public function WaterDisplacementGradient() 
		{
			super();
			
			build();
		}
		
		protected function build():void
		{
			waves = new Shape();
			addChild(waves);
			
			var m:Matrix = new Matrix();
			m.createGradientBox(100, 6.25, Math.PI / 2);
			
			waves.graphics.beginGradientFill(GradientType.LINEAR, Util.smoothArrInt(0, 0xffffff, 15, 1, true), Util.smoothArrInt(1, 1, 15), Util.smoothArrInt(0, 255, 15), m, SpreadMethod.REFLECT);
			waves.graphics.drawRect(0, 0, 100, 200);
			
			//
			
			dampen = new TrueSizeShape();
			addChild(dampen);
			
			m.createGradientBox(100, 100, Math.PI / 2);
			
			dampen.graphics.beginGradientFill(GradientType.LINEAR, [0x7f7f7f, 0x7f7f7f], [1, 0], [0, 64], m);
			dampen.graphics.drawRect(0, 0, 100, 100);
			
			sizeMask = dampen;
		}
		
		public function update():void
		{
			waves.y += .75;
			if (waves.y > 0) waves.y -= 100;
		}
	}

}