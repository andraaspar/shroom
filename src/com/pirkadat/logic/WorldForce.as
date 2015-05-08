package com.pirkadat.logic 
{
	
	public class WorldForce
	{
		public function WorldForce() 
		{
			
		}
		
		public function applyTo(subject:WorldObject, timeDelta:Number, currentTime:Number):Boolean
		{
			// To be overridden.
			
			return true;
		}
		
		public function clone(c:WorldForce = null):WorldForce
		{
			return new WorldForce();
		}
	}

}