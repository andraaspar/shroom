package com.pirkadat.geom 
{
	import flash.geom.ColorTransform;
	
	/**
	 * ...
	 * @author András Parditka
	 */
	public class MultiplierColorTransform extends ColorTransform
	{
		
		public function MultiplierColorTransform(rgb:uint = 0, alpha:Number = 1, brightness:Number = 1) 
		{
			var red:Number = ((rgb & 0xff0000) >> 16) / 0xff * brightness;
			var green:Number = ((rgb & 0x00ff00) >> 8) / 0xff * brightness;
			var blue:Number = (rgb & 0x0000ff) / 0xff * brightness;
			super(red, green, blue, alpha, 0, 0, 0, 0);
		}
		
	}
	
}