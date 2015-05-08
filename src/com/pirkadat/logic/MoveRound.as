package com.pirkadat.logic 
{
	import com.pirkadat.ui.Console;
	import com.pirkadat.ui.Gui;
	import flash.geom.Point;
	public class MoveRound extends GameRound
	{
		public static const STATE_STARTED:int = 0;
		public static const STATE_WAIT_FOR_TEAM:int = 1;
		public static const STATE_MOVE:int = 2;
		public static const STATE_SETTLE:int = 3;
		
		public static const TYPE_NORMAL:int = 0;
		public static const TYPE_MOONWALK:int = 1;
		public static const TYPE_DOUBLE:int = 2;
		
		public var type:int;
		
		public var timeLimit:Number;
		
		public var aiStep:int;
		public var aiMembersMoved:Vector.<TeamMember>;
		public var aiMember:TeamMember;
		public var aiMemberMoveDirection:int;
		//public var aiMemberMoveSteps:int;
		public var aiMemberMinStamina:Number;
		
		public var aiExpectedLocation:Point;
		
		public function MoveRound(game:Game) 
		{
			super(game);
		}
		
		public function setState(value:int):void
		{
			state = value;
			
			if (selectedTeam && selectedTeam.selectedMember) selectedTeam.selectedMember.stopAll();
			
			switch (state)
			{
				case STATE_WAIT_FOR_TEAM:
					Console.say("Move round: waiting for team.");
					timeLimit = game.world.currentTime + 2.9;
					while (true)
					{
						selectNextTeam();
						if (!selectedTeam)
						{
							Console.say("Move round: ended.");
							setState(STATE_ENDED);
							Gravity.effect = Gravity.EFFECT_NORMAL;
							return;
						}
						if (selectedTeam.checkIfAlive()) break;
					}
					if (selectedTeam.selectedMember.health <= 0) selectedTeam.selectNextMember();
					setStamina(type == TYPE_DOUBLE ? 2 : 1);
					
					Program.mbToUI.newState = MBToUI.STATE_MOVE;
					Program.mbToUI.newMessageBoxText = selectedTeam.name + " is next!";
					Program.mbToUI.newDoneButtonText = "";
					
					Gui.showTeamWindow();
					
					// No execute to prevent previous team's commands affecting this team
				break;
				case STATE_MOVE:
					Console.say("Move round: team is moving.");
					
					aiStep = 0;
					
					switch (type)
					{
						case TYPE_NORMAL:
							Program.mbToUI.newMessageBoxText = selectedTeam.name + " is moving!";
						break;
						case TYPE_DOUBLE:
							Program.mbToUI.newMessageBoxText = selectedTeam.name + " is running!";
						break;
						case TYPE_MOONWALK:
							Program.mbToUI.newMessageBoxText = selectedTeam.name + " is going on a moonwalk!";
						break;
					}
					if (selectedTeam.controller == Team.CONTROLLER_HUMAN) Program.mbToUI.newDoneButtonText = "FINISHED MOVING";
					else Program.mbToUI.newDoneButtonText = "I AM BORED";
					
					// No execute necessary, it falls through
				break;
				case STATE_SETTLE:
					Console.say("Move round: settling.");
					Program.mbToUI.newDoneButtonText = "";
					deselectTeam();
				case STATE_ENDED:
				case STATE_GAME_OVER:
					Gui.removeTeamWindow();
				break;
			}
		}
		
		override public function execute():void 
		{
			switch (state)
			{
				case STATE_STARTED:
					Console.say("Move round: started.");
					teamQueue = getSortedTeams(game.teams);
					if (type == TYPE_MOONWALK) Gravity.effect = Gravity.EFFECT_NORMAL / 2;
					
					Program.mbToUI.newTeamQueue = teamQueue.concat();
					Program.mbToUI.newHelpImageAssetID = 200;
					setState(STATE_WAIT_FOR_TEAM);
				break;
				case STATE_WAIT_FOR_TEAM:
					if (game.world.currentTime >= timeLimit
						|| Program.mbToP.upStartRequested
						|| Program.mbToP.downStartRequested
						|| Program.mbToP.leftStartRequested 
						|| Program.mbToP.rightStartRequested
						|| Program.mbToP.special1StartRequested
						|| Program.mbToP.switchMemberRequested
						|| Program.mbToP.switchMemberReverseRequested
						|| Program.mbToP.newSelectedTeamMember
						|| Program.mbToP.iAmHere
						|| selectedTeam.controller == Team.CONTROLLER_AI)
					{
						setState(STATE_MOVE);
						// And fall through to move
					}
					else
					{
						break;
					}
				case STATE_MOVE:
					if (!selectedTeam.checkIfAlive())
					{
						Console.say("Move round: selected team died.");
						setState(STATE_SETTLE);
						return;
					}
					if (selectedTeam.selectedMember.health <= 0)
					{
						Console.say("Move round: selected member died.");
						selectedTeam.selectNextMember();
						break;
					}
					
					if (selectedTeam.controller == Team.CONTROLLER_AI)
					{
						doAI();
					}
					
					if (!isNaN(Program.mbToP.newWalkingSpeedMultiplier)) selectedTeam.selectedMember.setSpeedMultiplier(Program.mbToP.newWalkingSpeedMultiplier);
					if (Program.mbToP.upStartRequested) selectedTeam.selectedMember.startJumping();
					if (Program.mbToP.upStopRequested) selectedTeam.selectedMember.stopJumping();
					
					if (Program.mbToP.leftStartRequested) selectedTeam.selectedMember.startWalking(-1);
					if (Program.mbToP.rightStartRequested) selectedTeam.selectedMember.startWalking(1);
					if ((Program.mbToP.leftStopRequested 
							&& selectedTeam.selectedMember.facing == -1)
						|| (Program.mbToP.rightStopRequested
							&& selectedTeam.selectedMember.facing == 1))
						selectedTeam.selectedMember.stopWalking();
					
					if (Program.mbToP.switchMemberRequested) selectedTeam.selectNextMember();
					if (Program.mbToP.switchMemberReverseRequested) selectedTeam.selectNextMember(true);
					if (Program.mbToP.newSelectedTeamMember) selectedTeam.selectMember(Program.mbToP.newSelectedTeamMember);
					if (Program.mbToP.endTurnRequested)
					{
						Console.say("Move round: user requested end.");
						setState(STATE_SETTLE);
						return;
					}
				break;
				case STATE_SETTLE:
					if (game.world.checkIfSleeping())
					{
						if (game.checkIfOver())
						{
							Console.say("Move round: game over.");
							setState(STATE_GAME_OVER);
							Gravity.effect = Gravity.EFFECT_NORMAL;
						}
						else
						{
							setState(STATE_WAIT_FOR_TEAM);
						}
					}
				break;
			}
		}
		
		override public function getName():String 
		{
			return "Moving Round";
		}
		
		protected function doAI():void
		{
			if (aiStep == 0)
			{
				aiMembersMoved = new <TeamMember>[];
				aiMember = null;
			}
			
			aiStep++;
			
			var firstStep:Boolean;
			
			if (selectedTeam.selectedMember != aiMember)
			{
				aiMember = selectedTeam.selectedMember;
				//CONFIG::debug { Console.say(aiStep, ":", aiMember.name, "selected."); }
				firstStep = true;
				
				//aiMemberMoveSteps = Math.round(Math.random() * (selectedTeam.selectedMember.stamina / selectedTeam.selectedMember.staminaBurnPerPixel / (selectedTeam.selectedMember.maxWalkingSpeed / 25)));
				aiMemberMinStamina = (Math.random() < .5) ? 0 : .5;
				aiMemberMoveDirection = (Math.random() < .5) ? -1 : 1;
			}
			
			if (aiMembersMoved.indexOf(aiMember) != -1)
			{
				//CONFIG::debug { Console.say(aiStep, ":", aiMember.name, "has already moved... ending turn."); }
				Program.mbToP.endTurnRequested = true;
				return;
			}
			
			//aiMemberMoveSteps--;
			
			if (aiMember.hasBeenFlying)
			{
				//CONFIG::debug {Console.say(aiStep, ":", aiMember.name,"has been flying... stopping jump.")}
				Program.mbToP.upStopRequested = true;
				if (aiMember.isWalking && aiMember.wayPoints.length)
				{
					//CONFIG::debug {Console.say(aiStep, ":", aiMember.name,"is walking and has waypoints... stopping",aiMemberMoveDirection == 1?"right.":"left.")}
					if (aiMemberMoveDirection == 1) Program.mbToP.rightStopRequested = true;
					else Program.mbToP.leftStopRequested = true;
				}
				
				if (Program.mbToP.humanIsBored)
				{
					//CONFIG::debug {Console.say(aiStep, ":", aiMember.name,"made human bored... switching, stopping",aiMemberMoveDirection == 1?"right.":"left.")}
					if (aiMemberMoveDirection == 1) Program.mbToP.rightStopRequested = true;
					else Program.mbToP.leftStopRequested = true;
					
					aiMembersMoved.push(aiMember);
					Program.mbToP.switchMemberRequested = true;
				}
				return;
			}
			else
			{
				var walker:TeamMember = TeamMember(aiMember.clone());
				walker.isGhost = true;
				
				if (!walker.isWalking)
				{
					walker.startWalking(aiMemberMoveDirection);
				}
				
				var nextFrameWorldTime:Number = aiMember.world.currentTime + .04;
				
				while (walker.timeToNotify < nextFrameWorldTime
					&& !walker.hasFinishedWorking)
				{
					walker.notify(walker.timeToNotify);
				}
				
				var movedInTheRightDirection:Boolean = (walker.location.x - aiMember.location.x) * aiMemberMoveDirection > 0;
				var isAlive:Boolean = !walker.hasFinishedWorking;
				var isFalling:Boolean = !walker.testIfLanded();
				
				var mayWalk:Boolean = movedInTheRightDirection && isAlive && !isFalling;
				
				//CONFIG::debug 
				//{ 
					//if (mayWalk) Console.say(aiMember.name, "could walk to", walker.location.toString()); 
				//} 
				
				var walkerPathX:Vector.<String>;
				var walkerPathY:Vector.<String>;
				if (isFalling)
				{
					while (!walker.hasFinishedWorking)
					{
						if (walker.timeToNotify > nextFrameWorldTime)
						{
							if (!walker.hasBeenFlying && walker.testIfLanded()) break;
							
							if (walker.isWalking && walker.wayPoints.length)
							{
								walker.stopWalking();
							}
							
							nextFrameWorldTime += .04;
						}
						walker.notify(walker.timeToNotify);
					}
					
					isAlive = !walker.hasFinishedWorking;
					var hasTakenDamage:Boolean = walker.health < aiMember.health;
					
					var mayFall:Boolean = isAlive && !hasTakenDamage;
				}
				
				//CONFIG::debug 
				//{ 
					//if (mayFall) Console.say(aiMember.name, "could fall to", walker.location.toString()); 
				//} 
				
				
				var jumper:TeamMember = TeamMember(aiMember.clone());
				jumper.isGhost = true;
				
				if (!jumper.isWalking)
				{
					jumper.startWalking(aiMemberMoveDirection);
				}
				
				jumper.startJumping();
				jumper.notify(jumper.timeToNotify);
				jumper.stopJumping();
				
				nextFrameWorldTime = aiMember.world.currentTime + .04;
				
				while (!jumper.hasFinishedWorking)
				{
					if (jumper.timeToNotify > nextFrameWorldTime)
					{
						if (!jumper.hasBeenFlying && jumper.testIfLanded()) break;
						
						if (jumper.isWalking && jumper.wayPoints.length)
						{
							jumper.stopWalking();
						}
						
						nextFrameWorldTime += .04;
					}
					jumper.notify(jumper.timeToNotify);
				}
				
				isAlive = !jumper.hasFinishedWorking;
				hasTakenDamage = jumper.health < aiMember.health;
				movedInTheRightDirection = (jumper.location.x - aiMember.location.x) * aiMemberMoveDirection >= aiMember.staminaBurnPerJump / aiMember.staminaBurnPerPixel;
				var gotHigher:Boolean = jumper.location.y < aiMember.location.y - aiMember.staminaBurnPerJump / aiMember.staminaBurnPerPixel / 4;
				
				var mayJump:Boolean = isAlive && (movedInTheRightDirection || gotHigher) && !hasTakenDamage;
				
				//CONFIG::debug 
				//{ 
					//if (mayJump) Console.say(aiMember.name, "could jump to", jumper.location.toString()); 
				//} 
				
				if (aiMember.stamina <= aiMemberMinStamina || (!mayWalk && !mayFall && !mayJump) || Program.mbToP.humanIsBored)
				{
					//CONFIG::debug 
					//{
						//if (aiMember.stamina <= aiMemberMinStamina) Console.say(aiStep, ":", aiMember.name, "is out of stamina... stopping",aiMemberMoveDirection == 1?"right.":"left.");
						//else if (!mayWalk && !mayFall && !mayJump) Console.say(aiStep, ":", aiMember.name, "is out of options... stopping",aiMemberMoveDirection == 1?"right.":"left.");
						//else if (Program.mbToP.humanIsBored) Console.say(aiStep, ":", aiMember.name, "made human bored... stopping",aiMemberMoveDirection == 1?"right.":"left.");
					//}
					
					if (aiMemberMoveDirection == 1) Program.mbToP.rightStopRequested = true;
					else Program.mbToP.leftStopRequested = true;
					
					if (aiMember.stamina && firstStep)
					{
						aiMemberMoveDirection = -aiMemberMoveDirection;
						
						//CONFIG::debug { Console.say(aiStep, ":", aiMember.name, "has stamina left... turning round", aiMemberMoveDirection == 1?"right.":"left."); }
						
						return;
					}
					
					//CONFIG::debug { Console.say(aiStep, ":", aiMember.name, "is finished... switching."); }
					aiMembersMoved.push(aiMember);
					Program.mbToP.switchMemberRequested = true;
					
					return;
				}
				
				if (!aiMember.isWalking)
				{
					//CONFIG::debug { Console.say(aiStep, ":", aiMember.name, mayWalk?"may walk":"",mayFall?"may fall":"","is not walking... starting", aiMemberMoveDirection == 1?"right.":"left."); }
					if (aiMemberMoveDirection == 1) Program.mbToP.rightStartRequested = true;
					else Program.mbToP.leftStartRequested = true;
				}
				
				if (mayJump)
				{
					//CONFIG::debug { Console.say(aiStep, ":", aiMember.name, "may jump... jumping."); }
					Program.mbToP.upStartRequested = true;
				}
			}
		}
		
		override public function getHelpSectionID():String 
		{
			if (type == TYPE_NORMAL) return "#moving_round";
			return "";
		}
	}

}