package com.pirkadat.logic 
{
	import com.pirkadat.logic.*;
	import com.pirkadat.ui.*;
	import flash.geom.*;
	
	public class TeamMember extends WorldObject
	{
		public var maxWalkingSpeed:Number = 150;
		
		public var aim:Number = 0;
		public var power:Number = 800;
		public var powerMultiplier:Number = 0;
		public var poweringSpeed:Number = .5;
		public var bounceCount:int = 0;
		
		public var isAimingUp:Boolean;
		public var isAimingDown:Boolean;
		public var isPoweringUp:Boolean;
		public var isPoweringDown:Boolean;
		public var aimingSpeed:Number = HALF_PI;
		
		public var isSelected:Boolean;
		
		public var aniAssetID:int;
		public var colourAssetID:int;
		
		public var hasBeenSelected:Boolean = true;
		
		public static var bullet:Class = ShootingStar;
		
		public function TeamMember(world:World = null, team:Team = null, owner:WorldObject = null, id:Number = NaN) 
		{
			super(world, team, owner, id);
			
			name = "Team Member "+ this.id;
			
			health = 100;
			
			walkingSpeed = maxWalkingSpeed;
			
			calculateHitSets();
			
			aniAssetID = team.characterAppearance.animationAssetID;
			colourAssetID = team.characterAppearance.colorAssetID;
			inWaterSoundAssetID = team.characterAppearance.inWaterSoundAssetID;
			hitSoundAssetID = team.characterAppearance.hitSoundAssetID;
		}
		
		public function onSelected():void
		{
			isSelected = true;
			Program.mbToUI.memberSelectionChanged = true;
			Program.mbToUI.newSelectedMember = this;
			
			hasBeenSelected = true;
			
			//traceStatus("Selected!");
		}
		
		public function onDeselected():void
		{
			isSelected = false;
			Program.mbToUI.memberSelectionChanged = true;
			
			stopWalking();
			stopJumping();
			
			//traceStatus("Deselected!");
		}
		
		public function fire():Shot
		{
			if (health <= 0
				|| powerMultiplier <= 0)
			{
				bounceCount = 0;
				return null;
			}
			
			var shot:Shot = new bullet(world, team, this);
			
			if (isGhost) shot.isGhost = true;
			else world.addWorldObject(shot);
			
			var offset:Point = Point.polar(radius + shot.radius + 1, aim);
			offset.x *= facing;
			shot.location = location.add(offset);
			
			offset = Point.polar(power * powerMultiplier, aim);
			offset.x *= facing;
			
			shot.velocity = velocity.add(offset);
			shot.bounceCount = bounceCount;
			
			bounceCount = 0;
			
			return shot;
		}
		
		public function startAimingUp():void
		{
			isAimingUp = true;
			isAimingDown = false;
		}
		
		public function stopAimingUp():void
		{
			isAimingUp = false;
		}
		
		public function startAimingDown():void
		{
			isAimingDown = true;
			isAimingUp = false;
		}
		
		public function stopAimingDown():void
		{
			isAimingDown = false;
		}
		
		public function startPoweringUp():void
		{
			isPoweringUp = true;
		}
		
		public function stopPoweringUp():void
		{
			isPoweringUp = false;
		}
		
		public function startPoweringDown():void
		{
			isPoweringDown = true;
		}
		
		public function stopPoweringDown():void
		{
			isPoweringDown = false;
		}
		
		public function stopAll():void
		{
			isAimingUp = false;
			isAimingDown = false;
			isPoweringUp = false;
			isPoweringDown = false;
			
			stopWalking();
			stopJumping();
		}
		
		override public function notify(currentTime:Number):void 
		{
			super.notify(currentTime);
			
			if (isAimingUp)
			{
				aim -= aimingSpeed * timeDelta;
				if (aim < -HALF_PI)
				{
					aim = -HALF_PI;
				}
			}
			else if (isAimingDown)
			{
				aim += aimingSpeed * timeDelta;
				if (aim > HALF_PI)
				{
					aim = HALF_PI;
				}
			}
			
			if (isPoweringUp)
			{
				powerMultiplier += poweringSpeed * timeDelta;
				if (powerMultiplier > 1) powerMultiplier = 1;
			}
			else if (isPoweringDown)
			{
				powerMultiplier -= poweringSpeed * timeDelta;
				if (powerMultiplier < 0) powerMultiplier = 0;
			}
		}
		
		override public function canHit(object:WorldObject):Boolean 
		{
			if (!super.canHit(object)) return false;
			if (object is TeamMember) return false;
			
			return true;
		}
		
		public function setSpeedMultiplier(value:Number):void
		{
			walkingSpeed = maxWalkingSpeed / 25 * value;
			if (walkingSpeed <= 0) walkingSpeed = 1;
			walkingSpeed *= 25;
			//traceStatus("Walkingspeed set to:",walkingSpeed,maxWalkingSpeed,value);
		}
		
		override public function clone(c:WorldObject = null):WorldObject 
		{
			if (!c) c = new TeamMember(world, team);
			var cc:TeamMember = TeamMember(super.clone(c));
			cc.maxWalkingSpeed = maxWalkingSpeed;
			cc.aim = aim;
			cc.power = power;
			cc.powerMultiplier = powerMultiplier;
			cc.poweringSpeed = poweringSpeed;
			cc.bounceCount = bounceCount;
			cc.isAimingUp = isAimingUp;
			cc.isAimingDown = isAimingDown;
			cc.isPoweringUp = isPoweringUp;
			cc.isPoweringDown = isPoweringDown;
			cc.aimingSpeed = aimingSpeed;
			cc.isSelected = isSelected;
			cc.aniAssetID = aniAssetID;
			cc.colourAssetID = colourAssetID;
			cc.hasBeenSelected = hasBeenSelected;
			return cc;
		}
		
		override public function getAssetIDs():Vector.<int> 
		{
			return new <int>[aniAssetID, colourAssetID, inWaterSoundAssetID, hitSoundAssetID];
		}
		
		override public function createAppearance(worldAppearance:WorldAppearance):WorldObjectAppearance 
		{
			return new TeamMemberAppearance(this, worldAppearance);
		}
		
		override public function traceStatus(...rest):void 
		{
			if (isSelected) super.traceStatus(rest);
		}
	}

}