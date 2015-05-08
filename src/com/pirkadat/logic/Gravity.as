package com.pirkadat.logic 
{
	import com.pirkadat.logic.WorldForce;
	import com.pirkadat.logic.WorldObject;
	import flash.geom.Point;
	
	public class Gravity extends WorldForce
	{
		public static const EFFECT_NORMAL:Number = 400;
		
		public static var effect:Number = 400;
		
		public function Gravity() 
		{
			
		}
		
		override public function applyTo(subject:WorldObject, timeDelta:Number, currentTime:Number):Boolean 
		{
			subject.velocity.y += effect * timeDelta;
			return true;
		}
		
		override public function clone(c:WorldForce = null):WorldForce 
		{
			return new Gravity();
		}
	}

}