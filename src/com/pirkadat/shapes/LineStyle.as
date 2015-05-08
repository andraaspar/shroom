package com.pirkadat.shapes 
{
	import flash.display.Graphics;
	
	/**
	* ...
	* @author András Parditka
	*/
	public class LineStyle 
	{
		public var thickness:Number = 1;
		public var color:uint = 0x000000;
		public var alpha:Number = 1.0;
		public var pixelHinting:Boolean = false;
		public var scaleMode:String = "none";
		public var caps:String = "round";
		public var joints:String = "round";
		public var miterLimit:Number = 3;
		
		public function LineStyle(thickness:Number = 1, color:uint = 0x000000, alpha:Number = 1.0, pixelHinting:Boolean = true, scaleMode:String = "none", caps:String = "none", joints:String = "miter", miterLimit:Number = 3) 
		{
			this.thickness = thickness;
			this.color = color;
			this.alpha = alpha;
			this.pixelHinting = pixelHinting;
			this.scaleMode = scaleMode;
			this.caps = caps;
			this.joints = joints;
			this.miterLimit = miterLimit;
		}
		
		public function applyTo(graphics:Graphics):void
		{
			graphics.lineStyle(thickness, color, alpha, pixelHinting, scaleMode, caps, joints, miterLimit);
		}
		
	}
	
}