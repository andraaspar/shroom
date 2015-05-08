package com.pirkadat.ui 
{
	import com.pirkadat.display.*;
	import com.pirkadat.geom.MultiplierColorTransform;
	import com.pirkadat.logic.*;
	import com.pirkadat.shapes.*;
	import com.pirkadat.trans.*;
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	
	public class SimpleTeamMemberAppearance extends WorldObjectAppearance
	{
		public var teamMember:TeamMember;
		
		public var animationRanges:Dictionary;
		public var animation:BitmapAnimation;
		public var highlight:TeamMemberHighight;
		public var healthMeter:HealthMeter;
		public var circle:TrueSizeShape;
		public var weapon:TrueSize;
		public var weaponBMA:BitmapAnimation;
		public var weaponRanges:Dictionary;
		
		public var isWalking:Boolean;
		public var hasBeenFlying:Boolean;
		public var hasBeenSelected:Boolean = true;
		
		public var state:int;
		
		public function SimpleTeamMemberAppearance(teamMember:TeamMember = null) 
		{
			super(teamMember, null);
			
			this.teamMember = teamMember;
			
			build();
		}
		
		protected function build():void
		{
			highlight = new TeamMemberHighight(0xffffff, teamMember.radius * 2);
			addChild(highlight);
			highlight.visible = false;
			
			circle = new TrueSizeShape();
			addChild(circle);
			circle.graphics.lineStyle(1, 0xffffff, .2, false);
			circle.graphics.drawCircle(0, 0, teamMember.radius * 2);
			
			healthMeter = new HealthMeter(teamMember.team.characterAppearance.color ? teamMember.team.characterAppearance.color : 0xffffff, teamMember.radius * 2, 3);
			addChild(healthMeter);
			
			animation = new BitmapAnimation();
			animation.addLayer(Program.assetLoader.getAssetByID(teamMember.colourAssetID), new MultiplierColorTransform(teamMember.team.characterAppearance.color));
			animation.addLayer(Program.assetLoader.getAssetByID(teamMember.aniAssetID));
			addChild(animation);
			animation.xMiddle = animation.yMiddle = 0;
			sizeMask = animation;
			
			weapon = new TrueSize();
			addChild(weapon);
			
			animationRanges = Program.assetLoader.getAssetAnimationRangesByID(teamMember.aniAssetID);
			
		}
		
		override public function update():void 
		{
			// State
			
			if (Program.mbToUI.newState)
			{
				state = Program.mbToUI.newState;
			}
			
			// Selection
			
			if (highlight.visible != teamMember.isSelected)
			{
				highlight.visible = teamMember.isSelected;
			}
			if (highlight.visible) highlight.update();
			
			// Weapon
			
			if (Program.mbToUI.newBulletSelected)
			{
				if (weaponBMA) weapon.removeChild(weaponBMA);
				
				weaponBMA = new BitmapAnimation();
				var weaponID:int = Shot(new TeamMember.bullet()).weaponAssetID;
				weaponBMA.addLayer(Program.assetLoader.getAssetByID(weaponID));
				weapon.addChild(weaponBMA);
				weaponBMA.yMiddle = 0;
				weaponBMA.left = 0;
				weaponRanges = Program.assetLoader.getAssetAnimationRangesByID(weaponID);
				weaponBMA.playRange(weaponRanges["held"], true);
			}
			
			// Facing
			
			animation.scaleX = weapon.scaleX = teamMember.facing;
			
			// Animation
			
			if (Program.mbToUI.winner == worldObject.team)
			{
				animation.playRange(animationRanges["cheer"], true);
				weapon.visible = false;
			}
			else if (hasBeenFlying != teamMember.hasBeenFlying
				|| isWalking != teamMember.isWalking
				|| hasBeenSelected != teamMember.hasBeenSelected
				|| Program.mbToUI.newState)
			{
				hasBeenFlying = teamMember.hasBeenFlying;
				isWalking = teamMember.isWalking;
				hasBeenSelected = teamMember.hasBeenSelected;
				
				if (hasBeenFlying)
				{
					animation.playRange(animationRanges["fly"], true);
					weapon.visible = false;
				}
				else if (isWalking)
				{
					animation.playRange(animationRanges["walk"], true);
					weapon.visible = false;
				}
				else if (!hasBeenSelected)
				{
					animation.playRange(AnimationRange(animationRanges["wave"]).randomizeStartOffset(), true);
					weapon.visible = false;
				}
				else
				{
					switch (state)
					{
						case MBToUI.STATE_AIM:
						case MBToUI.STATE_SHOOT:
						case MBToUI.STATE_FOCUS:
							animation.playRange(animationRanges["aim"], true);
							weapon.visible = true;
						break;
						default:
							animation.playRange(animationRanges["stand"], true);
							weapon.visible = false;
					}
				}
			}
			if (hasBeenFlying) animation.framesPerFrame = 1;
			else if (isWalking) animation.framesPerFrame = teamMember.walkingSpeed / teamMember.maxWalkingSpeed;
			else animation.framesPerFrame = 1;
			
			if (!teamMember.isSelected && hasBeenFlying) animation.rotation += teamMember.velocity.x / 5;
			else animation.rotation = 0;
			
			// Health
			
			if (healthMeter.healthDisplayed != teamMember.health)
			{
				healthMeter.update(teamMember.health);
			}
			
			// Input
			
			weapon.rotation = teamMember.aim * teamMember.facing / Math.PI * 180;
		}
	}

}