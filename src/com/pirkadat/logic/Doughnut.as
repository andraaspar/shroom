package com.pirkadat.logic 
{
	import com.pirkadat.ui.ShotAppearance;
	import com.pirkadat.ui.WorldAppearance;
	import com.pirkadat.ui.WorldObjectAppearance;
	import flash.geom.Point;
	public class Doughnut extends Shot
	{
		public var effectRadius:Number = 100;
		public var doughnutRadius:Number = 40;
		public var maxDamage:Number = 120;
		public var maxPush:Number = 300;
		
		public function Doughnut(world:World = null, team:Team = null, owner:WorldObject = null) 
		{
			super(world, team, owner);
			
			name = "Doughnut";
			
			punchHoleRadius = 25.5;
			
			hitSoundAssetID = 15;
			inWaterSoundAssetID = 12;
			explosionSoundAssetID = 17;
			weaponAssetID = 60;
			
			calculateHitSets();
		}
		
		override public function getAssetIDs():Vector.<int> 
		{
			return new <int>[53, 54, hitSoundAssetID, explosionSoundAssetID, inWaterSoundAssetID, weaponAssetID];
		}
		
		override public function createAppearance(worldAppearance:WorldAppearance):WorldObjectAppearance 
		{
			return new ShotAppearance(53, 54, 2, this, worldAppearance);
		}
		
		override public function explode():void 
		{
			doDoughnutDamageAndPush(effectRadius, doughnutRadius, maxDamage, maxPush);
			punchAHole(location, effectRadius - doughnutRadius, effectRadius + doughnutRadius);
			punchAHole(location, 0, punchHoleRadius);
			
			if (!isGhost && explosionSoundAssetID) Program.mbToUI.newSounds.push(new SoundRequest(explosionSoundAssetID, null, location));
		}
	}

}