package com.pirkadat.display {
	
	import flash.display.*;
	import flash.geom.*;
	
	public class TrueSizeLoader extends Loader implements ITrueSize
	{
		public var sizeMask:ITrueSize;
		protected var internalLocation:Point = new Point();
		
		public function TrueSizeLoader()
		{
			LimboHost.limbo.addChild(this);
		}
		
		override public function get x():Number { return internalLocation.x; }
		
		override public function set x(value:Number):void 
		{
			internalLocation.x = value;
			super.x = value;
		}
		
		override public function get y():Number { return internalLocation.y; }
		
		override public function set y(value:Number):void 
		{
			internalLocation.y = value;
			super.y = value;
		}
		
		/**
		 * Specifies the external horizontal size of the object in pixels. This takes rotation into account.
		 * Setting it to 0 will destroy rotation and skew transformations.
		 */
		public function get xSize():Number
		{
			return getRect(parent).width;
		}
		
		public function set xSize(aWidth:Number):void
		{
			if (!getRect(parent).width)
			{
				var previousRect:Rectangle = getRect(parent);
				transform.matrix = new Matrix();
				
				var newMatrix:Matrix = new Matrix();
				var newYScale:Number = previousRect.height / getRect(parent).height;
				newMatrix.scale(1, newYScale);
				newMatrix.tx = previousRect.x;
				newMatrix.ty = previousRect.y;
				transform.matrix = newMatrix;
			}
			
			var newScale:Number = aWidth / getRect(parent).width;
			
			var currentMatrix:Matrix = transform.matrix;
			var prevX:Number = currentMatrix.tx;
			
			var scaleMatrix:Matrix = new Matrix();
			scaleMatrix.scale(newScale, 1);
			
			currentMatrix.concat(scaleMatrix);
			currentMatrix.tx = prevX;
			transform.matrix = currentMatrix;
		}
		
		/**
		 * Specifies the external vertical size of the object in pixels. This takes rotation into account.
		 * Setting it to 0 will destroy rotation and skew transformations.
		 */
		public function get ySize():Number {
			return getRect(parent).height;
		}
		
		public function set ySize(aHeight:Number):void
		{
			if (!getRect(parent).height)
			{
				var previousRect:Rectangle = getRect(parent);
				transform.matrix = new Matrix();
				
				var newMatrix:Matrix = new Matrix();
				var newXScale:Number = previousRect.width / getRect(parent).width;
				newMatrix.scale(newXScale, 1);
				newMatrix.tx = previousRect.x;
				newMatrix.ty = previousRect.y;
				transform.matrix = newMatrix;
			}
			
			var newScale:Number = aHeight / getRect(parent).height;
			
			var currentMatrix:Matrix = transform.matrix;
			var prevY:Number = currentMatrix.ty;
			
			var scaleMatrix:Matrix = new Matrix();
			scaleMatrix.scale(1, newScale);
			
			currentMatrix.concat(scaleMatrix);
			currentMatrix.ty = prevY;
			transform.matrix = currentMatrix;
		}
		
		/**
		 * Specifies the external x co-ordinate of the object's left side.
		 * This may be different from the x co-ordinate of the object.
		 */
		public function get left():Number {
			return getRect(parent).left;
		}
		
		public function set left(anX:Number):void {
			var trueInnerLeft:Number = getRect(parent).left - x;
			x = anX - trueInnerLeft;
		}
		
		/**
		 * Returns the prospective x co-ordinate of the object, after the object's left side co-ordinate has been set to anX.
		 * The transformation will not take place, only a calculation.
		 * @param	anX
		 * An x co-ordinate to set the object's left side to.
		 * @return
		 * The x co-ordinate of the object.
		 */
		public function xIfLeft(anX:Number):Number {
			var trueInnerLeft:Number = getRect(parent).left - x;
			return anX - trueInnerLeft;
		}
		
		/**
		 * Specifies the external x co-ordinate of the object's right side.
		 */
		public function get right():Number {
			return getRect(parent).right;
		}
		
		public function set right(anX:Number):void {
			var trueInnerRight:Number = getRect(parent).right - x;
			x = anX - trueInnerRight;
		}
		
		/**
		 * Returns the prospective x co-ordinate of the object, after the object's right side co-ordinate has been set to anX.
		 * The transformation will not take place, only a calculation.
		 * @param	anX
		 * An x co-ordinate to set the object's right side to.
		 * @return
		 * The x co-ordinate of the object.
		 */
		public function xIfRight(anX:Number):Number {
			var trueInnerRight:Number = getRect(parent).right - x;
			return anX - trueInnerRight;
		}
		
		/**
		 * Specifies the external y co-ordinate of the object's top side.
		 * This may be different from the y co-ordinate of the object.
		 */
		public function get top():Number {
			return getRect(parent).top;
		}
		
		public function set top(aY:Number):void {
			var trueInnerTop:Number = getRect(parent).top - y;
			y = aY - trueInnerTop;
		}
		
		/**
		 * Returns the prospective y co-ordinate of the object, after the object's top side co-ordinate has been set to aY.
		 * The transformation will not take place, only a calculation.
		 * @param	aY
		 * A y co-ordinate to set the object's top side to.
		 * @return
		 * The y co-ordinate of the object.
		 */
		public function yIfTop(aY:Number):Number {
			var trueInnerTop:Number = getRect(parent).top - y;
			return aY - trueInnerTop;
		}
		
		/**
		 * Specifies the external y co-ordinate of the object's bottom side.
		 */
		public function get bottom():Number {
			return getRect(parent).bottom;
		}
		
		public function set bottom(aY:Number):void {
			var trueInnerBottom:Number = getRect(parent).bottom - y;
			y = aY - trueInnerBottom;
		}
		
		/**
		 * Returns the prospective y co-ordinate of the object, after the object's bottom side co-ordinate has been set to aY.
		 * The transformation will not take place, only a calculation.
		 * @param	aY
		 * A y co-ordinate to set the object's bottom side to.
		 * @return
		 * The y co-ordinate of the object.
		 */
		public function yIfBottom(aY:Number):Number {
			var trueInnerBottom:Number = getRect(parent).bottom - y;
			return aY - trueInnerBottom;
		}
		
		/**
		 * Specifies the external x co-ordinate of the object's horizontal center.
		 */
		public function get xMiddle():Number {
			var size:Rectangle = getRect(parent);
			return size.width / 2 + size.left;
		}
		
		public function set xMiddle(anX:Number):void {
			var size:Rectangle = getRect(parent);
			var middle:Number = size.width / 2 + size.left;
			var middleFromOrigo:Number = middle - x;
			x = anX - middleFromOrigo;
		}
		
		/**
		 * Returns the prospective x co-ordinate of the object, after the object's horizontal center co-ordinate has been set to anX.
		 * The transformation will not take place, only a calculation.
		 * @param	anX
		 * An x co-ordinate to set the object's horizontal center to.
		 * @return
		 * The x co-ordinate of the object.
		 */
		public function xIfXMiddle(anX:Number):Number {
			var size:Rectangle = getRect(parent);
			var middle:Number = size.width / 2 + size.left;
			var middleFromOrigo:Number = middle - x;
			return anX - middleFromOrigo;
		}
		
		/**
		 * Specifies the external y co-ordinate of the object's vetical center.
		 */
		public function get yMiddle():Number {
			var size:Rectangle = getRect(parent);
			return size.height / 2 + size.top;
		}
		
		public function set yMiddle(aY:Number):void {
			var size:Rectangle = getRect(parent);
			var middle:Number = size.height / 2 + size.top;
			var middleFromOrigo:Number = middle - y;
			y = aY - middleFromOrigo;
		}
		
		/**
		 * Returns the prospective y co-ordinate of the object, after the object's vertical center co-ordinate has been set to aY.
		 * The transformation will not take place, only a calculation.
		 * @param	aY
		 * A y co-ordinate to set the object's vertical center to.
		 * @return
		 * The y co-ordinate of the object.
		 */
		public function yIfYMiddle(aY:Number):Number {
			var size:Rectangle = getRect(parent);
			var middle:Number = size.height / 2 + size.top;
			var middleFromOrigo:Number = middle - y;
			return aY - middleFromOrigo;
		}
		
		/**
		 * Specifies the x and y co-ordinates of the object's center point as a Point object.
		 */
		public function get middle():Point {
			var size:Rectangle = getRect(parent);
			
			var middleX:Number = size.width / 2 + size.left;
			var middleY:Number = size.height / 2 + size.top;
			
			return new Point(middleX, middleY);
		}
		
		public function set middle(aMiddle:Point):void {
			var size:Rectangle = getRect(parent);
			
			var middle:Number = size.width / 2 + size.left;
			var middleFromOrigo:Number = middle - x;
			x = aMiddle.x - middleFromOrigo;
			
			middle = size.height / 2 + size.top;
			middleFromOrigo = middle - y;
			y = aMiddle.y - middleFromOrigo;
		}
		
		/**
		 * xSize and ySize defined by a Point.
		 */
		public function get size():Point
		{
			var size:Rectangle = getRect(parent);
			return new Point(size.width, size.height);
		}
		
		public function set size(value:Point):void
		{
			xSize = value.x;
			ySize = value.y;
		}
		
		/**
		 * x and y coordinates defined by a Point.
		 */
		public function get location():Point
		{
			return internalLocation.clone();
		}
		
		public function set location(value:Point):void
		{
			x = value.x;
			y = value.y;
		}
		
		/**
		 * location and size defined by a rectangle.
		 */
		public function get rectangle():Rectangle
		{
			return getRect(parent);
		}
		
		public function set rectangle(value:Rectangle):void
		{
			top = value.top;
			left = value.left;
			xSize = value.width;
			ySize = value.height;
		}
		
		override public function getRect(targetCoordinateSpace:DisplayObject):Rectangle 
		{
			var result:Rectangle;
			
			if (sizeMask)
			{
				result = sizeMask.getRect(targetCoordinateSpace);
			}
			else
			{
				for (var i:int = numChildren - 1; i >= 0; i--)
				{
					if (!result)
					{
						result = getChildAt(i).getRect(targetCoordinateSpace);
						continue;
					}
					
					var aRect:Rectangle = getChildAt(i).getRect(targetCoordinateSpace);
					if (aRect.top < result.top) result.top = aRect.top;
					if (aRect.bottom > result.bottom) result.bottom = aRect.bottom;
					if (aRect.left < result.left) result.left = aRect.left;
					if (aRect.right > result.right) result.right = aRect.right;
				}
				
				if (!result) result = super.getRect(targetCoordinateSpace);
			}
			
			return result;
		}
	}
}