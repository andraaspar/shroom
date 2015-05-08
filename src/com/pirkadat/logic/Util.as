package com.pirkadat.logic
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	
	public class Util
	{
		/**
		 * New smooth method based on bezier curves. (Not exactly, as it uses the t in place of the x co-ordinate.)
		 * Interpolates between two values.
		 */
		public static function smooth(from:Number, to:Number, steps:int, ease:Number = 0, inAndOut:Boolean = false):Vector.<Number>
		{
			var i:int; // Looping.
			
			var difference:Number = to - from; // Full value difference.
			var stepDiff:Number; // Value of a linear step.
			var result:Vector.<Number> = new Vector.<Number>(steps + 1, true); // The vector returned.
			result[0] = from;
			result[steps] = to;
			
			if (ease == 0)
			// No easing: quick linear interpolation.
			{
				stepDiff = difference / steps;
				for (i = 1; i < steps; i++)
				{
					result[i] = from + stepDiff * i;
				}
			}
			else
			// Easing: bezier based interpolation.
			{
				var easeDiff:Number; // The amount easing moves control points.
				
				var t:Number; // t of the bezier curve.
				var tDiff:Number; // Value of a step on t.
				
				var sY:Number; // Starting point y.
				var cp1Y:Number; // Control point 1 y.
				var cp1Switch:int; // Switches cp1 direction based on inAndOut.
				var cp2Y:Number; // Control point 2 y.
				var eY:Number; // End point y.
				
				// Level 0 control points.
				
				var y0_0:Number;
				var y0_1:Number;
				var y0_2:Number;
				
				// Level 1 control points.
				
				var y1_0:Number;
				var y1_1:Number;
				
				easeDiff = ease * difference;
				
				sY = from;
				
				cp1Switch = (inAndOut) ? -1 : 1;
				cp1Y = from + easeDiff * cp1Switch;
				cp2Y = to + easeDiff;
				
				// Flexible approach to support all situations: limiting cp movement to the endpoints.
				// Of course, depends on positive or negative curve direction.
				
				if (difference >= 0) 
				{
					cp1Y = Math.max(from, Math.min(to, cp1Y));
					cp2Y = Math.max(from, Math.min(to, cp2Y));
				}
				else 
				{
					cp1Y = Math.min(from, Math.max(to, cp1Y));
					cp2Y = Math.min(from, Math.max(to, cp2Y));
				}
				
				eY = to;
				
				// Calculating iterations.
				
				t = 0;
				tDiff = 1 / steps;
				for (i = 1; i < steps; i++)
				{
					t += tDiff;
					
					y0_0 = sY + (cp1Y - sY) * t;
					y0_1 = cp1Y + (cp2Y - cp1Y) * t;
					y0_2 = cp2Y + (eY - cp2Y) * t;
					
					y1_0 = y0_0 + (y0_1 - y0_0) * t;
					y1_1 = y0_1 + (y0_2 - y0_1) * t;
					
					result[i] = y1_0 + (y1_1 - y1_0) * t;
				}
			}
			
			return result;
		}
		
		/**
		 * New smooth method based on bezier curves. (Not exactly, as it uses the t in place of the x co-ordinate.)
		 * Interpolates between two values.
		 */
		public static function smoothArrInt(from:Number, to:Number, steps:int, ease:Number = 0, inAndOut:Boolean = false):Array
		{
			var i:int; // Looping.
			
			var difference:Number = to - from; // Full value difference.
			var stepDiff:Number; // Value of a linear step.
			var result:Array = []; // The array returned.
			result[0] = from;
			result[steps] = to;
			
			if (ease == 0)
			// No easing: quick linear interpolation.
			{
				stepDiff = difference / steps;
				for (i = 1; i < steps; i++)
				{
					result[i] = int(from + stepDiff * i);
				}
			}
			else
			// Easing: bezier based interpolation.
			{
				var easeDiff:Number; // The amount easing moves control points.
				
				var t:Number; // t of the bezier curve.
				var tDiff:Number; // Value of a step on t.
				
				var sY:Number; // Starting point y.
				var cp1Y:Number; // Control point 1 y.
				var cp1Switch:int; // Switches cp1 direction based on inAndOut.
				var cp2Y:Number; // Control point 2 y.
				var eY:Number; // End point y.
				
				// Level 0 control points.
				
				var y0_0:Number;
				var y0_1:Number;
				var y0_2:Number;
				
				// Level 1 control points.
				
				var y1_0:Number;
				var y1_1:Number;
				
				easeDiff = ease * difference;
				
				sY = from;
				
				cp1Switch = (inAndOut) ? -1 : 1;
				cp1Y = from + easeDiff * cp1Switch;
				cp2Y = to + easeDiff;
				
				// Flexible approach to support all situations: limiting cp movement to the endpoints.
				// Of course, depends on positive or negative curve direction.
				
				if (difference >= 0) 
				{
					cp1Y = Math.max(from, Math.min(to, cp1Y));
					cp2Y = Math.max(from, Math.min(to, cp2Y));
				}
				else 
				{
					cp1Y = Math.min(from, Math.max(to, cp1Y));
					cp2Y = Math.min(from, Math.max(to, cp2Y));
				}
				
				eY = to;
				
				// Calculating iterations.
				
				t = 0;
				tDiff = 1 / steps;
				for (i = 1; i < steps; i++)
				{
					t += tDiff;
					
					y0_0 = sY + (cp1Y - sY) * t;
					y0_1 = cp1Y + (cp2Y - cp1Y) * t;
					y0_2 = cp2Y + (eY - cp2Y) * t;
					
					y1_0 = y0_0 + (y0_1 - y0_0) * t;
					y1_1 = y0_1 + (y0_2 - y0_1) * t;
					
					result[i] = int(y1_0 + (y1_1 - y1_0) * t);
				}
			}
			
			return result;
		}
		
		public static function drawWedge(bmd:BitmapData, radius:Number, thickness:Number, minDeg:Number, maxDeg:Number):void
		{
			bmd.lock();
			
			var pi:Number = Math.PI;
			var minRad:Number = minDeg * pi / 180;
			var maxRad:Number = maxDeg * pi / 180;
			var fullTurn:Number = pi * 2;
			
			while (maxRad - minRad > fullTurn)
			{
				maxRad -= fullTurn;
			}
			while (minRad > pi)
			{
				minRad -= fullTurn;
				maxRad -= fullTurn;
			}
			while (maxRad < -pi)
			{
				minRad += fullTurn;
				maxRad += fullTurn;
			}
			
			var pt:Point = new Point();
			var ptLen:Number;
			var ptRad:Number;
			
			for (var pty:Number = -radius; pty < radius; pty++)
			{
				for (var ptx:Number = -radius; ptx < radius; ptx++)
				{
					pt.x = ptx + .5;
					pt.y = pty + .5;
					ptLen = pt.length;
					
					if (ptLen <= radius
						&& ptLen >= radius - thickness)
					{
						ptRad = Math.atan2(pt.y, pt.x);
						if (ptRad < minRad) ptRad += fullTurn;
						else if (ptRad > maxRad) ptRad -= fullTurn;
						if (ptRad >= minRad
							&& ptRad <= maxRad)
						{
							bmd.setPixel(ptx + radius, pty + radius, 0x000000);
						}
					}
				}
			}
			
			bmd.unlock();
		}
		
		
		
		public static function degToXY(degrees:Number, distance:Number):Point
		{
			return Point.polar(distance, degrees * Math.PI / 180);
		}
		
		public static function xyToDeg(aPoint:Point):Number
		{
			var radians:Number = Math.atan2(aPoint.y, aPoint.x);
			return radians * 180 / Math.PI;
		}
		
		public static function radToXY(degrees:Number, distance:Number):Point
		{
			return Point.polar(distance, degrees);
		}
		
		public static function xyToRad(aPoint:Point):Number
		{
			return Math.atan2(aPoint.y, aPoint.x);
		}
		
		
		
		public static function traceProperties(anObj:Object):String {
			var aString:String = anObj.toString()+":\n";
			for (var i:String in anObj) {
				aString += "."+i+" = "+anObj[i]+"\n";
			}
			return aString;
		}
		
		public static function measureSpeed(aFunc:Function, times:int = 100000):Number
		{
			var startDate:Number;
			var endDate:Number;
			var i:int;
			
			startDate = new Date().getTime();
			for (i = 0; i < times; i++ )
			{
				aFunc();
			}
			endDate = new Date().getTime();
			return endDate - startDate;
		}
	}
}