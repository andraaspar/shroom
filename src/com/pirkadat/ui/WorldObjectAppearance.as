package com.pirkadat.ui 
{
	import com.pirkadat.display.*;
	import com.pirkadat.logic.*;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.geom.Point;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	public class WorldObjectAppearance extends TrueSize
	{
		public var worldObject:WorldObject;
		public var worldAppearance:WorldAppearance;
		
		public function WorldObjectAppearance(worldObject:WorldObject = null, worldAppearance:WorldAppearance = null) 
		{
			super();
			
			this.worldObject = worldObject;
			this.worldAppearance = worldAppearance;
		}
		
		public function update():void { }
		
		public function generateVisualObjects():Vector.<VisualObject>
		{
			return null;
		}
		
		public function getAssetIDs():Vector.<int>
		{
			return null;
		}
		
		protected function moveAndDraw(wayPoints:Vector.<Point>, lineWidth:Number, lineAlpha:Number, firstTime:Boolean = false):void
		{
			var wayPoint:Point;
			var i:int = 0;
			
			worldAppearance.canvas.graphics.lineStyle(lineWidth, worldObject.team.characterAppearance.color, lineAlpha);
			
			if (firstTime)
			{
				if (wayPoints.length)
				{
					wayPoint = wayPoints[i++];
					worldAppearance.canvas.graphics.moveTo(wayPoint.x, wayPoint.y);
				}
				else
				{
					worldAppearance.canvas.graphics.moveTo(worldObject.location.x, worldObject.location.y);
				}
			}
			else worldAppearance.canvas.graphics.moveTo(x, y);
			
			for (; i < wayPoints.length; i++)
			{
				wayPoint = wayPoints[i];
				worldAppearance.canvas.graphics.lineTo(wayPoint.x, wayPoint.y);
			}
			
			x = worldObject.location.x;
			y = worldObject.location.y;
			
			worldAppearance.canvas.graphics.lineTo(x, y);
		}
	}

}