package com.pirkadat.logic 
{
	import com.pirkadat.logic.*;
	import flash.display.*;
	import flash.geom.Point;

	public class Shot extends WorldObject
	{
		public var pushDamageStrength:Number = 100;
		public var punchHoleRadius:Number = 100;
		
		public var bounceCount:int = 0;
		
		public var explosionSoundAssetID:int;
		public var weaponAssetID:int = 59;
		
		public function Shot(world:World = null, team:Team = null, owner:WorldObject = null, id:Number = NaN) 
		{
			super(world, team, owner, id);
			
			mass = .46;
			bounciness = .6;
			minVelocityForFlying = 0;
			health = 1;
			radius = 10.5;
		}
		
		override protected function onDeath():void 
		{
			if (location.y < world.terrain.height) explode();
		}
		
		override protected function onLanded():void 
		{
			damage(health);
		}
		
		override protected function onCollidedWithObject(object:WorldObject, angle:Number, speed:Number):void 
		{
			if (--bounceCount < 0) damage(health);
			
			wayPoints.push(location.clone());
		}
		
		override protected function onCollidedWithTerrain(angle:Number, speed:Number):void 
		{
			if (--bounceCount < 0) damage(health);
			
			wayPoints.push(location.clone());
			
			if (!isGhost && hitSoundAssetID) Program.mbToUI.newSounds.push(new SoundRequest(hitSoundAssetID, null, location, 0, Math.min(1, speed / damageResistance)));
		}
		
		public function explode():void
		{
			punchAHole(location, 0, punchHoleRadius);
			pushAndDamageObjects(location, pushDamageStrength);
			
			if (!isGhost && explosionSoundAssetID) Program.mbToUI.newSounds.push(new SoundRequest(explosionSoundAssetID, null, location));
		}
		
		public function pushAndDamageObjects(center:Point, effectRadius:Number):void
		{
			var distPt:Point;
			var dist:Number;
			var distRatio:Number;
			var damage:Number;
			
			for each (var object:WorldObject in world.objects)
			{
				if (object.hasFinishedWorking) continue;
				
				distPt = object.location.subtract(center);
				dist = distPt.length - object.radius - radius - 1; // -1 adjusts for direct impact, which could never be 0 dist
				if (isGhost
					&& object.team != this.team)
				{
					closestEnemyDistance = Math.min(closestEnemyDistance, dist);
				}
				
				distRatio = (effectRadius - dist) / effectRadius; // Between 0 and 1
				if (distRatio < 0) distRatio = 0;
				if (distRatio > 1) distRatio = 1;
				
				if (!isGhost || object.isGhost)
				{
					object.velocity.offset(distPt.x * distRatio * (effectRadius / 10), distPt.y * distRatio * (effectRadius / 10));
				}
				
				damage = effectRadius * distRatio;
				damage = Math.min(object.health, damage);
				if (damage > 0)
				{
					if (object.team == this.team)
					{
						friendlyDamage += damage;
						if (owner) owner.friendlyDamage += damage;
					}
					else
					{
						enemyDamage += damage;
						if (owner) owner.enemyDamage += damage;
					}
					if (!isGhost || object.isGhost) object.damage(damage);
				}
			}
		}
		
		public function punchAHole(location:Point, minRadius:Number, maxRadius:Number):void
		{
			if (isGhost) return;
			
			var ref:String = minRadius + ":" + maxRadius;
			var hitMap:BitmapData;
			if (hitMaps[ref] == undefined)
			{
				hitMap = drawHitMapDoughnut(minRadius, maxRadius);
				hitMaps[ref] = hitMap;
			}
			else
			{
				hitMap = hitMaps[ref];
			}
			
			mergeWithAlphaChannel(hitMap, location.add(new Point(-maxRadius, -maxRadius)));
		}
		
		public function doDoughnutDamageAndPush(effectRadius:Number = 100, doughnutRadius:Number = 40, maxDamage:Number = 100, maxPush:Number = 300):void
		{
			var distPt:Point;
			var dist:Number;
			var distRatio:Number;
			var damage:Number;
			
			for each (var object:WorldObject in world.objects)
			{
				if (object.hasFinishedWorking) continue;
				
				distPt = object.location.subtract(location);
				dist = distPt.length - effectRadius;
				if (isGhost
					&& object.team != this.team)
				{
					closestEnemyDistance = Math.min(closestEnemyDistance, dist);
				}
				
				distRatio = (doughnutRadius - Math.abs(dist)) / doughnutRadius; // Between 0 and 1
				if (distRatio < 0) distRatio = 0;
				if (distRatio > 1) distRatio = 1;
				
				if (!isGhost || object.isGhost)
				{
					if (dist > 0) distPt.normalize(1);
					else distPt.normalize(-1);
					object.velocity.offset(distPt.x * maxPush * distRatio, distPt.y * maxPush * distRatio);
				}
				
				damage = maxDamage * distRatio;
				damage = Math.min(object.health, damage);
				if (damage > 0)
				{
					if (object.team == this.team)
					{
						friendlyDamage += damage;
						if (owner) owner.friendlyDamage += damage;
					}
					else
					{
						enemyDamage += damage;
						if (owner) owner.enemyDamage += damage;
					}
					if (!isGhost || object.isGhost) object.damage(damage);
				}
			}
		}
	}

}