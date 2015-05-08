package com.pirkadat.ui 
{
	import com.pirkadat.display.TrueSize;
	import com.pirkadat.display.TrueSizeShape;
	import com.pirkadat.shapes.Arc;
	import com.pirkadat.shapes.LineStyle;
	import flash.display.BlendMode;
	import flash.display.CapsStyle;
	import flash.display.LineScaleMode;
	
	public class HealthMeter extends TrueSize
	{
		public var healthArcs:Vector.<Arc>;
		public var healthDisplayed:int;
		public var healthArcMeans:int = 100;
		public var colour:int;
		public var radius:Number;
		public var thickness:Number;
		
		public function HealthMeter(colour:int, radius:Number, thickness:Number) 
		{
			this.colour = colour;
			this.radius = radius;
			this.thickness = thickness;
			
			healthArcs = new Vector.<Arc>();
			
			blendMode = BlendMode.ADD;
		}
		
		public function update(health:int):void
		{
			var healthArc:Arc;
			
			healthDisplayed = health;
			while (healthArcs.length < int(healthDisplayed / healthArcMeans) + 1)
			{
				healthArc = new Arc(radius, -90, 360, new LineStyle(thickness, colour, .5, false, LineScaleMode.NORMAL, CapsStyle.NONE));
				healthArc.radius += healthArcs.push(healthArc) * thickness;
				addChild(healthArc);
				healthArc.scaleX = -1;
			}
			
			while (healthArcs.length > int(healthDisplayed / healthArcMeans) + 1)
			{
				removeChild(healthArcs.pop());
			}
			
			for (var i:int = 0; i < healthArcs.length; i++)
			{
				healthArcs[i].arc = 360 * ((healthDisplayed - i * healthArcMeans) / healthArcMeans);
			}
			
		}
	}

}