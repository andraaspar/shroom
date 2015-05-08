package com.pirkadat.ui 
{
	import com.pirkadat.display.TrueSizeShape;
	import flash.display.BlendMode;
	import flash.display.Graphics;
	
	public class StaminaMeter extends TrueSizeShape
	{
		public var radius:Number;
		public var jumpLimit:Number;
		
		public function StaminaMeter(radius:Number, jumpLimit:Number) 
		{
			super();
			
			this.radius = radius;
			this.jumpLimit = jumpLimit;
			
			blendMode = BlendMode.ADD;
		}
		
		public function setStamina(value:Number):void
		{
			graphics.clear();
			graphics.lineStyle(3, value >= jumpLimit ? 0xffffff : 0xff0000, .2, false);
			graphics.drawCircle(0, 0, (radius + Math.max(0, value) + 1));
		}
	}

}