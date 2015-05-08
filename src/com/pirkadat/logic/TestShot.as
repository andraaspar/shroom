package com.pirkadat.logic 
{
	import com.pirkadat.ui.Console;
	import com.pirkadat.ui.DynamicText;
	import flash.display.Graphics;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	public class TestShot
	{
		public var aim:Number;
		public var facing:int;
		public var powerMultiplier:Number;
		public var world:World;
		public var member:TeamMember;
		public var bullet:Class;
		public var bounceCount:int;
		public var friendlyDamage:int;
		public var enemyDamage:int;
		public var damageRatio:Number;
		public var closestEnemyDistance:Number = Infinity;
		public static var count:int;
		public var id:int;
		public var steps:int;
		
		public function TestShot(aim:Number, facing:int, powerMultiplier:Number, world:World, member:TeamMember, bullet:Class, bounceCount:int) 
		{
			this.aim = aim;
			this.facing = facing;
			this.powerMultiplier = powerMultiplier;
			this.world = world;
			this.member = member;
			this.bullet = bullet;
			this.bounceCount = bounceCount;
			
			id = count++;
			
			calculate();
		}
		
		public function calculate():void
		{
			member.isGhost = true;
			
			member.aim = aim;
			member.facing = facing;
			member.powerMultiplier = powerMultiplier;
			member.bounceCount = bounceCount;
			
			var shot:Shot = member.fire();
			
			member.isGhost = false;
			
			steps = 0;
			
			while (true)
			{
				shot.notify(shot.timeToNotify);
				if (shot.hasFinishedWorking)
				{
					friendlyDamage = shot.friendlyDamage;
					enemyDamage = shot.enemyDamage;
					closestEnemyDistance = shot.closestEnemyDistance;
					
					break;
				}
				
				steps++;
			}
			
			if (friendlyDamage == 0 && enemyDamage == 0) damageRatio = 0;
			else damageRatio = enemyDamage / friendlyDamage;
		}
		
		public function toString():String
		{
			return "[TestShot: id:"+id+" bounceCount:"+bounceCount+" aim:"+Math.round(aim / Math.PI * 180)+"° facing:"+facing+" powerMultiplier:"+powerMultiplier+" friendlyDamage:"+friendlyDamage+" enemyDamage:"+enemyDamage+" damageRatio:"+damageRatio+"]";
		}
	}

}