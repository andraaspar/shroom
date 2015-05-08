package com.pirkadat.logic 
{
	import com.pirkadat.ui.Console;
	import com.pirkadat.ui.Gui;
	import flash.geom.Point;
	public class ShunpoRound extends GameRound
	{
		public static const STATE_STARTED:int = 0;
		public static const STATE_WAIT_FOR_TEAM:int = 1;
		public static const STATE_MOVE:int = 2;
		public static const STATE_SETTLE:int = 3;
		
		public var timeLimit:Number;
		
		public var teamMembersMoved:Vector.<TeamMember>;
		
		public var directions:Vector.<Point> = new <Point>[new Point(-1,-1), new Point(1,-1), new Point(1,1), new Point(-1,1)];
		public var justBelow:Point = new Point(0, 1);
		
		public var shunpoOptions:Vector.<Point>;
		
		public var aiStep:int;
		public var aiMembersMoved:Vector.<TeamMember>;
		public var aiMember:TeamMember;
		
		public function ShunpoRound(game:Game) 
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
					Console.say("Shunpo round: waiting for team.");
					timeLimit = game.world.currentTime + 2.9;
					while (true)
					{
						selectNextTeam();
						if (!selectedTeam)
						{
							Console.say("Shunpo round: ended.");
							setState(STATE_ENDED);
							return;
						}
						if (selectedTeam.checkIfAlive()) break;
					}
					if (selectedTeam.selectedMember.health <= 0) selectedTeam.selectNextMember();
					teamMembersMoved = new Vector.<TeamMember>();
					
					Program.mbToUI.newState = MBToUI.STATE_SHUNPO;
					calculateShunpoOptions();
					Program.mbToUI.newMessageBoxText = selectedTeam.name + " is next!";
					Program.mbToUI.newDoneButtonText = "";
					
					Gui.showTeamWindow();
					
					// No execute to prevent previous team's commands affecting this team
				break;
				case STATE_MOVE:
					Console.say("Shunpo round: team is moving.");
					
					aiStep = 0;
					
					Program.mbToUI.newMessageBoxText = selectedTeam.name + " is using shunpo!";
					if (selectedTeam.controller == Team.CONTROLLER_HUMAN) Program.mbToUI.newDoneButtonText = "FINISHED MOVING";
					else Program.mbToUI.newDoneButtonText = "I AM BORED";
					
					// No execute necessary, it falls through
				break;
				case STATE_SETTLE:
					Console.say("Shunpo round: settling.");
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
					Console.say("Shunpo round: started.");
					teamQueue = getSortedTeams(game.teams);
					Program.mbToUI.newTeamQueue = teamQueue.concat();
					Program.mbToUI.newHelpImageAssetID = 200;
					setState(STATE_WAIT_FOR_TEAM);
				break;
				case STATE_WAIT_FOR_TEAM:
					if (game.world.currentTime >= timeLimit
						|| Program.mbToP.shunpoRequested
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
						Console.say("Shunpo round: selected team died.");
						setState(STATE_SETTLE);
						return;
					}
					if (selectedTeam.selectedMember.health <= 0)
					{
						Console.say("Shunpo round: selected member died.");
						selectedTeam.selectNextMember();
						break;
					}
					
					if (selectedTeam.controller == Team.CONTROLLER_AI)
					{
						doAI();
					}
					
					if (Program.mbToP.shunpoRequested)
					{
						selectedTeam.selectedMember.location = selectedTeam.selectedMember.location.add(Program.mbToP.shunpoRequested);
						Program.mbToUI.newSounds.push(new SoundRequest(game.shunpoPopAssetID, null, selectedTeam.selectedMember.location));
						teamMembersMoved.push(selectedTeam.selectedMember);
						calculateShunpoOptions();
					}
					if (Program.mbToP.switchMemberRequested)
					{
						selectedTeam.selectNextMember();
						calculateShunpoOptions();
					}
					if (Program.mbToP.switchMemberReverseRequested)
					{
						selectedTeam.selectNextMember(true);
						calculateShunpoOptions();
					}
					if (Program.mbToP.newSelectedTeamMember)
					{
						selectedTeam.selectMember(Program.mbToP.newSelectedTeamMember);
						calculateShunpoOptions();
					}
					if (Program.mbToP.endTurnRequested)
					{
						Console.say("Shunpo round: user requested end.");
						setState(STATE_SETTLE);
						return;
					}
				break;
				case STATE_SETTLE:
					if (game.world.checkIfSleeping())
					{
						if (game.checkIfOver())
						{
							Console.say("Shunpo round: game over.");
							setState(STATE_GAME_OVER);
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
			return "Shunpo Round";
		}
		
		protected function calculateShunpoOptions():void
		{
			var results:Vector.<Point> = new Vector.<Point>();
			var offset:Point = new Point();
			var location:Point;
			var direction:Point;
			
			if (teamMembersMoved.indexOf(selectedTeam.selectedMember) == -1)
			for (var directionID:int = 0; directionID < directions.length; directionID++)
			{
				direction = directions[directionID];
				
				for (var multiplier:Number = selectedTeam.selectedMember.radius * 2; true; multiplier += .25)
				{
					offset.x = direction.x * multiplier;
					offset.y = direction.y * multiplier;
					
					location = selectedTeam.selectedMember.location.add(offset);
					
					if (location.x < -selectedTeam.selectedMember.radius
						|| location.x > game.world.terrain.width + selectedTeam.selectedMember.radius
						|| location.y < -selectedTeam.selectedMember.radius
						|| location.y > game.world.terrain.height + selectedTeam.selectedMember.radius)
						break;
						
					if (!selectedTeam.selectedMember.getHitTest(location))
					{
						if (selectedTeam.selectedMember.getHitTest(location.add(justBelow)))
						{
							results.push(offset.clone());
							multiplier += selectedTeam.selectedMember.radius;
						}
					}
				}
			}
			
			shunpoOptions = Program.mbToUI.newShunpoOptions = results;
		}
		
		protected function doAI():void
		{
			if (aiStep == 0)
			{
				aiMembersMoved = new Vector.<TeamMember>();
				aiMember = null;
			}
			
			aiStep++;
			
			if (aiMember != selectedTeam.selectedMember)
			{
				aiMember = selectedTeam.selectedMember;
			}
			
			if (aiMembersMoved.indexOf(aiMember) != -1 || Program.mbToP.humanIsBored)
			{
				Program.mbToP.endTurnRequested = true;
				return;
			}
			
			if (shunpoOptions.length) Program.mbToP.shunpoRequested = shunpoOptions[int(Math.random() * shunpoOptions.length)];
			Program.mbToP.switchMemberRequested = true;
			aiMembersMoved.push(aiMember);
		}
		
		override public function getHelpSectionID():String 
		{
			return "#shunpo_round";
		}
	}

}