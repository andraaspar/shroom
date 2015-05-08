package com.pirkadat.logic 
{
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.media.SoundChannel;
	public class SoundRequest
	{
		public var assetID:int;
		public var displayObject:DisplayObject;
		public var location:Point;
		public var loop:int;
		public var soundChannel:SoundChannel;
		public var volume:Number;
		public var playbackIsOver:Boolean;
		
		public function SoundRequest(assetID:int, displayObject:DisplayObject, location:Point, loop:int = 0, volume:Number = 1) 
		{
			this.assetID = assetID;
			this.displayObject = displayObject;
			this.location = location;
			this.loop = loop;
			this.volume = volume;
		}
		
	}

}