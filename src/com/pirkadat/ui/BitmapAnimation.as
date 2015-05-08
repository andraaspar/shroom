package com.pirkadat.ui 
{
	import com.pirkadat.display.*;
	import com.pirkadat.logic.AnimationRange;
	import flash.display.*;
	import flash.events.Event;
	import flash.geom.*;
	
	public class BitmapAnimation extends TrueSize
	{
		public var framesPerLayer:Vector.<Vector.<BitmapData>> = new Vector.<Vector.<BitmapData>>();
		public var layers:Vector.<TrueSizeBitmap> = new Vector.<TrueSizeBitmap>();
		
		public var currentFrame:Number = 0;
		public var playFrom:int = 0;
		public var playTo:int = 0;
		public var loop:Boolean;
		public var isPlaying:Boolean;
		public var framesPerFrame:Number = 1;
		public var smoothing:Boolean = true;
		
		public function BitmapAnimation() 
		{
			super();
		}
		
		public function addLayer(frames:Vector.<BitmapData>, colorTransform:ColorTransform = null):void
		{
			var layer:TrueSizeBitmap = new TrueSizeBitmap(frames[0]);
			addChild(layer);
			layer.x = -layer.width / 2;
			layer.y = -layer.height / 2;
			if (colorTransform) layer.transform.colorTransform = colorTransform;
			layers.push(layer);
			framesPerLayer.push(frames);
		}
		
		protected function animationEnterFrameHandler(e:Event = null):void
		{
			currentFrame += framesPerFrame;
			
			if (loop)
			{
				while (currentFrame >= playTo + 1) currentFrame = playFrom + (currentFrame - playTo - 1);
				while (currentFrame < playFrom) currentFrame = playTo + 1 - (playFrom - currentFrame);
			}
			else
			{
				if (currentFrame >= playTo + 1) 
				{
					currentFrame = playTo + .999;
					stop();
				}
				if (currentFrame < playFrom)
				{
					currentFrame = playFrom;
					stop();
				}
			}
			
			for (var i:int = layers.length - 1; i >= 0; i--)
			{
				layers[i].bitmapData = framesPerLayer[i][int(currentFrame)];
				layers[i].smoothing = smoothing;
			}
		}
		
		public function play():void
		{
			if (isPlaying) return;
			
			isPlaying = true;
			addEventListener(Event.ENTER_FRAME, animationEnterFrameHandler, false, 0, true);
		}
		
		public function stop():void
		{
			if (!isPlaying) return;
			
			isPlaying = false;
			removeEventListener(Event.ENTER_FRAME, animationEnterFrameHandler, false);
		}
		
		public function playRange(animationRange:AnimationRange, loop:Boolean):void
		{
			if (!animationRange) animationRange = new AnimationRange(0, 0);
			
			this.loop = loop;
			playFrom = currentFrame = animationRange.start;
			playTo = animationRange.end;
			
			if (playFrom >= playTo) stop();
			else play();
			
			currentFrame = playFrom + animationRange.startOffset;
			for (var i:int = layers.length - 1; i >= 0; i--)
			{
				layers[i].bitmapData = framesPerLayer[i][int(currentFrame)];
				layers[i].smoothing = smoothing;
			}
		}
	}

}