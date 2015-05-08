package com.pirkadat.logic 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	public class FrameVectorGeneratorFilter extends AssetFilter
	{
		public var frameColCount:int;
		public var totalFrameCount:int;
		
		public function FrameVectorGeneratorFilter(frameColCount:int, totalFrameCount:int) 
		{
			this.frameColCount = frameColCount;
			this.totalFrameCount = totalFrameCount;
		}
		
		override public function execute(data:*):* 
		{
			var source:BitmapData = BitmapData(data);
			var aFrame:BitmapData;
			var frameWidth:int = source.width / frameColCount;
			var frameHeight:int = source.height / Math.ceil(totalFrameCount / frameColCount);
			var nullPoint:Point = new Point();
			var copyRect:Rectangle = new Rectangle(0, 0, frameWidth, frameHeight);
			var result:Vector.<BitmapData> = new Vector.<BitmapData>(totalFrameCount, true);
			
			var frameId:int = 0;
			yLoop: for (var y:int = 0; true; y += frameHeight)
			{
				copyRect.y = y;
				
				for (var x:int = 0; x < source.width; x += frameWidth)
				{
					copyRect.x = x;
					
					aFrame = new BitmapData(frameWidth, frameHeight, true, 0);
					aFrame.copyPixels(source, copyRect, nullPoint);
					
					result[frameId] = aFrame;
					
					if (++frameId >= totalFrameCount) break yLoop;
				}
			}
			
			source.dispose();
			
			return result;
		}
	}

}