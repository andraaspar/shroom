package com.pirkadat.logic 
{
	import com.pirkadat.ui.Console;
	import com.pirkadat.ui.Gui;
	public class ShootRound extends GameRound
	{
		public static const STATE_STARTED:int = 0;
		public static const STATE_WAIT_FOR_TEAM:int = 1;
		public static const STATE_AIM:int = 2;
		public static const STATE_PREPARE:int = 3;
		public static const STATE_SETTLE:int = 4;
		public static const STATE_WAIT:int = 5;
		
		public static const TYPE_NORMAL:int = 0;
		public static const TYPE_DAWN:int = 1;
		public static const TYPE_DOUGHNUT:int = 2;
		public static const TYPE_TESLA:int = 3;
		
		public var type:int;
		
		public var timeLimit:Number;
		
		public var step:int;
		public var membersMoved:Vector.<TeamMember>;
		public var member:TeamMember;
		
		public var memberIsOnLeft:Boolean;
		public var aim:Number;
		public var facing:int;
		public var powerMultiplier:Number;
		public var bounceCount:int;
		public var bestShot:TestShot;
		public var aimStep:Number;
		public var powerStep:Number;
		public var maxBounces:int;
		public var angleRandomness:Number;
		public var powerRandomness:Number;
		public var waitForMemberSwitch:Boolean;
		
		public function ShootRound(game:Game) 
		{
			super(game);
			
			allowsBounceChanges = true;
		}
		
		protected function setState(value:int):void
		{
			state = value;
			
			if (selectedTeam && selectedTeam.selectedMember) selectedTeam.selectedMember.stopAll();
			
			switch (state)
			{
				case STATE_WAIT_FOR_TEAM:
					Console.say("Shoot round: waiting for team.");
					timeLimit = game.world.currentTime + 2.9;
					while (true)
					{
						selectNextTeam();
						if (!selectedTeam) return setState(STATE_PREPARE);
						if (selectedTeam.checkIfAlive()) break;
					}
					if (selectedTeam.selectedMember.health <= 0) selectedTeam.selectNextMember();
					
					Program.mbToUI.newState = MBToUI.STATE_AIM;
					Program.mbToUI.newMessageBoxText = selectedTeam.name + " is next!";
					Program.mbToUI.newDoneButtonText = "";
					
					Gui.showTeamWindow();
					if (allowsBounceChanges) Gui.showBounceWindow();
					
					// No execute to prevent previous team's commands affecting this team
				break;
				case STATE_AIM:
					Console.say("Shoot round: team is aiming.");
					
					step = 0;
					
					Program.mbToUI.newMessageBoxText = selectedTeam.name + " is aiming their ";
					switch (type)
					{
						case TYPE_NORMAL:
							Program.mbToUI.newMessageBoxText += "Shooting Stars!";
						break;
						case TYPE_DAWN:
							Program.mbToUI.newMessageBoxText += "Dawn Guns!";
						break;
						case TYPE_DOUGHNUT:
							Program.mbToUI.newMessageBoxText += "Doughnuts!";
						break;
						case TYPE_TESLA:
							Program.mbToUI.newMessageBoxText += "Tesla Balls!";
						break;
					}
					if (selectedTeam.controller == Team.CONTROLLER_HUMAN) Program.mbToUI.newDoneButtonText = "READY TO SHOOT";
					else Program.mbToUI.newDoneButtonText = "I AM BORED";
				break;
				case STATE_PREPARE:
					Console.say("Shoot round: preparing.");
					timeLimit = game.world.currentTime + 2.9;
					Program.mbToUI.newDoneButtonText = "";
					Program.mbToUI.clearCanvas = true;
					Program.mbToUI.newState = MBToUI.STATE_FOCUS;
					Gui.removeTeamWindow();
					Gui.removeBounceWindow();
					deselectTeam();
				break;
				case STATE_SETTLE:
					Console.say("Shoot round: shooting, settling.");
					Program.mbToUI.newSounds.push(new SoundRequest(game.gongSoundAssetID, null, null));
					Program.mbToUI.newMessageBoxText = "Fire!!!";
					Program.mbToUI.newMessageBoxTime = 75;
					Program.mbToUI.newState = MBToUI.STATE_SHOOT;
					
					fire();
				break;
				case STATE_WAIT:
					Program.mbToUI.newMessageBoxText = "Take a look around, and press NEXT ROUND when you're ready!";
					Program.mbToUI.newDoneButtonText = "NEXT ROUND";
					Program.mbToUI.newState = MBToUI.STATE_OVERVIEW;
				break;
				case STATE_ENDED:
				case STATE_GAME_OVER:
					Gui.removeTeamWindow();
					Gui.removeBounceWindow();
				break;
			}
		}
		
		override public function execute():void 
		{
			switch (state)
			{
				case STATE_STARTED:
					Console.say("Shoot round: started.");
					teamQueue = getSortedTeams(game.teams);
					switch (type)
					{
						case TYPE_NORMAL:
							TeamMember.bullet = ShootingStar;
						break;
						case TYPE_DAWN:
							TeamMember.bullet = DawnBall;
						break;
						case TYPE_DOUGHNUT:
							TeamMember.bullet = Doughnut;
						break;
						case TYPE_TESLA:
							TeamMember.bullet = TeslaBall;
						break;
					}
					
					Program.mbToUI.newBulletSelected = true;
					Program.mbToUI.newTeamQueue = teamQueue.concat();
					setState(STATE_WAIT_FOR_TEAM);
				break;
				case STATE_WAIT_FOR_TEAM:
					if (game.world.currentTime >= timeLimit
						|| Program.mbToP.upStartRequested
						|| Program.mbToP.downStartRequested
						|| Program.mbToP.fire1StartRequested
						|| Program.mbToP.leftStartRequested 
						|| Program.mbToP.rightStartRequested
						|| Program.mbToP.switchMemberRequested
						|| Program.mbToP.switchMemberReverseRequested
						|| Program.mbToP.newSelectedTeamMember
						|| !isNaN(Program.mbToP.newAim)
						|| Program.mbToP.iAmHere
						|| !isNaN(Program.mbToP.newBounceCount)
						|| selectedTeam.controller == Team.CONTROLLER_AI)
					{
						setState(STATE_AIM);
						// And fall through to aim
					}
					else
					{
						break;
					}
				case STATE_AIM:
					if (selectedTeam.controller == Team.CONTROLLER_AI) doAI();
					
					if (Program.mbToP.upStartRequested) selectedTeam.selectedMember.startAimingUp();
					if (Program.mbToP.upStopRequested) selectedTeam.selectedMember.stopAimingUp();
					if (Program.mbToP.downStartRequested) selectedTeam.selectedMember.startAimingDown();
					if (Program.mbToP.downStopRequested) selectedTeam.selectedMember.stopAimingDown();
					if (allowsBounceChanges 
						&& !isNaN(Program.mbToP.newBounceCount) 
						&& Program.mbToP.newBounceCount <= 3 
						&& Program.mbToP.newBounceCount >= 0)
					{
						selectedTeam.selectedMember.bounceCount = Program.mbToP.newBounceCount;
						Program.mbToUI.newBounceCount = selectedTeam.selectedMember.bounceCount;
					}
					if (Program.mbToP.fire1StartRequested)
					{
						selectedTeam.selectedMember.powerMultiplier = 0;
						selectedTeam.selectedMember.startPoweringUp();
					}
					if (Program.mbToP.fire1StopRequested) selectedTeam.selectedMember.stopPoweringUp();
					
					if (Program.mbToP.leftStartRequested) selectedTeam.selectedMember.facing = -1;
					if (Program.mbToP.rightStartRequested) selectedTeam.selectedMember.facing = 1;
					
					if (!isNaN(Program.mbToP.newAim))
					{
						selectedTeam.selectedMember.aim = Program.mbToP.newAim;
						selectedTeam.selectedMember.facing = Program.mbToP.newFacing;
						selectedTeam.selectedMember.powerMultiplier = Program.mbToP.newPowerMultiplier;
					}
					
					if (Program.mbToP.switchMemberRequested)
					{
						selectedTeam.selectNextMember();
					}
					if (Program.mbToP.switchMemberReverseRequested)
					{
						selectedTeam.selectNextMember(true);
					}
					if (Program.mbToP.newSelectedTeamMember)
					{
						selectedTeam.selectMember(Program.mbToP.newSelectedTeamMember);
					}
					if (Program.mbToP.endTurnRequested)
					{
						Console.say("Shoot round: user requested end.");
						setState(STATE_WAIT_FOR_TEAM);
						return;
					}
				break;
				case STATE_PREPARE:
					Program.mbToUI.newMessageBoxText = "Firing in... " + int(timeLimit - game.world.currentTime + 1);
					
					if (game.world.currentTime >= timeLimit) setState(STATE_SETTLE);
				break;
				case STATE_SETTLE:
					if (game.checkIfDrawn())
					{
						Console.say("Shoot round: game over.");
						setState(STATE_GAME_OVER);
						return;
					}
					if (game.world.checkIfSleeping())
					{
						if (game.checkIfOver())
						{
							Console.say("Shoot round: game over.");
							setState(STATE_GAME_OVER);
							return;
						}
						else
						{
							setState(STATE_WAIT);
							return;
						}
					}
				break;
				case STATE_WAIT:
					if (Program.mbToP.endTurnRequested)
					{
						setState(STATE_ENDED);
					}
				break;
			}
		}
		
		override public function getName():String 
		{
			return "Shooting Star Round";
		}
		
		protected function doAI():void
		{
			if (step == 0)
			{
				membersMoved = new <TeamMember>[];
				member = null;
				
				switch (selectedTeam.aiLevel)
				{
					case Team.AI_EASY:
						aimStep = Math.PI / 180 * 20;
						powerStep = .5;
						maxBounces = 0;
						angleRandomness = Math.PI / 180 * 5;
						powerRandomness = .1;
					break;
					case Team.AI_NORMAL:
						aimStep = Math.PI / 180 * 10;
						powerStep = .2;
						maxBounces = allowsBounceChanges ? 1 : 0;
						angleRandomness = Math.PI / 180 * 1;
						powerRandomness = .02;
					break;
					case Team.AI_HARD:
						aimStep = Math.PI / 180 * 5;
						powerStep = .2;
						maxBounces = allowsBounceChanges ? 1 : 0;
						angleRandomness = 0;
						powerRandomness = 0;
					break;
				}
				
				bounceCount = 0;
				powerMultiplier = powerStep;
				aim = -Math.PI / 2;
				
				waitForMemberSwitch = true;
				
				Program.fastFakeThread.add(aimThread, aimThreadCallBack);
			}
			
			step++;
		}
		
		public function aimThread():Boolean
		{
			// Wait for member switch check
			
			if (waitForMemberSwitch)
			{
				if (Program.mbToP.switchMemberRequested)
				{
					//Console.say("Waiting for member switch...");
					return true;
				}
				else
				{
					waitForMemberSwitch = false;
					
					// Member loop end check
					
					member = selectedTeam.selectedMember;
					if (membersMoved.indexOf(member) != -1)
					{
						//Console.say("Member loop ended.");
						
						return false;
					}
					
					memberIsOnLeft = member.location.x < member.world.terrain.width / 2;
					facing = memberIsOnLeft ? 1 : -1;
				}
			}
			
			// Facing loop end check
			
			if (memberIsOnLeft && facing < -1
				|| !memberIsOnLeft && facing > 1
				|| Program.mbToP.humanIsBored)
			{
				//Console.say("Facing loop ended.");
				
				if (bestShot)
				{
					bestShot.aim += Math.random() * angleRandomness * 2 - angleRandomness;
					if (bestShot.aim > Math.PI / 2) bestShot.aim = Math.PI / 2;
					if (bestShot.aim < -Math.PI / 2) bestShot.aim = -Math.PI / 2;
					
					bestShot.powerMultiplier += Math.random() * powerRandomness * 2 - powerRandomness;
					if (bestShot.powerMultiplier > 1) bestShot.powerMultiplier = 1;
					if (bestShot.powerMultiplier < 0) bestShot.powerMultiplier = 0;
					
					Program.mbToP.newAim = bestShot.aim;
					Program.mbToP.newFacing = bestShot.facing;
					Program.mbToP.newBounceCount = bestShot.bounceCount;
					if (!bestShot.damageRatio && bestShot.friendlyDamage) Program.mbToP.newPowerMultiplier = 0;
					else Program.mbToP.newPowerMultiplier = bestShot.powerMultiplier;
					
					Console.say(member.name, bestShot);
				}
				else
				{
					Program.mbToP.newPowerMultiplier = 0;
				}
				
				//var mark:TrueSize = new Cross(new LineStyle(2, 0xffffff), null, true);
				//Program.gui.gamePage.worldWindow.worldAppearance.canvas.addChild(mark);
				//mark.x = bestShot.impactX;
				//mark.y = bestShot.impactY;
				
				membersMoved.push(member);
				Program.mbToP.switchMemberRequested = true;
				
				bestShot = null;
				waitForMemberSwitch = true;
				
				return true;
			}
			
			// Bounce loop end check
			
			if (bounceCount > maxBounces)
			{
				facing += memberIsOnLeft ? -2 : 2;
				bounceCount = 0;
				
				return true;
			}
			
			// PowerMultiplier loop end check
			
			if (powerMultiplier > 1)
			{
				//Console.say("PowerMultiplier loop ended.");
				
				bounceCount++;
				powerMultiplier = powerStep;
				
				return true;
			}
			
			// Aim loop end check
			
			if (aim > Math.PI / 2)
			{
				//Console.say("Aiming loop ended.");
				
				powerMultiplier += powerStep;
				aim = -Math.PI / 2;
				
				return true;
			}
			
			// Aim loop body
			
			//Console.say("Aiming loop running...");
			
			var testShot:TestShot = new TestShot(aim, facing, powerMultiplier, game.world, member, ShootingStar, bounceCount);
			if (bestShot)
			{
				if (testShot.damageRatio > bestShot.damageRatio)
				{
					//Console.say("ACCEPTED - better damage ratio:",testShot);
					bestShot = testShot;
				}
				else if (testShot.damageRatio == bestShot.damageRatio)
				{
					if (testShot.enemyDamage > bestShot.enemyDamage)
					{
						//Console.say("ACCEPTED - more damage:", testShot);
						bestShot = testShot;
					}
					else if (testShot.enemyDamage == bestShot.enemyDamage)
					{
						if (testShot.friendlyDamage < bestShot.friendlyDamage)
						{
							//Console.say("ACCEPTED - less friendly damage:", testShot);
							bestShot = testShot;
						}
						else if (testShot.friendlyDamage == bestShot.friendlyDamage)
						{
							if (testShot.enemyDamage)
							{
								if (testShot.steps < bestShot.steps)
								{
									//Console.say("ACCEPTED - less steps:",testShot);
									bestShot = testShot;
								}
								else
								{
									//Console.say("Discarded - not better:",testShot);
								}
							}
							else
							{
								if (testShot.closestEnemyDistance < bestShot.closestEnemyDistance)
								{
									//Console.say("ACCEPTED - closer to enemy:",testShot);
									bestShot = testShot;
								}
								else
								{
									//Console.say("Discarded - not better:",testShot);
								}
							}
						}
						else
						{
							//Console.say("Discarded - more friendly damage:",testShot);
						}
					}
					else
					{
						//Console.say("Discarded - less enemy damage:",testShot);
					}
				}
				else
				{
					//Console.say("Discarded - worse damage ratio:",testShot);
				}
			}
			else
			{
				//Console.say("FIRST SHOT:",testShot);
				bestShot = testShot;
			}
			
			// Aim loop tail
			
			aim += aimStep;
			
			return true;
		}
		
		public function aimThreadCallBack():void
		{
			//Console.say("Aim thread finished.");
			Program.mbToP.endTurnRequested = true;
		}
		
		override public function getHelpSectionID():String 
		{
			if (type == TYPE_NORMAL) return "#shooting_star_round";
			return "";
		}
	}

}