package com.pirkadat.shapes 
{
	import flash.display.*;
	import flash.geom.Matrix;
	import com.pirkadat.ui.Colors;
	
	public class LineGradientStyle 
	{
		public var type:String;
		public var colors:Array;
		public var alphas:Array;
		public var ratios:Array;
		public var matrix:Matrix;
		public var spreadMethod:String;
		public var interpolationMethod:String;
		public var focalPointRatio:Number;
		public var gradientRotation:Number;
		public var matrixWidth:Number = 100;
		public var matrixHeight:Number = 100;
		
		public function LineGradientStyle(colors:Array = null, alphas:Array = null, ratios:Array = null, gradientRotation:Number = 90) 
		{
			type = GradientType.LINEAR;
			if (colors == null) colors = [Colors.LIGHTGRAY, Colors.GRAY];
			this.colors = colors;
			if (alphas == null) alphas = [1, 1];
			this.alphas = alphas;
			if (ratios == null) ratios = [0, 255];
			this.ratios = ratios;
			this.gradientRotation = gradientRotation;
			
			matrix = new Matrix();
			matrix.createGradientBox(matrixWidth, matrixHeight, this.gradientRotation / 180 * Math.PI);
			
			spreadMethod = SpreadMethod.PAD;
			interpolationMethod = InterpolationMethod.RGB;
			focalPointRatio = 0;
		}
		
		public function modifyMatrix(width:Number = NaN, height:Number = NaN, gradientRotation:Number = NaN):void
		{
			if (!isNaN(width)) matrixWidth = width;
			if (!isNaN(height)) matrixHeight = height;
			if (!isNaN(gradientRotation)) this.gradientRotation = gradientRotation;
			matrix.createGradientBox(matrixWidth, matrixHeight, this.gradientRotation / 180 * Math.PI);
		}
		
		public function applyTo(graphics:Graphics):void
		{
			graphics.lineGradientStyle(type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio);
		}
		
	}
	
}