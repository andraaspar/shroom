package com.pirkadat.logic 
{
	import com.pirkadat.display.*;
	import com.pirkadat.shapes.*;
	import com.pirkadat.ui.*;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	
	public class WorldObject
	{
		public const PI:Number = 3.141592653589793;
		public const HALF_PI:Number = 1.570796326794897;
		public const DOUBLE_PI:Number = 6.283185307179586;
		
		// PHYSICAL ATTRIBUTES
		
		public var radius:Number = 15.5;
		
		public var location:Point = new Point();
		public var wayPoints:Vector.<Point> = new Vector.<Point>();
		public var wayPointsClearedTime:Number;
		
		public var velocity:Point = new Point();
		
		public var mass:Number = 1;
		public var bounciness:Number = .2;
		public var minVelocityForFlying:Number = 75;
		public var damageResistance:Number = 500;
		
		// PHYSICS ENGINE
		
		public static var terrainPoint:Point = new Point();
		
		public static var hitMapSets:Dictionary = new Dictionary();
		public var hitMapSet:Vector.<BitmapData>;
		
		public static var hitMaps:Dictionary = new Dictionary();
		public var hitMap:BitmapData;
		
		public static var hitAngleSets:Dictionary = new Dictionary();
		public var hitAngleSet:Vector.<Point>;
		
		public var lastHitWallAngle:Point;
		
		public var lastTimeNotified:Number = NaN;
		public var timeDelta:Number = NaN;
		public var timeToNotify:Number = 0;
		
		public var stepsPerSecond:Number = 0;
		
		public var hasBeenFlying:Boolean = true;
		
		public var forces:Vector.<WorldForce> = new Vector.<WorldForce>();
		
		public var activeAirWalkForce:AirWalkForce;
		
		public var isJumping:Boolean;
		public var jumpStrengthY:Number = 300;
		public var jumpCoolOff:Number = 1;
		public var lastJumpTime:Number = -Infinity;
		
		public var walkingSpeed:Number = 150;
		public var runningSpeedLimit:Number = 75;
		public var walkability:Number = 5;
		public var facing:int = 1;
		public var isWalking:Boolean;
		
		public var stamina:Number = 1;
		public var staminaBurnPerPixel:Number = .002;
		public var staminaBurnPerJump:Number = .25;
		
		public var hasBeenNotified:Boolean;
		public var hasFinishedWorking:Boolean;
		
		// MISC
		
		public var world:World;
		
		public var name:String;
		
		public var health:int;
		
		public var moveCount:int;
		
		public var isGhost:Boolean;
		public var enemyDamage:int;
		public var friendlyDamage:int;
		public var closestEnemyDistance:Number = Infinity;
		
		public var team:Team;
		public var owner:WorldObject;
		
		public static var idCounter:Number = 0;
		public var id:Number;
		
		public var inWaterSoundAssetID:int;
		public var hitSoundAssetID:int;
		
		
		
		
		
		
		
		
		public function WorldObject(world:World = null, team:Team = null, owner:WorldObject = null, id:Number = NaN) 
		{
			if (isNaN(id)) this.id = idCounter++;
			this.world = world;
			this.team = team;
			this.owner = owner;
		}
		
		
		
		
		
		
		
		
		
		
		
		public function notify(currentTime:Number):void
		{
			if (hasFinishedWorking) return;
			
			if (!hasBeenNotified)
			{
				wayPoints.push(location.clone());
				wayPointsClearedTime = currentTime;
				hasBeenNotified = true;
				//Console.say("Notified first:",currentTime);
			}
			else if (wayPointsClearedTime + .04 < currentTime)
			{
				wayPoints = new <Point>[];
				wayPointsClearedTime = currentTime;
				//Console.say("Waypoints cleared:",currentTime);
			}
			//else Console.say("Notified:",currentTime);
			
			if (isNaN(lastTimeNotified))
			{
				lastTimeNotified = currentTime;
				return;
			}
			
			timeDelta = currentTime - lastTimeNotified;
			lastTimeNotified = currentTime;
			//traceStatus("Notified.");
			
			if (isWalking
				&& stamina <= 0)
				stopWalking();
			
			moveCount = 0;
			while (move())
			{
				moveCount++;
			}
			
			if (location.y > world.terrain.height)
			{
				damage(health);
				
				if (!isGhost && inWaterSoundAssetID) Program.mbToUI.newSounds.push(new SoundRequest(inWaterSoundAssetID, null, location));
			}
			
			if (hasFinishedWorking) return;
			
			// Apply forces
			
			if (hasBeenFlying)
			{
				for (var i:int = world.forces.length - 1; i >= 0; i--)
				{
					if (!world.forces[i].applyTo(this, timeDelta, lastTimeNotified) && !isGhost) world.forces.splice(i, 1);
				}
				
				for (i = forces.length - 1; i >= 0; i--)
				{
					if (!forces[i].applyTo(this, timeDelta, lastTimeNotified) && !isGhost) forces.splice(i, 1);
				}
			}
			
			// Time to notify
			
			if (hasBeenFlying)
			{
				stepsPerSecond = Math.max(25, Math.abs(velocity.x), Math.abs(velocity.y));
			}
			else
			{
				if (isWalking) stepsPerSecond = walkingSpeed;
				else stepsPerSecond = 25;
			}
			
			var timeTillNotify:Number = 1 / stepsPerSecond;
			if (timeTillNotify >= .04) timeTillNotify = .03999;
			timeToNotify = lastTimeNotified + timeTillNotify;
		}
		
		
		
		
		
		
		
		
		protected function move():Boolean
		{
			if (hasFinishedWorking) return false;
			
			if (moveCount > 20
				&& getHitTest())
			{
				traceStatus("Recovering...");
				
				while (true)
				{
					location.y--;
					if (!getHitTest()) break;
				}
				
				traceStatus("Successful.");
			}
			
			if (testIfLanded())
			// Landed
			{
				if (hasBeenFlying)
				{
					//traceStatus("Landed.");
					hasBeenFlying = false;
					
					onLanded();
				}
				
				return moveOnTerrain();
			}
			else
			// In the air
			{
				if (!hasBeenFlying)
				{
					//traceStatus("Starts to fly.");
					//CONFIG::debug { if (!isGhost) Console.say(name, "started to fly at", location.toString()); }
					hasBeenFlying = true;
				}
				
				return moveInAir();
			}
		}
		
		public function testIfLanded():Boolean
		{
			if (hasFinishedWorking) return true;
			
			var justBelow:Point = location.clone();
			justBelow.y += 1;
			
			if (velocity.length <= minVelocityForFlying
				&& (hitTestObjects(justBelow)
					|| hitTestTerrain(justBelow)))
			{
				return true;
			}
			//traceStatus("Not on ground.",velocity.length < minVelocityForFlying * timeDelta, velocity.length, minVelocityForFlying * timeDelta);
			return false;
		}
		
		
		
		
		
		
		protected function moveInAir():Boolean
		{
			var stepVelocity:Point = velocity.clone();
			stepVelocity.x *= timeDelta;
			stepVelocity.y *= timeDelta;
			
			var newLocation:Point = location.add(stepVelocity);
			
			var objectHit:WorldObject = hitTestObjects(newLocation);
			
			if (objectHit)
			{
				//traceStatus("Hit", objectHit.name, "!");
				return collideWithObject(objectHit);
			}
			
			if (hitTestTerrain(newLocation))
			// Hit
			{
				//traceStatus("Hit the terrain.");
				return collideWithWall(calculateHitWallAngle(newLocation));
			}
			
			location = newLocation;
			//traceStatus("Flew.",moveCount);
			
			return false;
		}
		
		
		
		
		
		protected function moveOnTerrain():Boolean 
		{
			velocity.x = velocity.y = 0;
			
			if (isJumping
				&& jump())
			{
				return true; // Switch to flying move
			}
			
			if (!isWalking) return false;
			
			var xStep:Number = facing * walkingSpeed * Math.min(timeDelta, .04);
			//if (xStep < 1) trace(location.x, location.y, facing, walkingSpeed, timeDelta);
			//var yStep:Number = walkability * Math.min(timeDelta, .04);
			
			var usableFloors:Vector.<Number> = findUsableFloors(location.x + xStep, location.y - walkability, location.y + walkability + 1, true);
			
			if (!usableFloors.length)
			// Can't walk further
			{
				//CONFIG::debug { if (!isGhost) Console.say(name, "became stuck at", location.toString()); }
				return false;
			}
			
			var prevLocation:Point = location.clone();
			
			if (usableFloors.length > 1)
			// Can fall
			{
				location.x += xStep;
				velocity.x = walkingSpeed * facing;
				if (walkingSpeed > runningSpeedLimit)
				{
					location.y += walkability;
					velocity.y = walkability;
				}
				
				//CONFIG::debug { if (!isGhost) Console.say(name, "started to fall at", location.toString()); }
				//traceStatus("No more ground!",moveCount);
			}
			else
			// Can walk
			{
				location.x += xStep;
				location.y = usableFloors[0];
				//CONFIG::debug { if (!isGhost) Console.say(name, "moved to", location.toString()); }
				//traceStatus("Walked.",moveCount);
			}
			
			stamina -= staminaBurnPerPixel * walkingSpeed * timeDelta;
			
			return false;
		}
		
		protected function jump():Boolean
		{
			if (lastJumpTime + jumpCoolOff > lastTimeNotified
				|| stamina < staminaBurnPerJump)
				return false;
			
			//traceStatus("Jumped.");
			if (isWalking) velocity.x = walkingSpeed * facing;
			velocity.y -= jumpStrengthY;
			stamina -= staminaBurnPerJump;
			lastJumpTime = lastTimeNotified;
			
			return true;
		}
		
		public function findUsableFloors(xToCheck:Number, firstYToCheck:Number, lastYToCheck:Number, getFirstOnly:Boolean):Vector.<Number>
		{
			var results:Vector.<Number> = new Vector.<Number>();
			
			if (lastYToCheck > world.terrain.height) lastYToCheck = world.terrain.height;
			var prevWasAvailable:Boolean = false;
			var canFall:Boolean = false;
			
			for (var toCheck:Point = new Point(xToCheck, firstYToCheck); toCheck.y <= lastYToCheck; toCheck.y++)
			{
				if (hitTestTerrain(toCheck)
					|| hitTestObjects(toCheck))
				// Hit
				{
					if (prevWasAvailable)
					{
						results.push(toCheck.y - 1);
						if (getFirstOnly) break;
					}
					prevWasAvailable = false;
				}
				else
				// No hit
				{
					prevWasAvailable = true;
					canFall = true;
				}
			}
			
			if (!results.length
				&& canFall)
			{
				results.push(0, 0);
			}
			
			return results;
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		public function calculateHitSets(sliceCount:int = 8):void
		{
			if (hitMapSets[radius] == undefined)
			{
				hitMapSet = new Vector.<BitmapData>(sliceCount, true);
				hitAngleSet = new Vector.<Point>(sliceCount, true);
				
				var sliceAngleRad:Number = DOUBLE_PI / sliceCount;
				var angle:Point;
				for (var i:int = 0; i < sliceCount; i++)
				{
					hitMapSet[i] = drawHitMapAngle(radius, -PI - sliceAngleRad / 2 + i * sliceAngleRad, -PI - sliceAngleRad / 2 + (i + 1) * sliceAngleRad);
					hitAngleSet[i] = Point.polar(100, -PI + i * sliceAngleRad);
				}
				
				hitMapSets[radius] = hitMapSet;
				hitAngleSets[radius] = hitAngleSet;
			}
			else
			{
				hitMapSet = hitMapSets[radius];
				hitAngleSet = hitAngleSets[radius];
			}
			
			if (hitMaps[radius] == undefined)
			{
				hitMap = drawHitMap(radius);
				hitMaps[radius] = hitMap;
			}
			else
			{
				hitMap = hitMaps[radius];
			}
		}
		
		public function drawHitMap(radius:Number):BitmapData
		{
			var hitMap:BitmapData = new BitmapData(radius * 2, radius * 2, true, 0);
			
			var pixelCenterLocationX:Number;
			var pixelCenterLocationY:Number;
			var pixelCenterDistance:Number;
			var pixelCenterAngleRad:Number;
			var outerRadiusSquared:Number = radius * radius;
			
			for (var pixelRow:Number = radius; pixelRow >= -radius; pixelRow--)
			{
				for (var pixelColumn:Number = -radius; pixelColumn < radius; pixelColumn++)
				{
					pixelCenterLocationX = pixelColumn + .5;
					pixelCenterLocationY = pixelRow + .5;
					pixelCenterDistance = pixelCenterLocationX * pixelCenterLocationX + pixelCenterLocationY * pixelCenterLocationY;
					
					if (pixelCenterDistance > outerRadiusSquared)
					{
						continue;
					}
					
					hitMap.setPixel32(radius + pixelColumn, radius + pixelRow, 0xff000000);
				}
			}
			
			return hitMap;
		}
		
		public function drawHitMapDoughnut(minRadius:Number, maxRadius:Number):BitmapData
		{
			var hitMap:BitmapData = new BitmapData(maxRadius * 2, maxRadius * 2, true, 0);
			
			var pixelCenterLocationX:Number;
			var pixelCenterLocationY:Number;
			var pixelCenterDistance:Number;
			var pixelCenterAngleRad:Number;
			var innerRadiusSquared:Number = minRadius * minRadius;
			var outerRadiusSquared:Number = maxRadius * maxRadius;
			
			for (var pixelRow:Number = maxRadius; pixelRow >= -maxRadius; pixelRow--)
			{
				for (var pixelColumn:Number = -maxRadius; pixelColumn < maxRadius; pixelColumn++)
				{
					pixelCenterLocationX = pixelColumn + .5;
					pixelCenterLocationY = pixelRow + .5;
					pixelCenterDistance = pixelCenterLocationX * pixelCenterLocationX + pixelCenterLocationY * pixelCenterLocationY;
					
					if (pixelCenterDistance > outerRadiusSquared)
					{
						continue;
					}
					if (pixelCenterDistance < innerRadiusSquared)
					{
						continue;
					}
					
					hitMap.setPixel32(maxRadius + pixelColumn, maxRadius + pixelRow, 0xff000000);
				}
			}
			
			return hitMap;
		}
		
		public function drawHitMapAngle(radius:Number, minAngleToCheckRad:Number, maxAngleToCheckRad:Number):BitmapData
		{
			var hitMap:BitmapData = new BitmapData(radius * 2, radius * 2, true, 0);
			
			while (maxAngleToCheckRad - minAngleToCheckRad > DOUBLE_PI)
			{
				maxAngleToCheckRad -= DOUBLE_PI;
			}
			
			while (minAngleToCheckRad > PI)
			{
				minAngleToCheckRad -= DOUBLE_PI;
				maxAngleToCheckRad -= DOUBLE_PI;
			}
			
			while (maxAngleToCheckRad < -PI)
			{
				minAngleToCheckRad += DOUBLE_PI;
				maxAngleToCheckRad += DOUBLE_PI;
			}
			
			var pixelCenterLocationX:Number;
			var pixelCenterLocationY:Number;
			var pixelCenterDistance:Number;
			var pixelCenterAngleRad:Number;
			var outerRadiusSquared:Number = radius * radius;
			
			for (var pixelRow:Number = radius; pixelRow >= -radius; pixelRow--)
			{
				for (var pixelColumn:Number = -radius; pixelColumn < radius; pixelColumn++)
				{
					pixelCenterLocationX = pixelColumn + .5;
					pixelCenterLocationY = pixelRow + .5;
					pixelCenterDistance = pixelCenterLocationX * pixelCenterLocationX + pixelCenterLocationY * pixelCenterLocationY;
					
					if (pixelCenterDistance > outerRadiusSquared)
					{
						continue;
					}
					
					pixelCenterAngleRad = Math.atan2(pixelCenterLocationY, pixelCenterLocationX);
					if (pixelCenterAngleRad < minAngleToCheckRad) pixelCenterAngleRad += DOUBLE_PI;
					else if (pixelCenterAngleRad > maxAngleToCheckRad) pixelCenterAngleRad -= DOUBLE_PI;
					
					if (pixelCenterAngleRad < minAngleToCheckRad
						|| pixelCenterAngleRad > maxAngleToCheckRad)
					{
						continue;
					}
					
					hitMap.setPixel32(radius + pixelColumn, radius + pixelRow, 0xff000000);
				}
			}
			
			return hitMap;
		}
		
		
		
		
		
		
		
		
		
		
		public function traceStatus(...rest):void
		{
			Console.sayToString(name,"at:", location.x.toPrecision(6), location.y.toPrecision(6),"vel:",velocity.x.toPrecision(4),velocity.y.toPrecision(4), velocity.length.toPrecision(4),":", rest);
		}
		
		
		
		
		
		
		
		
		
		
		
		public function getHitTest(location:Point = null):Boolean
		{
			if (hasFinishedWorking) return false;
			
			if (!location) location = this.location;
			
			var result:Boolean = hitTestTerrain(location) || hitTestObjects(location);
			return result;
		}
		
		protected function hitTestTerrain(location:Point):Boolean
		{
			return world.terrain.hitTest(terrainPoint, 128, hitMap, location.add(new Point(-radius, -radius)), 128);
		}
		
		protected function hitTestObjects(location:Point):WorldObject
		{
			for each (var object:WorldObject in world.objects)
			{
				if (object === this
					|| object.hasFinishedWorking
					|| !canHit(object)
					|| !object.canHit(this))
					continue;
				
				if (Point.distance(location, object.location) < radius + object.radius)
				{
					return object;
				}
			}
			
			return null;
		}
		
		
		
		
		
		
		
		
		
		
		public function calculateHitWallAngle(location:Point):Point
		{
			var objectPoint:Point = location.add(new Point(-radius, -radius));
			var lastHitWallAngle:Point;
			
			for (var i:int = 0; i < hitMapSet.length; i++)
			{
				if (world.terrain.hitTest(terrainPoint, 128, hitMapSet[i], objectPoint, 128))
				{
					if (lastHitWallAngle) lastHitWallAngle = lastHitWallAngle.add(hitAngleSet[i]);
					else lastHitWallAngle = hitAngleSet[i];
				}
			}
			
			return lastHitWallAngle;
		}
		
		protected function collideWithWall(lastHitWallAngle:Point):Boolean
		{
			//Console.say("I've hit a wall.");
			
			var normalDirectionUnitVec:Point = lastHitWallAngle;
			normalDirectionUnitVec.normalize(1);
			
			var tangentDirectionUnitVec:Point = new Point(-normalDirectionUnitVec.y, normalDirectionUnitVec.x); // Rotate by +90°
			
			var velocityOnNormal:Number = normalDirectionUnitVec.x * velocity.x + normalDirectionUnitVec.y * velocity.y; // Dot product: projecting velocity to the unit vector in the normal direction (projecting is only possible to a unit vector)
			var velocityOnTangent:Number = tangentDirectionUnitVec.x * velocity.x + tangentDirectionUnitVec.y * velocity.y;
			
			velocity.x = (-velocityOnNormal * normalDirectionUnitVec.x + velocityOnTangent * tangentDirectionUnitVec.x) * bounciness; // Adding the now normal vector and tangent vector to get the velocity vector
			velocity.y = ( -velocityOnNormal * normalDirectionUnitVec.y + velocityOnTangent * tangentDirectionUnitVec.y) * bounciness;
			
			onCollidedWithTerrain(Math.atan2(lastHitWallAngle.y, lastHitWallAngle.x), velocityOnNormal);
			
			return true;
		}
		
		protected function onCollidedWithTerrain(angle:Number, speed:Number):void 
		{
			
			//CONFIG::debug { if (!isGhost) Console.say(name, "collided with the terrain."); }
			
			var damageAmount:Number = (speed - damageResistance) / 6;
			
			if (damageAmount > 0)
			{
				//Console.say(name,"(",(this is TeamMember) ? TeamMember(this).team.name : "-",") badly collided with the terrain.");
				damage(damageAmount);
			}
			
			wayPoints.push(location.clone());
			
			if (isJumping
				&& angle > 0
				&& angle < PI
				&& velocity.y > -jumpStrengthY)
			{
				jump();
			}
			
			if (!isGhost && hitSoundAssetID) Program.mbToUI.newSounds.push(new SoundRequest(hitSoundAssetID, null, location, 0, Math.min(1, speed / damageResistance)));
		}
		
		
		
		
		
		
		
		
		public function canHit(object:WorldObject):Boolean
		{
			if (hasFinishedWorking) return false;
			if (isGhost != object.isGhost) return false;
			
			return true;
		}
		
		protected function collideWithObject(subject:WorldObject):Boolean
		{
			//nnConsole.say("I've hit another object.");
			
			//var averageBounciness:Number = (bounciness * mass + subject.bounciness * subject.mass) / (mass + subject.mass);
			
			var normalDirectionUnitVec:Point = subject.location.subtract(location);
			normalDirectionUnitVec.normalize(1);
			
			var tangentDirectionUnitVec:Point = new Point(-normalDirectionUnitVec.y, normalDirectionUnitVec.x); // Rotate by +90°
			
			var velocityOnNormal:Number = normalDirectionUnitVec.x * velocity.x + normalDirectionUnitVec.y * velocity.y; // Dot product: projecting velocity to the unit vector in the normal direction (projecting is only possible to a unit vector)
			var velocityOnTangent:Number = tangentDirectionUnitVec.x * velocity.x + tangentDirectionUnitVec.y * velocity.y;
			var velocityOnNormal2:Number = normalDirectionUnitVec.x * subject.velocity.x + normalDirectionUnitVec.y * subject.velocity.y;
			var velocityOnTangent2:Number = tangentDirectionUnitVec.x * subject.velocity.x + tangentDirectionUnitVec.y * subject.velocity.y;
			
			var newVelocityOnNormal:Number = (velocityOnNormal * (mass - subject.mass) + 2 * subject.mass * velocityOnNormal2) / (mass + subject.mass); // 1D collision, as there is no change in velocity on the tangent
			var newVelocityOnNormal2:Number = (velocityOnNormal2 * (subject.mass - mass) + 2 * subject.mass * velocityOnNormal) / (mass + subject.mass);
			
			velocity.x = (newVelocityOnNormal * normalDirectionUnitVec.x + velocityOnTangent * tangentDirectionUnitVec.x)/* * averageBounciness*/; // Adding the now normal vector and tangent vector to get the velocity vector
			velocity.y = (newVelocityOnNormal * normalDirectionUnitVec.y + velocityOnTangent * tangentDirectionUnitVec.y)/* * averageBounciness*/;
			
			subject.velocity.x = (newVelocityOnNormal2 * normalDirectionUnitVec.x + velocityOnTangent2 * tangentDirectionUnitVec.x)/* * averageBounciness*/;
			subject.velocity.y = (newVelocityOnNormal2 * normalDirectionUnitVec.y + velocityOnTangent2 * tangentDirectionUnitVec.y)/* * averageBounciness*/;
			
			onCollidedWithObject(subject, Math.atan2(normalDirectionUnitVec.y, normalDirectionUnitVec.x), velocityOnNormal);
			
			subject.onCollidedWithObject(this, Math.atan2(-normalDirectionUnitVec.y, -normalDirectionUnitVec.x), velocityOnNormal);
			subject.wake();
			
			return true;
		}
		
		protected function onCollidedWithObject(object:WorldObject, angle:Number, speed:Number):void 
		{
			
			//CONFIG::debug { if (!isGhost) Console.say(name, "collided with", object.name); }
			
			var damageAmount:Number = (speed - damageResistance) / 6;
			
			if (damageAmount > 0)
			{
				//Console.say(name,"(",(this is TeamMember) ? TeamMember(this).team.name : "-",") badly collided with",object.name);
				damage(damageAmount);
			}
			
			wayPoints.push(location.clone());
			
			if (isJumping
				&& angle > 0
				&& angle < PI
				&& velocity.y > -jumpStrengthY)
			{
				jump();
			}
		}
		
		
		
		
		
		
		
		
		public function startWalking(facing:int):void
		{
			if (hasFinishedWorking) return;
			
			//CONFIG::debug { if (!isGhost) Console.say(name, "started to walk",facing==1?"right.":"left."); }
			
			this.facing = facing;
			isWalking = true;
			
			if (!activeAirWalkForce)
			{
				activeAirWalkForce = new AirWalkForce();
				forces.push(activeAirWalkForce);
			}
			
			//wake();
		}
		
		public function stopWalking():void
		{
			if (hasFinishedWorking) return;
			
			//CONFIG::debug { if (!isGhost) Console.say(name, "stopped walking."); }
			
			isWalking = false;
			
			//traceStatus("Stops walking.");
			
			if (activeAirWalkForce)
			{
				forces.splice(forces.indexOf(activeAirWalkForce), 1);
				activeAirWalkForce = null;
			}
			
			//wake();
		}
		
		public function startJumping():void
		{
			if (hasFinishedWorking) return;
			
			//CONFIG::debug { if (!isGhost) Console.say(name, "started to jump."); }
			
			isJumping = true;
			
			//wake();
		}
		
		public function stopJumping():void
		{
			if (hasFinishedWorking) return;
			
			//CONFIG::debug { if (!isGhost) Console.say(name, "stopped jumping."); }
			
			isJumping = false;
			
			//wake();
		}
		
		
		
		
		
		
		
		
		
		
		public function isSleeping():Boolean
		{
			return (hasFinishedWorking || testIfLanded());
		}
		
		public function finishWorking():void
		{
			if (hasFinishedWorking) return;
			
			//CONFIG::debug { if (!isGhost) Console.say(name, "finished working."); }
			
			this.hasFinishedWorking = true;
			//traceStatus("Finished working!");
			
			onDeath();
		}
		
		
		
		
		
		
		
		public function generateWorldObjects():Vector.<WorldObject>
		{
			return null;
		}
		
		public function damage(value:int):void
		{
			if (hasFinishedWorking) return;
			if (health <= 0) return;
			if (value <= 0) return;
			
			health -= value;
			//CONFIG::debug {if (!isGhost) Console.say(name, "(", (this is TeamMember) ? TeamMember(this).team.name : "-", ")", "lost", value, "health. Remains:", health);}
			
			if (health <= 0) finishWorking();
		}
		
		protected function onDeath():void
		{
			//CONFIG::debug { if (!isGhost) Console.say(name, "died at", location.toString()); }
		}
		
		protected function onLanded():void
		{
			//CONFIG::debug { if (!isGhost) Console.say(name, "landed at", location.toString()); }
		}
		
		public function heal(value:int):void
		{
			if (hasFinishedWorking) return;
			
			health += value;
		}
		
		
		
		
		
		
		
		public function mergeWithAlphaChannel(bmdToMerge:BitmapData, location:Point):void
		{
			location.x = Math.round(location.x);
			location.y = Math.round(location.y);
			var alphaMerger:BitmapData = new BitmapData(bmdToMerge.width, bmdToMerge.height, false, 0x000000);
			
			// Copying the current alpha to the red channel
			alphaMerger.copyChannel(world.terrain, new Rectangle(location.x, location.y, bmdToMerge.width, bmdToMerge.height), terrainPoint, BitmapDataChannel.ALPHA, BitmapDataChannel.RED);
			
			// Copying the hole on top, alpha taken into account
			
			// Quicker method (5×), no blending
			alphaMerger.copyPixels(bmdToMerge, new Rectangle(0, 0, bmdToMerge.width, bmdToMerge.height), terrainPoint, null, null, true);
			
			// Slower method (5×), with blending
			//alphaMerger.draw(bmdToMerge, null, null, BlendMode.MULTIPLY);
			
			// Copying the red channel back to the original alpha channel
			world.terrain.copyChannel(alphaMerger, new Rectangle(0, 0, bmdToMerge.width, bmdToMerge.height), location, BitmapDataChannel.RED, BitmapDataChannel.ALPHA);
			
			alphaMerger.dispose();
		}
		
		
		
		
		
		
		
		
		public function restoreStaminaTo(value:Number = 1):void
		{
			stamina = value;
		}
		
		public function clone(c:WorldObject = null):WorldObject
		{
			if (!c) c = new WorldObject(world, team, owner, id);
			c.radius = radius;
			c.location = location.clone();
			for each (var vp:Point in wayPoints)
			{
				c.wayPoints.push(vp.clone());
			}
			c.wayPointsClearedTime = wayPointsClearedTime;
			c.velocity = velocity.clone();
			c.mass = mass;
			c.bounciness = bounciness;
			c.minVelocityForFlying = minVelocityForFlying;
			c.damageResistance = damageResistance;
			c.hitMapSet = hitMapSet;
			c.hitMap = hitMap;
			c.hitAngleSet = hitAngleSet;
			if (lastHitWallAngle) c.lastHitWallAngle = lastHitWallAngle.clone();
			c.lastTimeNotified = lastTimeNotified;
			c.timeDelta = timeDelta;
			c.timeToNotify = timeToNotify;
			c.stepsPerSecond = stepsPerSecond;
			c.hasBeenFlying = hasBeenFlying;
			for each (var force:WorldForce in forces)
			{
				if (force == activeAirWalkForce)
				{
					var awf:AirWalkForce = AirWalkForce(force.clone());
					c.activeAirWalkForce = awf;
					c.forces.push(awf);
				}
				else
				{
					c.forces.push(force);
				}
			}
			c.isJumping = isJumping;
			c.jumpStrengthY = jumpStrengthY;
			c.jumpCoolOff = jumpCoolOff;
			c.lastJumpTime = lastJumpTime;
			c.walkingSpeed = walkingSpeed;
			c.runningSpeedLimit = runningSpeedLimit;
			c.walkability = walkability;
			c.facing = facing;
			c.isWalking = isWalking;
			c.stamina = stamina;
			c.staminaBurnPerPixel = staminaBurnPerPixel;
			c.staminaBurnPerJump = staminaBurnPerJump;
			c.hasBeenNotified = hasBeenNotified;
			c.hasFinishedWorking = hasFinishedWorking;
			c.world = world;
			c.name = name;
			c.health = health;
			c.moveCount = moveCount;
			c.isGhost = isGhost;
			c.enemyDamage = enemyDamage;
			c.friendlyDamage = friendlyDamage;
			c.closestEnemyDistance = closestEnemyDistance;
			c.team = team;
			c.owner = owner;
			c.hitSoundAssetID = hitSoundAssetID;
			c.inWaterSoundAssetID = inWaterSoundAssetID;
			return c;
		}
		
		public function getAssetIDs():Vector.<int>
		{
			return null;
		}
		
		public function createAppearance(worldAppearance:WorldAppearance):WorldObjectAppearance
		{
			return null;
		}
		
		public function wake():void
		{
			if (hasFinishedWorking) timeToNotify = Infinity;
			else timeToNotify = lastTimeNotified;
		}
	}
}