package com.pirkadat.shapes 
{
	import com.pirkadat.display.*;
	
	/**
	 * This class is based on code written by Ric Ewing (www.ricewing.com).
	 * @author András Parditka
	 */
	public class Arc extends TrueSizeShape
	{
		protected var _startAngle:Number;
		protected var _arc:Number;
		protected var _radius:Number;
		
		public var lineStyle:LineStyle;
		public var lineGradientStyle:LineGradientStyle;
		
		public function Arc(radius:Number, startAngle:Number, arc:Number, lineStyle:LineStyle = null, lineGradientStyle:LineGradientStyle = null) 
		{
			if (lineStyle == null && lineGradientStyle == null)
			{
				lineStyle = new LineStyle();
			}
			
			this.lineStyle = lineStyle;
			this.lineGradientStyle = lineGradientStyle;
			
			//
			
			_radius = radius;
			
			// No need to draw more than 360
			if (Math.abs(arc) > 360) 
			{
				arc = 360;
			}
			_arc = arc;
			
			_startAngle = startAngle;
			
			update();
		}
		
		protected function update():void
		{
			graphics.clear();
			
			//
			
			lineStyle.applyTo(graphics);
			if (lineGradientStyle != null)
			{
				lineGradientStyle.applyTo(graphics);
			}
			
			//
			
			var segAngle:Number;
			var angle:Number;
			var angleMid:Number;
			var numOfSegs:Number;
			var ax:Number;
			var ay:Number;
			var bx:Number;
			var by:Number;
			var cx:Number;
			var cy:Number;
			
			numOfSegs = Math.ceil(Math.abs(_arc) / 45);
			segAngle = _arc / numOfSegs;
			segAngle = (segAngle / 180) * Math.PI;
			angle = (_startAngle / 180) * Math.PI;
			
			// Calculate the start point
			ax = Math.cos(angle) * radius;
			ay = Math.sin(angle) * radius;
			
			graphics.moveTo(ax, ay);

			for (var i:int = 0; i < numOfSegs; i++) 
			{
				angle += segAngle;
				angleMid = angle - (segAngle / 2);
				bx = Math.cos(angle) * radius;
				by = Math.sin(angle) * radius;
				cx = Math.cos(angleMid) * (radius / Math.cos(segAngle / 2));
				cy = Math.sin(angleMid) * (radius / Math.cos(segAngle / 2));
				graphics.curveTo(cx, cy, bx, by);
				//graphics.lineTo(bx,by);
			}
		}
		
		public function get startAngle():Number { return _startAngle; }
		
		public function set startAngle(value:Number):void 
		{
			_startAngle = value;
			
			update();
		}
		
		public function get arc():Number { return _arc; }
		
		public function set arc(value:Number):void 
		{
			// No need to draw more than 360
			if (Math.abs(value) > 360) 
			{
				value = 360;
			}
			
			_arc = value;
			
			update();
		}
		
		public function get radius():Number { return _radius; }
		
		public function set radius(value:Number):void 
		{
			_radius = value;
			
			update();
		}
	}

}