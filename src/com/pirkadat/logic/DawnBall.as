package com.pirkadat.logic 
{
	import com.pirkadat.ui.*;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.*;
	import flash.geom.*;
	public class DawnBall extends Shot
	{
		public var damageCoords:Vector.<Point> = new Vector.<Point>();
		public var maxDamage:int = 25;
		public var effectRadius:Number = 4000;
		
		public function DawnBall(world:World = null, team:Team = null, owner:WorldObject = null, id:Number = NaN) 
		{
			super(world, team, owner);
			
			name = "Dawn Ball";
			
			punchHoleRadius = 25.5;
			
			hitSoundAssetID = 14;
			inWaterSoundAssetID = 12;
			explosionSoundAssetID = 20;
			weaponAssetID = 62;
			
			calculateHitSets();
		}
		
		override public function getAssetIDs():Vector.<int> 
		{
			return new <int>[55, 58, hitSoundAssetID, explosionSoundAssetID, inWaterSoundAssetID, weaponAssetID];
		}
		
		override public function createAppearance(worldAppearance:WorldAppearance):WorldObjectAppearance 
		{
			return new ShotAppearance(55, 58, 2, this, worldAppearance);;
		}
		
		override public function explode():void 
		{
			punchAHole(location, 0, punchHoleRadius);
			
			if (!isGhost && explosionSoundAssetID) Program.mbToUI.newSounds.push(new SoundRequest(explosionSoundAssetID, null, location));
			
			var objCoords:Point;
			var dist:Number;
			var testPath:Shape = new Shape();
			var testPathBMD:BitmapData;
			var hit:Boolean;
			for each (var object:WorldObject in world.objects)
			{
				if (object is DawnBall
					|| object.hasFinishedWorking)
					continue;
				objCoords = object.location.subtract(location);
				dist = objCoords.length;
				if (isGhost
					&& object.team != this.team)
				{
					closestEnemyDistance = Math.min(closestEnemyDistance, dist);
				}
				if (dist > effectRadius) continue;
				
				testPath.graphics.lineStyle(1);
				testPath.graphics.moveTo(0, 0);
				testPath.graphics.lineTo(objCoords.x, objCoords.y);
				testPath.x = objCoords.x > 0 ? 0 : -objCoords.x;
				testPath.y = objCoords.y > 0 ? 0 : -objCoords.y;
				testPathBMD = new BitmapData(Math.max(1, testPath.width), Math.max(1, testPath.height), true, 0);
				testPathBMD.draw(testPath, testPath.transform.matrix);
				hit = !world.terrain.hitTest(terrainPoint, 128, testPathBMD, location.add(new Point(-testPath.x, -testPath.y)), 128);
				testPath.graphics.clear();
				testPathBMD.dispose();
				if (!hit) continue;
				
				if (object.team == this.team)
				{
					friendlyDamage += maxDamage;
					if (owner) owner.friendlyDamage += maxDamage;
				}
				else
				{
					enemyDamage += maxDamage;
					if (owner) owner.enemyDamage += maxDamage;
				}
				if (!isGhost || object.isGhost)
				{
					object.damage(maxDamage);
					var pushPt:Point = objCoords.clone();
					pushPt.normalize(300);
					object.velocity = object.velocity.add(pushPt);
					object.wake();
				}
				if (!isGhost) damageCoords.push(objCoords);
			}
		}
	}

}