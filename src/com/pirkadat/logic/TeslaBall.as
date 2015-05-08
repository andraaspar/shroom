package com.pirkadat.logic 
{
	import com.pirkadat.logic.WorldObject;
	import com.pirkadat.ui.ShotAppearance;
	import com.pirkadat.ui.WorldAppearance;
	import com.pirkadat.ui.WorldObjectAppearance;
	import flash.geom.Point;
	public class TeslaBall extends Shot
	{
		public var effectRadius:Number = 150;
		public var maxDamage:Number = 6;
		public var damageCoords:Vector.<Point>;
		public var nextDamageTime:Number = 0;
		
		public var zapSoundAssetID:int = 18;
		public var zapSoundRequest:SoundRequest;
		public var myAppearance:ShotAppearance;
		
		public function TeslaBall(world:World = null, team:Team = null, owner:WorldObject = null) 
		{
			super(world, team, owner);
			
			name = "Tesla Ball";
			
			punchHoleRadius = 25.5;
			
			hitSoundAssetID = 14;
			inWaterSoundAssetID = 12;
			explosionSoundAssetID = 19;
			weaponAssetID = 61;
			
			calculateHitSets();
		}
		
		override public function notify(currentTime:Number):void 
		{
			super.notify(currentTime);
			
			if (hasFinishedWorking
				|| nextDamageTime > currentTime)
				return;
			
			nextDamageTime = currentTime + .04;
			
			if (!isGhost) damageCoords = new Vector.<Point>();
			
			var objCoords:Point;
			var dist:Number;
			var distRatio:Number;
			var damage:int;
			for each (var object:WorldObject in world.objects)
			{
				if (object == owner
					|| object is TeslaBall
					|| object.hasFinishedWorking)
					continue;
				objCoords = object.location.subtract(location);
				dist = objCoords.length - radius - object.radius - 1;
				if (isGhost
					&& object.team != this.team)
				{
					closestEnemyDistance = Math.min(closestEnemyDistance, dist);
				}
				distRatio = (effectRadius - dist) / effectRadius;
				if (distRatio <= 0) continue;
				if (distRatio > 1) distRatio = 1;
				damage = Math.min(Math.ceil(maxDamage * distRatio), object.health);
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
					if (!isGhost) damageCoords.push(objCoords);
				}
			}
			
			if (!isGhost
				&& (!zapSoundRequest
					|| zapSoundRequest.playbackIsOver)
						&& damageCoords.length)
			{
				zapSoundRequest = new SoundRequest(zapSoundAssetID, myAppearance, location.clone());
				Program.mbToUI.newSounds.push(zapSoundRequest);
			}
		}
		
		override public function getAssetIDs():Vector.<int> 
		{
			return new <int>[56, 57, hitSoundAssetID, explosionSoundAssetID, inWaterSoundAssetID, zapSoundAssetID, weaponAssetID];
		}
		
		override public function createAppearance(worldAppearance:WorldAppearance):WorldObjectAppearance 
		{
			myAppearance = new ShotAppearance(56, 57, 1, this, worldAppearance);
			return myAppearance;
		}
		
		override public function explode():void 
		{
			punchAHole(location, 0, punchHoleRadius);
			
			if (!isGhost && explosionSoundAssetID) Program.mbToUI.newSounds.push(new SoundRequest(explosionSoundAssetID, null, location));
		}
	}

}