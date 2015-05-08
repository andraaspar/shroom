package com.pirkadat.logic 
{
	
	public class AnimationRange
	{
		public var startOffset:int;
		public var start:int;
		public var end:int;
		
		public function AnimationRange(start:int, end:int, startOffset:int = 0) 
		{
			this.start = start;
			this.end = end;
			this.startOffset = startOffset;
		}
		
		public function randomizeStartOffset():AnimationRange
		{
			return new AnimationRange(start, end, Math.random() * (end - start + 1));
		}
		
	}

}