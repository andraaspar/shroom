package com.pirkadat.geom 
{
	import flash.geom.ColorTransform;
	
	public class BrightnessColorTransform extends ColorTransform
	{
		
		public function BrightnessColorTransform(brightness:Number = 1, alpha:Number = 1) 
		{
			super(brightness, brightness, brightness, alpha, 0, 0, 0, 0);
		}
		
	}
	
}