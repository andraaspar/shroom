package com.pirkadat.geom 
{
	import com.pirkadat.shapes.FillStyle;
	import com.pirkadat.shapes.LineStyle;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Point;
	public class Path 
	{
		private var points:Vector.<Point> = new Vector.<Point>();
		private var controlPoints:Vector.<Point> = new Vector.<Point>();
		
		public function Path(data:String, translate:String) 
		{
			parse(data, translate);
		}
		
		public function parse(data:String, translate:String):void
		{
			var splitTrans:Array = translate.split(",");
			var tx:Number = splitTrans[0];
			var ty:Number = splitTrans[1];
			
			var splitData:Array = data.split(" ");
			for (var i:int = 0, n:int = splitData.length; i < n; i++)
			{
				var splitCoords:Array = String(splitData[i]).split(",");
				var p:Point = new Point(Number(splitCoords[0]) + tx, Number(splitCoords[1]) + ty);
				
				points.push(p);
			}
		}
		
		public function clear():void
		{
			points = new Vector.<Point>();
			controlPoints = new Vector.<Point>();
		}
		
		public function drawTo(g:Graphics, fillStyle:FillStyle, lineStyle:LineStyle):void
		{
			if (fillStyle) fillStyle.applyTo(g);
			if (lineStyle) lineStyle.applyTo(g);
			
			for (var i:int = 0, n:int = points.length; i <= n; i++)
			{
				var p:Point = getPointAt(i);
				var cp:Point = null;
				if (i > 0) cp = getControlPointAt(i-1);
				
				if (i == 0)
				{
					g.moveTo(p.x, p.y);
				}
				else
				{
					if (cp) g.curveTo(cp.x, cp.y, p.x, p.y);
					else g.lineTo(p.x, p.y);
				}
			}
			
			g.endFill();
		}
		
		public function randomizePoints():void
		{
			for (var i:int = 0, n:int = points.length; i < n; i++)
			{
				randomizePoint(i);
			}
		}
		
		private function getFromVectorLooped(vec:Vector.<Point>, index:int):Point
		{
			if (vec.length == 0) return null;
			index %= vec.length;
			if (index < 0) index = vec.length + (index % -vec.length);
			return vec[index];
		}
		
		private function getPointAt(index:int):Point
		{
			return getFromVectorLooped(points, index);
		}
		
		private function getControlPointAt(index:int):Point
		{
			return getFromVectorLooped(controlPoints, index);
		}
		
		private function randomizePoint(index:int):void
		{
			var p1:Point = getPointAt(index - 1);
			var p2:Point = getPointAt(index);
			var p3:Point = getPointAt(index + 1);
			
			var distance:Number = Math.min(Point.distance(p1, p2), Point.distance(p2, p3));
			distance *= .95;
			distance *= Math.random();
			
			var direction:Number = 2 * Math.PI * Math.random();
			
			var offset:Point = Point.polar(distance, direction);
			p2.offset(offset.x, offset.y);
		}
		
		private function insertPointAt(index:int):void
		{
			var p1:Point = getPointAt(index - 1);
			var p2:Point;
			var p3:Point = getPointAt(index);
			
			p2 = Point.interpolate(p1, p3, .3 + Math.random() * .4);
			points.splice(index, 0, p2);
		}
		
		private function insertControlPointAt(index:int, smoothRatio:Number):void
		{
			var p1:Point = getPointAt(index);
			var p2:Point = getPointAt(index + 1);
			var distP:Point = p2.subtract(p1);
			var dist:Number = distP.length * .5;
			var cp1:Point = getControlPointAt(index - 1);
			var cp2:Point;
			if (cp1 && Math.random() < smoothRatio)
			{
				cp2 = p1.subtract(cp1);
			}
			else
			{
				
				cp2 = Point.polar(dist, Math.random() * Math.PI - Math.PI / 2 + Math.atan2(distP.y, distP.x));
			}
			cp2.normalize(1);
			cp2.x *= dist;
			cp2.y *= dist;
			cp2 = p1.add(cp2);
			controlPoints.splice(index, 0, cp2);
		}
		
		public function refinePath(maxSegmentLength:Number):void
		{
			var reCheck:Boolean = true;
			var p1:Point, p2:Point;
			while (reCheck)
			{
				reCheck = false;
				for (var i:int = points.length - 1; i >= 0; i--)
				{
					p1 = getPointAt(i - 1);
					p2 = getPointAt(i);
					if (p2.subtract(p1).length > maxSegmentLength)
					{
						insertPointAt(i);
						reCheck = true;
					}
				}
			}
		}
		
		public function createControlPoints(smoothRatio:Number):void
		{
			for (var i:int = 0, n:int = points.length; i < n; i++)
			{
				insertControlPointAt(i, smoothRatio);
			}
		}
	}

}