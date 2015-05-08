package com.pirkadat.logic.level.gen 
{
	import com.pirkadat.display.*;
	import com.pirkadat.geom.*;
	import com.pirkadat.shapes.*;
	import com.pirkadat.ui.Console;
	import flash.display.*;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getQualifiedClassName;
	public class LevelGenerator 
	{
		private var template:ILevelTemplate;
		private var paths:Vector.<Path> = new Vector.<Path>();
		
		public function LevelGenerator(template:ILevelTemplate) 
		{
			this.template = template;
			generate();
		}
		
		private function generate():void
		{
			var dataVec:Vector.<String> = template.getData();
			var translate:String = template.getTranslate();
			var maxSegmentLength:Number = 200 + Math.random() * 200;
			var smoothRatio:Number = Math.random() < .5 ? 0 : 1;
			//CONFIG::debug {Console.say("New random level template:",getQualifiedClassName(template),", smoothRatio:",smoothRatio,", maxSegmentLength:",maxSegmentLength)}
			
			for each (var data:String in dataVec)
			{
				var path:Path = new Path(data, translate);
				path.refinePath(maxSegmentLength);
				path.randomizePoints();
				path.createControlPoints(smoothRatio);
				paths.push(path);
			}
		}
		
		private function getBitmapData(scale:Number, fillStyle:FillStyle, lineStyle:LineStyle, grassThickness:int = 0):BitmapData
		{
			var dimensions:Point = template.getDimensions();
			
			var obj:TrueSizeShape = new TrueSizeShape();
			obj.scaleX = obj.scaleY = scale;
			
			for each (var path:Path in paths)
			{
				path.drawTo(obj.graphics, fillStyle, lineStyle);
			}
			
			var result:BitmapData = new BitmapData(dimensions.x * scale, dimensions.y * scale, true, 0);
			
			var m:Matrix = new Matrix();
			m.translate(0, -grassThickness);
			var brightness:Number = 3;
			var brightnessStep:Number = (1 - brightness) / grassThickness;
			for (; m.ty < 0; m.translate(0, 1))
			{
				result.draw(obj, m, new BrightnessColorTransform(brightness), obj.blendMode);
				brightness += brightnessStep;
			}
			
			result.draw(obj, obj.transform.matrix, obj.transform.colorTransform, obj.blendMode);
			if (obj.parent) obj.parent.removeChild(obj);
			
			return result;
		}
		
		public function getTerrain(levelStyle:LevelStyle):BitmapData
		{
			return getBitmapData(1, levelStyle.getTerrainFillStyle(), levelStyle.getTerrainLineStyle(), 12);
		}
		
		public function getBackground(levelStyle:LevelStyle):BitmapData
		{
			return getBitmapData(1, levelStyle.getBackgroundFillStyle(), levelStyle.getBackgroundLineStyle());
		}
		
		public function getPreview():BitmapData
		{
			var dimensions:Point = template.getDimensions();
			var scale:Number = .1;
			var result:BitmapData = new BitmapData(dimensions.x * scale, dimensions.y * scale, false, 0x383d44);
			var terrain:BitmapData = getBitmapData(scale, new FillStyle(0xffffff, .6), new LineStyle(3, 0xffffff, 1, false, LineScaleMode.NORMAL, CapsStyle.ROUND, JointStyle.ROUND));
			result.copyPixels(terrain, new Rectangle(0, 0, terrain.width, terrain.height), new Point(), null, null, true);
			terrain.dispose();
			return result;
		}
	}

}