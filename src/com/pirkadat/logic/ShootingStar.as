package com.pirkadat.logic 
{
	import com.pirkadat.ui.ShotAppearance;
	import com.pirkadat.ui.WorldAppearance;
	import com.pirkadat.ui.WorldObjectAppearance;
	import flash.geom.Point;
	public class ShootingStar extends Shot
	{
		public function ShootingStar(world:World = null, team:Team = null, owner:WorldObject = null) 
		{
			super(world, team, owner);
			
			name = "Shooting Star";
			punchHoleRadius = 100;
			pushDamageStrength = 100;
			
			hitSoundAssetID = 14;
			inWaterSoundAssetID = 12;
			explosionSoundAssetID = 10;
			
			calculateHitSets();
		}
		
		override public function getAssetIDs():Vector.<int> 
		{
			return new <int>[51, 50, hitSoundAssetID, explosionSoundAssetID, inWaterSoundAssetID, weaponAssetID];
		}
		
		override public function createAppearance(worldAppearance:WorldAppearance):WorldObjectAppearance 
		{
			return new ShotAppearance(51, 50, 1.5, this, worldAppearance);
		}
	}

}