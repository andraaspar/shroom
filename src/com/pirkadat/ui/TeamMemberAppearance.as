package com.pirkadat.ui 
{
	import com.pirkadat.display.*;
	import com.pirkadat.geom.*;
	import com.pirkadat.logic.*;
	import com.pirkadat.shapes.*;
	import com.pirkadat.trans.*;
	import com.pirkadat.ui.*;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	
	public class TeamMemberAppearance extends WorldObjectAppearance
	{
		public var teamMember:TeamMember;
		
		public var animationRanges:Dictionary;
		public var animation:BitmapAnimation;
		
		public var highlight:TeamMemberHighight;
		public var healthMeter:HealthMeter;
		public var staminaMeter:StaminaMeter;
		public var circle:TrueSizeShape;
		public var weapon:TrueSize;
		public var weaponBMA:BitmapAnimation;
		public var weaponRanges:Dictionary;
		
		public var crossHair:CrossHair;
		public var mayShowCrossHair:Boolean;
		
		public var walkDrag:WalkDrag;
		public var mayWalk:Boolean;
		
		public var isWalking:Boolean;
		public var hasBeenFlying:Boolean;
		public var hasBeenSelected:Boolean = true;
		
		public var oddUpdate:Boolean;
		public var firstUpdate:Boolean = true;
		
		public var state:int;
		
		public var shunpoOptions:TrueSize;
		public var shunpoFrom:Point;
		public var shunpoTo:Point;
		
		public var lastDamage:Number;
		public var lastDamageX:Number;
		public var lastDamageY:Number;
		public var lastDamageField:DynamicText;
		
		public function TeamMemberAppearance(teamMember:TeamMember = null, worldAppearance:WorldAppearance = null) 
		{
			super(teamMember, worldAppearance);
			
			this.teamMember = teamMember;
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		protected function onAddedToStage(e:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			highlight = new TeamMemberHighight(0xffffff, teamMember.radius * 2);
			addChild(highlight);
			highlight.visible = false;
			
			circle = new TrueSizeShape();
			addChild(circle);
			circle.graphics.lineStyle(1, 0xffffff, .2, false);
			circle.graphics.drawCircle(0, 0, teamMember.radius * 2);
			
			staminaMeter = new StaminaMeter(teamMember.radius * 2, teamMember.staminaBurnPerJump / teamMember.staminaBurnPerPixel);
			addChild(staminaMeter);
			staminaMeter.visible = false;
			
			healthMeter = new HealthMeter(teamMember.team.characterAppearance.color ? teamMember.team.characterAppearance.color : 0xffffff, teamMember.radius * 2, 3);
			addChild(healthMeter);
			
			animation = new BitmapAnimation();
			animation.addLayer(Program.assetLoader.getAssetByID(teamMember.colourAssetID), new MultiplierColorTransform(teamMember.team.characterAppearance.color));
			animation.addLayer(Program.assetLoader.getAssetByID(teamMember.aniAssetID));
			addChild(animation);
			animation.xMiddle = animation.yMiddle = 0;
			
			weapon = new TrueSize();
			addChild(weapon);
			
			walkDrag = new WalkDrag(teamMember);
			addChild(walkDrag);
			
			crossHair = new CrossHair(teamMember.radius * 2);
			addChild(crossHair);
			crossHair.visible = false;
			
			animationRanges = Program.assetLoader.getAssetAnimationRangesByID(teamMember.aniAssetID);
			
			moveAndDraw(worldObject.wayPoints, 3, .5, true);
		}
		
		override public function update():void 
		{
			if (teamMember.hasFinishedWorking)
			{
				walkDrag.disableDragging();
			}
			
			// State
			
			if (Program.mbToUI.newState)
			{
				state = Program.mbToUI.newState;
				
				switch (state)
				{
					case MBToUI.STATE_MOVE:
						mayShowCrossHair = false;
						if (teamMember.team.isSelected
							&& Program.game.currentRound.selectedTeam.controller == Team.CONTROLLER_HUMAN)
							walkDrag.enableDragging();
						else walkDrag.disableDragging();
					break;
					case MBToUI.STATE_AIM:
						mayShowCrossHair = true;
						crossHair.visible = teamMember.isSelected;
						walkDrag.disableDragging();
					break;
					case MBToUI.STATE_SHUNPO:
						mayShowCrossHair = false;
						walkDrag.disableDragging();
					break;
					case MBToUI.STATE_SHOOT:
						if (teamMember.powerMultiplier) weaponBMA.playRange(weaponRanges["shoot"], false);
					case MBToUI.STATE_FOCUS:
						mayShowCrossHair = false;
						walkDrag.disableDragging();
					break;
					default:
						mayShowCrossHair = false;
						walkDrag.disableDragging();
				}
			}
			
			// Selection
			
			if (highlight.visible != teamMember.isSelected)
			{
				highlight.visible = teamMember.isSelected;
				staminaMeter.visible = highlight.visible && state == MBToUI.STATE_MOVE;
				if (highlight.visible)
				{
					parent.addChild(this);
				}
				else
				{
					if (shunpoOptions)
					{
						removeChild(shunpoOptions);
						shunpoOptions = null;
					}
				}
			}
			if (highlight.visible) highlight.update();
			
			crossHair.visible = mayShowCrossHair && teamMember.isSelected;
			
			// Set location and draw path lines on canvas
			
			if (teamMember.location.x != x
				|| teamMember.location.y != y)
			{
				if (Program.mbToUI.newShunpoOptions
					|| (!highlight.visible
					&& !oddUpdate))
				{
					moveAndDraw(worldObject.wayPoints, 3, .5);
				}
				else
				{
					x = teamMember.location.x;
					y = teamMember.location.y;
				}
				oddUpdate = !oddUpdate;
			}
			
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
				// Draw damage marks on canvas
				
				if (!firstUpdate)
				{
					if (lastDamageField && worldAppearance.canvas.contains(lastDamageField) && lastDamageX == x && lastDamageY == y)
					{
						lastDamage += teamMember.health - healthMeter.healthDisplayed;
					}
					else
					{
						lastDamageX = x;
						lastDamageY = y;
						lastDamage = teamMember.health - healthMeter.healthDisplayed;
						
						lastDamageField = new DynamicText();
						worldAppearance.canvas.addChild(lastDamageField);
						lastDamageField.alpha = .5;
						
						worldAppearance.canvas.graphics.lineStyle(3, teamMember.team.characterAppearance.color, .25);
						worldAppearance.canvas.graphics.drawCircle(x, y, 6);
					}
					
					lastDamageField.text = String(lastDamage);
					lastDamageField.xMiddle = x;
					lastDamageField.bottom = y - teamMember.radius - 5;
				}
				
				healthMeter.update(teamMember.health);
			}
			
			// Shunpo
			
			if (highlight.visible && Program.mbToUI.newShunpoOptions)
			{
				if (shunpoOptions)
				{
					removeChild(shunpoOptions);
				}
				
				shunpoOptions = new TrueSize();
				addChild(shunpoOptions);
				
				if (Program.mbToUI.newShunpoOptions.length) drawShunpoCross();
				
				for each (var option:Point in Program.mbToUI.newShunpoOptions)
				{
					var optButt:Sprite = new Sprite();
					shunpoOptions.addChild(optButt);
					optButt.graphics.beginFill(0xffffff, .25);
					optButt.graphics.lineStyle(4, 0xffffff);
					optButt.graphics.drawCircle(0, 0, teamMember.radius - 2);
					optButt.x = option.x;
					optButt.y = option.y;
					optButt.addEventListener(MouseEvent.CLICK, onShunpoOptionClicked);
				}
			}
			
			// Input
			
			if (walkDrag.isDragged)
			{
				walkDrag.doDrag();
			}
			
			if (crossHair.isDragged)
			{
				crossHair.crossDrag();
			}
			else
			{
				crossHair.setAngleAndPower(teamMember.aim, teamMember.facing, teamMember.powerMultiplier);
			}
			weapon.rotation = teamMember.aim * teamMember.facing / Math.PI * 180;
			
			
			if (staminaMeter.visible) staminaMeter.setStamina(teamMember.stamina / teamMember.staminaBurnPerPixel);
			
			//
			
			firstUpdate = false;
		}
		
		override public function generateVisualObjects():Vector.<VisualObject> 
		{
			if (worldObject.hasFinishedWorking)
			{
				if (worldObject.location.y > worldAppearance.terrainAppearance.height)
				{
					var sinker:Sinker = new Sinker(teamMember.aniAssetID, teamMember.colourAssetID, teamMember.team.characterAppearance.color, worldAppearance);
					sinker.x = x;
					sinker.y = worldAppearance.terrainAppearance.height + worldObject.radius;
					
					return new <VisualObject>[sinker];
				}
				else
				{
					var ghost:Ghost = new Ghost(teamMember.aniAssetID, teamMember.colourAssetID, teamMember.team.characterAppearance.color, worldAppearance);
					ghost.x = x;
					ghost.y = y;
					
					return new <VisualObject>[ghost];
				}
			}
			else
			{
				if (shunpoFrom)
				{
					var popFrom:Explosion = new Explosion(Program.game.shunpoPopVisualAssetID, worldAppearance);
					popFrom.location = shunpoFrom;
					shunpoFrom = null;
					
					var popTo:Explosion = new Explosion(Program.game.shunpoPopVisualAssetID, worldAppearance);
					popTo.location = shunpoTo;
					shunpoTo = null;
					
					return new <VisualObject>[popFrom, popTo];
				}
				return null;
			}
		}
		
		protected function onShunpoOptionClicked(e:MouseEvent):void
		{
			shunpoFrom = location.clone();
			Program.mbToP.shunpoRequested = new Point(Sprite(e.target).x, Sprite(e.target).y);
			shunpoTo = location.add(Program.mbToP.shunpoRequested);
		}
		
		protected function drawShunpoCross():void
		{
			var tr2:Number = teamMember.radius * 2;
			var leftWall:Number = x + teamMember.radius;
			var topWall:Number = y + teamMember.radius;
			var rightWall:Number = worldAppearance.terrainAppearance.width + teamMember.radius - x;
			var bottomWall:Number = worldAppearance.terrainAppearance.height + teamMember.radius - y;
			
			shunpoOptions.graphics.lineStyle(tr2, 0, .25, false, LineScaleMode.NORMAL, CapsStyle.ROUND);
			var coord:Number = Math.min(leftWall, topWall);
			if (coord > 0)
			{
				shunpoOptions.graphics.moveTo(-tr2, -tr2);
				shunpoOptions.graphics.lineTo(-coord, -coord);
			}
			coord = Math.min(rightWall, bottomWall);
			if (coord > 0)
			{
				shunpoOptions.graphics.moveTo(tr2, tr2);
				shunpoOptions.graphics.lineTo(coord, coord);
			}
			coord = Math.min(rightWall, topWall);
			if (coord > 0)
			{
				shunpoOptions.graphics.moveTo(tr2, -tr2);
				shunpoOptions.graphics.lineTo(coord, -coord);
			}
			coord = Math.min(leftWall, bottomWall);
			if (coord > 0)
			{
				shunpoOptions.graphics.moveTo(-tr2, tr2);
				shunpoOptions.graphics.lineTo(-coord, coord);
			}
		}
	}

}