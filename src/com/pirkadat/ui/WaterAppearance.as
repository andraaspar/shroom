package com.pirkadat.ui 
{
	import com.pirkadat.display.TrueSize;
	import com.pirkadat.display.TrueSizeBitmap;
	import com.pirkadat.display.TrueSizeShape;
	import com.pirkadat.logic.Program;
	import com.pirkadat.shapes.Box;
	import com.pirkadat.shapes.GradientStyle;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.display.BlendMode;
	import flash.display.GradientType;
	import flash.display.PixelSnapping;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.DisplacementMapFilterMode;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class WaterAppearance extends TrueSize
	{
		public var gradient:TrueSizeShape;
		public var reflection:TrueSizeBitmap;
		public var reflectionBMD:BitmapData;
		public var waterDisplacementGradient:WaterDisplacementGradient;
		public var fadeGradient:TrueSizeShape;
		public var displacementMapFilter:DisplacementMapFilter;
		public var reflectionRectangle:Rectangle = new Rectangle();
		public var nullPoint:Point = new Point();
		
		public function WaterAppearance() 
		{
			super();
			
			build();
		}
		
		protected function build():void
		{
			gradient = Program.game.level.getWaterColorGradient();
			addChild(gradient);
			sizeMask = gradient;
			
			//
			
			reflection = new TrueSizeBitmap(null, PixelSnapping.NEVER, false);
			addChild(reflection);
			//reflection.blendMode = BlendMode.OVERLAY;
			
			//
			
			waterDisplacementGradient = new WaterDisplacementGradient();
			
			//
			
			displacementMapFilter = new DisplacementMapFilter(null, nullPoint, BitmapDataChannel.RED, 0, 8, 0, DisplacementMapFilterMode.COLOR, 0, 0);
			
			//
			
			fadeGradient = new Box(null, new GradientStyle([0x7f7f7f, 0], [1, 1], [0, 255]));
		}
		
		override public function get width():Number { return super.width; }
		
		override public function set width(value:Number):void 
		{
			gradient.width = value;
		}
		
		override public function get height():Number { return super.height; }
		
		override public function set height(value:Number):void 
		{
			gradient.height = value;
		}
		
		public function updateReflection(worldAppearance:WorldAppearance):void
		{
			reflectionRectangle.width = Math.ceil((stage.stageWidth + 200) / 2);
			reflectionRectangle.height = Math.ceil(stage.stageHeight / 4);
			
			if (!reflectionBMD
				|| reflectionBMD.width != reflectionRectangle.width
				|| reflectionBMD.height != reflectionRectangle.height)
			{
				if (reflectionBMD) reflectionBMD.dispose();
				
				reflectionBMD = new BitmapData(reflectionRectangle.width, reflectionRectangle.height, true, 0);
				reflection.bitmapData = reflectionBMD;
			}
			
			var m:Matrix = new Matrix();
			m.scale(worldAppearance.scaleX / 2, -worldAppearance.scaleY / 2);
			m.translate((worldAppearance.x + 100) / 2, y * worldAppearance.scaleY / 2);
			
			reflectionBMD.draw(worldAppearance, m);
			
			waterDisplacementGradient.xSize = reflectionRectangle.width;
			waterDisplacementGradient.ySize = reflectionRectangle.height;
			waterDisplacementGradient.update();
			
			var tempBMD:BitmapData = new BitmapData(reflectionRectangle.width, reflectionRectangle.height, false, 0);
			tempBMD.draw(waterDisplacementGradient, waterDisplacementGradient.transform.matrix);
			displacementMapFilter.mapBitmap = tempBMD;
			reflectionBMD.applyFilter(reflectionBMD, reflectionRectangle, nullPoint, displacementMapFilter);
			
			fadeGradient.xSize = reflectionRectangle.width;
			fadeGradient.ySize = reflectionRectangle.height;
			
			tempBMD.draw(fadeGradient, fadeGradient.transform.matrix);
			reflectionBMD.copyChannel(tempBMD, reflectionRectangle, nullPoint, BitmapDataChannel.RED, BitmapDataChannel.ALPHA);
			
			tempBMD.dispose();
			
			reflection.x = (-worldAppearance.left - 100) * (1 / worldAppearance.scaleX);
			reflection.scaleX = 1 / worldAppearance.scaleX * 2;
			reflection.scaleY = 1 / worldAppearance.scaleY * 2;
		}
	}

}