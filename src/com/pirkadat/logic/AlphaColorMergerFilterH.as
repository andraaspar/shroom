package com.pirkadat.logic 
{
	import flash.display.*;
	import flash.geom.*;
	
	public class AlphaColorMergerFilterH extends AssetFilter
	{
		
		public function AlphaColorMergerFilterH() 
		{
			
		}
		
		override public function execute(data:*):* 
		{
			var src:BitmapData = data;
			var pt:Point = new Point();
			var rect:Rectangle = new Rectangle(0, 0, src.width / 2, src.height);
			var dest:BitmapData = new BitmapData(rect.width, rect.height, true, 0);
			dest.copyPixels(src, rect, pt);
			rect.x += rect.width;
			dest.copyChannel(src, rect, pt, BitmapDataChannel.GREEN, BitmapDataChannel.ALPHA);
			src.dispose();
			
			return dest;
		}
	}

}