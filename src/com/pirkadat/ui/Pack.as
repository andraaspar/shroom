package com.pirkadat.ui
{
	import com.pirkadat.display.*;
	import flash.geom.*;
	import flash.utils.*;
	
	/**
	 * Helps arranging elements.
	 */
	public class Pack extends TrueSize
	{
		/**
		 * The distance between those elements which do not have one set explicitly.
		 */
		public var defaultDistance:Number;
		
		/**
		 * The default alignment of items, only in use if not null.
		 */
		public var align:String;
		
		/**
		 * A PackDirections constant, specifying the direction of the elements.
		 */
		public var direction:String;
		
		/**
		 * The order in which elements are processed.
		 */
		public var order:Array;
		
		/**
		 * The distance between elements.
		 */
		public var distances:Dictionary;
		
		/**
		 * Creates a new Pack.
		 */
		public function Pack()
		{
			reset();
		}
		
		/**
		 * Sets all properties of this object to their default values.
		 */
		public function reset():void
		{
			defaultDistance = 6;
			
			direction = PackDirections.HORIZONTAL;
			order = null;
			distances = new Dictionary(true);
		}
		
		/**
		 * Sets the defaultDistance property to a value that will make children line up so that they fit into a given space.
		 * @param	aSpace
		 * The available space to fit children into.
		 * @return
		 * Returns true if the defaultDistance was set to a positive number (zero inclusive), false otherwise.
		 */
		public function fitIntoSpace(aSpace:Number):Boolean
		{
			var objects:int = numChildren;
			
			var orderToUse:Array;
			if (order == null)
			{
				orderToUse = [];
				
				for (var i:int = 0; i < objects; i++ )
				{
					orderToUse.push(getChildAt(i));
				}
			}
			else
			{
				orderToUse = order;
				objects = orderToUse.length;
			}
			
			if (objects < 1) throw new Error("Pack has no children to fit into space.");
			
			if (direction == PackDirections.HORIZONTAL)
			{
				for (i = 0; i < objects; i++)
				{
					aSpace -= ITrueSize(orderToUse[i]).xSize;
				}
			}
			else if (direction == PackDirections.VERTICAL)
			{
				for (i = 0; i < objects; i++)
				{
					aSpace -= ITrueSize(orderToUse[i]).ySize;
				}
			}
			defaultDistance = aSpace / (objects - 1);
			return (defaultDistance >= 0);
		}
		
		/**
		 * Moves children according to relevant properties.
		 */
		public function update():void
		{
			// CHECKS
			
			var objects:int = numChildren;
			
			var orderToUse:Array;
			if (order == null)
			{
				orderToUse = [];
				
				for (var i:int = 0; i < objects; i++ )
				{
					orderToUse.push(getChildAt(i));
				}
			}
			else
			{
				orderToUse = order;
				objects = orderToUse.length;
			}
			
			if (objects == 0)
			{
				return;
			}
			
			if (!direction)
			{
				direction = PackDirections.HORIZONTAL;
			}
			
			// ACTS
			
			var subject:ITrueSize;
			var firstSubject:ITrueSize = orderToUse[0];
			var prevSubject:ITrueSize = orderToUse[0];
			var distance:Number;
			var align:String = this.align;
			
			for (i = 1; i < objects; i++)
			{
				subject = orderToUse[i];
				distance = Number(distances[subject]);
				if (isNaN(distance))
				{
					distance = defaultDistance;
				}
				
				if (direction == PackDirections.HORIZONTAL)
				{
					subject.left = prevSubject.right + distance;
					if (align == null) align = 'yMiddle';
				}
				else if (direction == PackDirections.VERTICAL)
				{
					subject.top = prevSubject.bottom + distance;
					if (align == null) align = 'xMiddle';
				}
				else if (direction == PackDirections.CENTER)
				{
					if (align == null) align = 'middle';
				}
				subject[align] = firstSubject[align];
				
				prevSubject = subject;
			}
			
			// REARRANGING TOP LEFT TO ORIGO
			
			var innerSize:Rectangle = getRect(this);
			var topOffset:Number = innerSize.top;
			var leftOffset:Number = innerSize.left;
			
			for (i = 0; i < objects; i++)
			{
				subject = orderToUse[i];
				
				subject.top -= topOffset;
				subject.left -= leftOffset;
			}
		}
	}
}