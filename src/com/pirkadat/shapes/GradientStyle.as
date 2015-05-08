package com.pirkadat.shapes 
{
	import com.pirkadat.logic.Util;
	import flash.display.*;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import com.pirkadat.ui.Colors;
	
	public class GradientStyle 
	{
		public var type:String;
		public var colors:Array;
		public var alphas:Array;
		public var ratios:Array;
		protected var matrix:Matrix;
		public var spreadMethod:String;
		public var interpolationMethod:String;
		public var focalPointRatio:Number;
		protected var gradientRotation:Number;
		protected var matrixWidth:Number = 100;
		protected var matrixHeight:Number = 100;
		protected var matrixScaleX:Number;
		protected var matrixScaleY:Number;
		protected var matrixOffset:Number = 0;
		protected var matrixOffsetDirection:Number = 0;
		protected var matrixTX:Number;
		protected var matrixTY:Number;
		protected var matrixSize:Number;
		
		public function GradientStyle(colors:Array = null, alphas:Array = null, ratios:Array = null, gradientRotation:Number = 90, type:String = 'linear', matrixScaleX:Number = 1, matrixScaleY:Number = 1, matrixOffset:Number = 0, matrixOffsetDirection:Number = 0) 
		{
			this.type = type;
			if (colors == null) colors = [Colors.LIGHTESTGRAY, Colors.WHITE, Colors.LIGHTESTGRAY, Colors.LIGHTGRAY];
			this.colors = colors;
			if (alphas == null) alphas = [1, 1, 1, 1];
			this.alphas = alphas;
			if (ratios == null) ratios = [0, 110, 111, 255];
			this.ratios = ratios;
			
			matrix = new Matrix();
			modifyMatrix(NaN, NaN, gradientRotation, matrixScaleX, matrixScaleY, matrixOffset, matrixOffsetDirection);
			
			spreadMethod = SpreadMethod.PAD;
			interpolationMethod = InterpolationMethod.RGB;
			focalPointRatio = 0;
		}
		
		public function modifyMatrix(width:Number = NaN, height:Number = NaN, gradientRotation:Number = NaN, matrixScaleX:Number = NaN, matrixScaleY:Number = NaN, matrixOffset:Number = NaN, matrixOffsetDirection:Number = NaN):void
		{
			if (!isNaN(width)) matrixWidth = width;
			if (!isNaN(height)) matrixHeight = height;
			if (!isNaN(gradientRotation)) this.gradientRotation = gradientRotation;
			if (!isNaN(matrixScaleX)) this.matrixScaleX = matrixScaleX;
			if (!isNaN(matrixScaleY)) this.matrixScaleY = matrixScaleY;
			if (!isNaN(matrixOffset)) this.matrixOffset = matrixOffset;
			if (!isNaN(matrixOffsetDirection)) this.matrixOffsetDirection = matrixOffsetDirection;
			
			if (!isNaN(width) || !isNaN(height) || !isNaN(matrixScaleX) || !isNaN(matrixScaleY) || !isNaN(matrixOffset) || !isNaN(matrixOffsetDirection))
			{
				matrixSize = new Point(matrixWidth / 2, matrixHeight / 2).length;
				var point:Point = Util.degToXY(this.matrixOffsetDirection, matrixSize * this.matrixOffset);
				switch (type)
				{
					case GradientType.LINEAR:
						matrixTX = point.x;
						matrixTY = point.y;
					break;
					
					case GradientType.RADIAL:
						matrixTX = -(matrixWidth * (this.matrixScaleX - 1)) / 2 + point.x;
						matrixTY = -(matrixHeight * (this.matrixScaleY - 1)) / 2 + point.y;
					break;
				}
			}
			
			matrix.createGradientBox(matrixWidth * this.matrixScaleX, matrixHeight * this.matrixScaleY, this.gradientRotation / 180 * Math.PI, matrixTX, matrixTY);
		}
		
		public function applyTo(graphics:Graphics):void
		{
			graphics.beginGradientFill(type, colors, alphas, ratios, matrix, spreadMethod, interpolationMethod, focalPointRatio);
		}
	}
	
}