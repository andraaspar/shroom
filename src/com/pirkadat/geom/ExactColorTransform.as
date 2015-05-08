package com.pirkadat.geom 
{
	import flash.geom.ColorTransform;
	
	/**
	 * ...
	 * @author András Parditka
	 */
	public class ExactColorTransform extends ColorTransform
	{
		
		public function ExactColorTransform(rgb:Number = NaN, alpha:Number = 1, brightness:Number = 1) 
		{
			super(1, 1, 1, alpha, 0, 0, 0, 0);
			if (!isNaN(rgb)) this.color = rgb;
			redOffset *= brightness;
			greenOffset *= brightness;
			blueOffset *= brightness;
		}
		
	}
	
}