package com.pirkadat.shapes 
{
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Matrix;
	
	public class FillStyle 
	{
		public var color:uint;
		public var alpha:Number;
		public var bitmap:BitmapData;
		public var matrix:Matrix;
		public var repeat:Boolean;
		public var smooth:Boolean;
		
		public function FillStyle(color:uint = 0x000000, alpha:Number = 1, bitmap:BitmapData = null, matrix:Matrix = null, repeat:Boolean = true, smooth:Boolean = true) 
		{
			this.color = color;
			this.alpha = alpha;
			this.bitmap = bitmap;
			if (matrix) this.matrix = matrix;
			else this.matrix = new Matrix();
			this.repeat = repeat;
			this.smooth = smooth;
		}
		
		public function applyTo(graphics:Graphics):void
		{
			if (bitmap) graphics.beginBitmapFill(bitmap, matrix, repeat, smooth);
			else graphics.beginFill(color, alpha);
		}
		
	}
	
}