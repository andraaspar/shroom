package com.pirkadat.logic 
{
	import com.pirkadat.logic.WorldForce;
	public class AirWalkForce extends WorldForce
	{
		public function AirWalkForce() 
		{
			
		}
		
		override public function applyTo(subject:WorldObject, timeDelta:Number, currentTime:Number):Boolean 
		{
			if (subject.velocity.x * subject.facing < 0
				|| Math.abs(subject.velocity.x) < subject.walkingSpeed)
			{
				subject.velocity.x += subject.walkingSpeed * 2 * subject.facing * timeDelta;
			}
			
			return true;
		}
		
		override public function clone(c:WorldForce = null):WorldForce 
		{
			return new AirWalkForce();
		}
	}

}