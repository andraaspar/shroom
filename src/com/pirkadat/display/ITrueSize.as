package com.pirkadat.display
{
	import flash.display.*;
	import flash.geom.*;
	
	/**
	* Adds useful resizing and aligning related methods to DisplayObject subclasses.
	* @author András Parditka
	*/
	public interface ITrueSize 
	{
		function get x():Number;
		function set x(value:Number):void;
		
		function get y():Number;
		function set y(value:Number):void;
		
		/**
		 * Specifies the external horizontal size of the object in pixels. This takes rotation into account.
		 * Setting it to 0 will destroy rotation and skew transformations.
		 */
		function get xSize():Number;
		function set xSize(aWidth:Number):void;
		
		/**
		 * Specifies the external vertical size of the object in pixels. This takes rotation into account.
		 * Setting it to 0 will destroy rotation and skew transformations.
		 */
		function get ySize():Number;
		function set ySize(aHeight:Number):void;
		
		/**
		 * Specifies the external x co-ordinate of the object's left side.
		 * This may be different from the x co-ordinate of the object.
		 */
		function get left():Number;
		function set left(anX:Number):void;
		
		/**
		 * Returns the prospective x co-ordinate of the object, after the object's left side co-ordinate has been set to anX.
		 * The transformation will not take place, only a calculation.
		 * @param	anX
		 * An x co-ordinate to set the object's left side to.
		 * @return
		 * The x co-ordinate of the object.
		 */
		function xIfLeft(anX:Number):Number;
		
		/**
		 * Specifies the external x co-ordinate of the object's right side.
		 */
		function get right():Number;
		function set right(anX:Number):void;
		
		/**
		 * Returns the prospective x co-ordinate of the object, after the object's right side co-ordinate has been set to anX.
		 * The transformation will not take place, only a calculation.
		 * @param	anX
		 * An x co-ordinate to set the object's right side to.
		 * @return
		 * The x co-ordinate of the object.
		 */
		function xIfRight(anX:Number):Number;
		
		/**
		 * Specifies the external y co-ordinate of the object's top side.
		 * This may be different from the y co-ordinate of the object.
		 */
		function get top():Number;
		function set top(aY:Number):void;
		
		/**
		 * Returns the prospective y co-ordinate of the object, after the object's top side co-ordinate has been set to aY.
		 * The transformation will not take place, only a calculation.
		 * @param	aY
		 * A y co-ordinate to set the object's top side to.
		 * @return
		 * The y co-ordinate of the object.
		 */
		function yIfTop(aY:Number):Number;
		
		/**
		 * Specifies the external y co-ordinate of the object's bottom side.
		 */
		function get bottom():Number;
		function set bottom(aY:Number):void;
		
		/**
		 * Returns the prospective y co-ordinate of the object, after the object's bottom side co-ordinate has been set to aY.
		 * The transformation will not take place, only a calculation.
		 * @param	aY
		 * A y co-ordinate to set the object's bottom side to.
		 * @return
		 * The y co-ordinate of the object.
		 */
		function yIfBottom(aY:Number):Number;
		
		/**
		 * Specifies the external x co-ordinate of the object's horizontal center.
		 */
		function get xMiddle():Number;
		function set xMiddle(anX:Number):void;
		
		/**
		 * Returns the prospective x co-ordinate of the object, after the object's horizontal center co-ordinate has been set to anX.
		 * The transformation will not take place, only a calculation.
		 * @param	anX
		 * An x co-ordinate to set the object's horizontal center to.
		 * @return
		 * The x co-ordinate of the object.
		 */
		function xIfXMiddle(anX:Number):Number;
		
		/**
		 * Specifies the external y co-ordinate of the object's vetical center.
		 */
		function get yMiddle():Number;
		function set yMiddle(aY:Number):void;
		
		/**
		 * Returns the prospective y co-ordinate of the object, after the object's vertical center co-ordinate has been set to aY.
		 * The transformation will not take place, only a calculation.
		 * @param	aY
		 * A y co-ordinate to set the object's vertical center to.
		 * @return
		 * The y co-ordinate of the object.
		 */
		function yIfYMiddle(aY:Number):Number;
		
		/**
		 * Specifies the x and y co-ordinates of the object's center point as a Point object.
		 */
		function get middle():Point;
		function set middle(aMiddle:Point):void;
		
		/**
		 * xSize and ySize defined by a Point.
		 */
		function get size():Point;
		function set size(value:Point):void;
		
		/**
		 * x and y coordinates defined by a Point.
		 */
		function get location():Point;
		function set location(value:Point):void;
		
		/**
		 * location and size defined by a rectangle.
		 */
		function get rectangle():Rectangle;
		function set rectangle(value:Rectangle):void;
		
		function getRect(targetCoordinateSpace:DisplayObject):Rectangle;
	}
	
}