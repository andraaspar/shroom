package com.pirkadat.logic 
{
	import com.pirkadat.logic.level.GeneratedLevel;
	import com.pirkadat.logic.level.ILevel;
	import com.pirkadat.logic.level.PaintedLevel;
	import com.pirkadat.ui.*;
	import com.pirkadat.ui.windows.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	public class Game
	{
		public static const STATE_CREATED:int = 0;
		public static const STATE_SETUP:int = 1;
		public static const STATE_LOADING:int = 2;
		public static const STATE_SETTLE:int = 3;
		public static const STATE_ROUNDS:int = 4;
		public static const STATE_OVER:int = 5;
		
		public var state:int;
		
		public var setupWindow:Window;
		public var progressWindow:MultiProgressWindow;
		public var gameWindow:Window;
		
		public var world:World;
		public var teams:Vector.<Team>;
		public var bulletTypes:Vector.<Class> = new <Class>[ShootingStar, Doughnut, TeslaBall, DawnBall];
		
		public var teamCounter:int;
		
		public var membersPerTeam:int = 3;
		
		public var editedTeam:Team;
		
		public var teamQueue:Vector.<Team>;
		
		public var prevFastestObject:WorldObject;
		
		public var colourPool:Vector.<int> = new <int>[0xff0000, 0xff7f00, 0xffff00, 0x40ff00, 0x008000, 0x80ffff, 0x007fff, 0x0030be, 0x7f00ff, 0xff007f, 0xff99cc, 0xffffff, 0x666666];
		public var characterAppearances:Vector.<CharacterAppearance>;
		public var availableCharacterAppearances:Vector.<CharacterAppearance>;
		public var availableCharacterAppearancesCount:int;
		
		public var interestingObjects:Dictionary;
		
		public var gongSoundAssetID:int = 11;
		public var cheerSoundAssetID:int = 13;
		public var shunpoPopAssetID:int = 16;
		public var shunpoPopVisualAssetID:int = 52;
		
		public var level:ILevel;
		
		public var moveRoundClasses:Vector.<Class> = new <Class>[MoveRound, MoonwalkRound, DoubleMoveRound, ShunpoRound];
		public var shootRoundClasses:Vector.<Class> = new <Class>[ShootRound, DoughnutRound, TeslaRound, DawnRound];
		public var roundWeights:Dictionary;
		public var moveRoundsPool:Vector.<Class> = new <Class>[];
		public var shootRoundsPool:Vector.<Class> = new <Class>[];
		public var roundFillSwitch:Boolean;
		public var rounds:Vector.<GameRound> = new Vector.<GameRound>();
		public var currentRound:GameRound;
		
		public function Game(oldGame:Game = null) 
		{
			world = new World();
			teams = new Vector.<Team>();
			interestingObjects = new Dictionary();
			
			if (oldGame)
			{
				if (oldGame.level is PaintedLevel) level = new PaintedLevel( -1, PaintedLevel(oldGame.level));
				else level = new GeneratedLevel();
			}
			else
			{
				level = new PaintedLevel();
			}
			
			characterAppearances = getAllPossibleCharacterAppearances();
			availableCharacterAppearances = filterCharacterAppearances(characterAppearances);
			availableCharacterAppearancesCount = availableCharacterAppearances.length;
			
			if (oldGame)
			{
				// Rounds
				
				roundWeights = oldGame.roundWeights;
				
				// Teams
				
				for each (var oldTeam:Team in oldGame.teams)
				{
					addTeam(oldTeam.spawnNew(availableCharacterAppearances));
				}
				membersPerTeam = oldGame.membersPerTeam;
			}
			else // No oldGame or not the same hasPack1
			{
				// Rounds
				
				roundWeights = new Dictionary();
				
				roundWeights[MoveRound] = 5;
				roundWeights[MoonwalkRound] = 2;
				roundWeights[DoubleMoveRound] = 2;
				roundWeights[ShunpoRound] = 1;
				
				roundWeights[ShootRound] = 1;
				roundWeights[DoughnutRound] = 1;
				roundWeights[TeslaRound] = 1;
				roundWeights[DawnRound] = 1;
				
				// Teams
				
				addTeam();
				addTeam();
				editedTeam.controller = Team.CONTROLLER_AI;
			}
		}
		
		public function getRequiredAssetIDs():Vector.<int>
		{
			var result:Vector.<int> = new <int>[gongSoundAssetID, cheerSoundAssetID, shunpoPopAssetID, shunpoPopVisualAssetID];
			
			result = result.concat(level.getRequiredAssetIDs());
			
			var wo:WorldObject;
			
			for each (var bullet:Class in bulletTypes)
			{
				wo = new bullet();
				result = result.concat(wo.getAssetIDs());
			}
			
			for each (var team:Team in teams)
			{
				for each (wo in team.members)
				{
					result = result.concat(wo.getAssetIDs());
				}
			}
			
			return result;
		}
		
		public function startAssetDownloads(source:Vector.<int>):void
		{
			for each (var i:int in source)
			{
				Program.assetLoader.loadAssetByID(i);
			}
			if (Program.assetLoader.activeDownloads == 0) Program.mbToP.allAssetsDownloaded = true;
		}
		
		protected function setState(value:int):void
		{
			state = value;
			
			switch (state)
			{
				case STATE_SETUP:
					Console.say("Game setup started...");
					Gui.showStartWindow();
					break;
				case STATE_LOADING:
					Console.say("Game loading...");
					Gui.windowManager.removeAllWindows();
					matchTeamMemberCount();
					fillRoundPools();
					startAssetDownloads(getRequiredAssetIDs());
					progressWindow = Gui.showProgressWindow(["Loading assets","Placing objects"]);
					break;
				case STATE_SETTLE:
					Console.say("Members placed, settling...");
					Gui.showWorldWindow();
					Program.mbToUI.newState = MBToUI.STATE_OVERVIEW;
					Program.mbToUI.newMessageBoxText = "Take a look around, and press DONE when you're ready!";
					Program.mbToUI.newDoneButtonText = "DONE";
					break;
				case STATE_ROUNDS:
					Console.say("Starting rounds.");
					fillRounds();
					currentRound = rounds.shift();
					fillRounds();
					Gui.showTeamQueueWindow();
					break;
				case STATE_OVER:
					Console.say("Game over!");
					Program.mbToUI.newState = MBToUI.STATE_OVERVIEW;
					Program.mbToUI.newMessageBoxText = "Game over!";
					Program.mbToUI.newDoneButtonText = "MAIN MENU";
					for each (var team:Team in teams)
					{
						if (team.checkIfAlive())
						{
							Console.say("And the winner is:", team.name);
							Program.mbToUI.newMessageBoxText = team.name + " wins!";
							Program.mbToUI.newSounds.push(new SoundRequest(cheerSoundAssetID, null, null));
							Program.mbToUI.winner = team;
						}
					}
					break;
			}
		}
		
		public function getHelpSection(section:String):void
		{
			navigateToURL(new URLRequest("help.html"+section), "_blank");
		}
		
		public function execute():void
		{
			switch (state)
			{
				case STATE_CREATED:
					setState(STATE_SETUP);
				case STATE_SETUP:
					if (Program.mbToP.helpRequested) getHelpSection("#custom_games");
					if (Program.mbToP.addTeamRequested) addTeam();
					if (!isNaN(Program.mbToP.newEditTeamID)) editTeamByID(Program.mbToP.newEditTeamID);
					if (Program.mbToP.newEditTeamName != null) editedTeam.name = Program.mbToP.newEditTeamName;
					if (Program.mbToP.newTeamAppearance) setTeamAppearance(Program.mbToP.newTeamAppearance);
					if (!isNaN(Program.mbToP.newTeamController)) editedTeam.controller = Program.mbToP.newTeamController;
					if (!isNaN(Program.mbToP.newTeamAILevel)) editedTeam.aiLevel = Program.mbToP.newTeamAILevel;
					if (Program.mbToP.removeTeamRequested) removeEditedTeam();
					if (Program.mbToP.membersPerTeam)
					{
						membersPerTeam = Math.max(1, Math.min(99, Program.mbToP.membersPerTeam));
						Program.mbToUI.membersPerTeam = membersPerTeam;
					}
					if (Program.mbToP.newSelectedLevel)
					{
						if (level) level.onDestroy();
						level = new PaintedLevel(int(Program.mbToP.newSelectedLevel.@id), level as PaintedLevel);
						Program.mbToUI.newLevel = true;
					}
					else if (Program.mbToP.newRandomLevelRequested)
					{
						if (level) level.onDestroy();
						level = new GeneratedLevel();
						Program.mbToUI.newLevel = true;
					}
					if (Program.mbToP.weightModifyRound) setRoundWeight(Program.mbToP.weightModifyRound, Program.mbToP.newRoundWeight);
					if (Program.mbToP.allAssetsDownloaded && level.getIsLoadingPreview())
					{
						level.onPreviewDownloaded();
					}
					if (Program.mbToP.gameStartRequested)
					{
						setState(STATE_LOADING);
					}
					else
					{
						break;
					}
				case STATE_LOADING:
					progressWindow.setProgress(0,Program.assetLoader.getProgress());
					if (Program.mbToP.allAssetsDownloaded)
					{
						Console.say("Game assets loaded!");
						start();
					}
				break;
				case STATE_SETTLE:
					if (Program.mbToP.helpRequested) getHelpSection("#navigating_the_game_window");
					if (checkIfDrawn())
					{
						Console.say("Placing phase: game drawn.");
						setState(STATE_OVER);
						return;
					}
					if (Program.mbToP.endTurnRequested)
					{
						if (world.checkIfSleeping())
						{
							if (checkIfOver())
							{
								Console.say("Placing phase: game won.");
								setState(STATE_OVER);
							}
							else
							{
								setState(STATE_ROUNDS);
							}
						}
					}
					
					world.execute();
				break;
			case STATE_ROUNDS:
					if (Program.mbToP.helpRequested) getHelpSection(currentRound.getHelpSectionID());
					currentRound.execute();
					
					world.execute();
					
					if (currentRound.state == GameRound.STATE_GAME_OVER)
					{
						setState(STATE_OVER);
						break;
					}
					else if (currentRound.state == GameRound.STATE_ENDED)
					{
						currentRound = rounds.shift();
						fillRounds();
					}
				break;
				case STATE_OVER:
					if (Program.mbToP.helpRequested) getHelpSection("");
					if (Program.mbToP.endTurnRequested)
					{
						Program.mbToP.gameDestroyRequested = true;
					}
					
					world.execute();
				break;
			}
		}
		
		protected function start():void 
		{
			world.terrain = level.getTerrain();
			
			world.forces.push(new Gravity());
			
			var objectsToPlace:Vector.<WorldObject> = new Vector.<WorldObject>();
			
			for each (var team:Team in teams)
			{
				for each (var member:TeamMember in team.members)
				{
					world.addWorldObject(member);
					objectsToPlace.push(member);
				}
			}
			
			var objectsToPlaceCount:int = objectsToPlace.length;
			
			var xDistance:Number = world.terrain.width / (objectsToPlace.length);
			var currentX:Number = xDistance / 2;
			
			Program.fastFakeThread.add(
				function():Boolean
				{
					Console.say(objectsToPlace.length);
					if (objectsToPlaceCount) progressWindow.setProgress(1, 1 - objectsToPlace.length / objectsToPlaceCount);
					var object:WorldObject = objectsToPlace.splice(int(Math.random() * objectsToPlace.length), 1)[0];
					var randomX:Number = currentX - xDistance / 2 + Math.random() * xDistance;
					var usableFloors:Vector.<Number> = object.findUsableFloors(randomX, -object.radius, world.terrain.height, false);
					
					if (!usableFloors.length
						|| (usableFloors[0] == 0
							&& usableFloors[1] == 0))
					{
						objectsToPlace.push(object);
					}
					else
					{
						object.location.x = randomX;
						object.location.y = usableFloors[int(Math.random() * usableFloors.length)];
					}
					
					currentX += xDistance;
					if (currentX > world.terrain.width) currentX = xDistance / 2;
					
					return Boolean(objectsToPlace.length);
				}
				, function():void
				{
					Gui.modalWindowManager.removeWindow(progressWindow);
					//Program.mbToUI.newLevel = true;
					
					setState(STATE_SETTLE);
				}
			);
		}
		
		public function checkIfOver():Boolean
		{
			var teamsAlive:int = 0;
			for each (var team:Team in teams)
			{
				if (team.checkIfAlive()) teamsAlive++;
			}
			Console.say("Teams alive:",teamsAlive);
			return teamsAlive <= 1;
		}
		
		public function checkIfDrawn():Boolean
		{
			for each (var team:Team in teams)
			{
				if (team.checkIfAlive()) return false;
			}
			return true;
		}
		
		protected function addTeam(exisingTeam:Team = null):void 
		{
			if (!availableCharacterAppearancesCount)
			{
				Gui.prompt("Cannot create another team. No more appearances available.");
				return;
			}
			availableCharacterAppearancesCount--;
			
			var newTeam:Team;
			if (exisingTeam) newTeam = exisingTeam;
			else newTeam = new Team();
			var id:int = teams.push(newTeam) - 1;
			
			if (!newTeam.characterAppearance)
			{
				var appearanceID:int = Math.floor(Math.random() * availableCharacterAppearances.length);
				while (true)
				{
					var appearance:CharacterAppearance = availableCharacterAppearances[appearanceID];
					if (appearance.assignedTo == null) break;
					appearanceID--;
					if (appearanceID < 0) appearanceID = availableCharacterAppearances.length - 1;
				}
				newTeam.characterAppearance = appearance;
				appearance.assignedTo = newTeam;
			}
			if (!exisingTeam)
			{
				newTeam.name = "Team " + (++teamCounter);
				if (editedTeam)
				{
					newTeam.controller = editedTeam.controller;
					newTeam.aiLevel = editedTeam.aiLevel;
				}
			}
			
			editTeamByID(id);
		}
		
		protected function editTeamByID(id:int):void 
		{
			if (id >= teams.length
				|| id < 0)
			{
				editedTeam = null;
			}
			else
			{
				editedTeam = teams[id];
			}
		}
		
		protected function matchTeamMemberCount():void
		{
			for each (var team:Team in teams)
			{
				while (team.members.length < membersPerTeam)
				{
					var newTeamMember:TeamMember = new TeamMember(world, team);
					var id:int = team.members.push(newTeamMember) - 1;
				}
			}
		}
		
		protected function removeEditedTeam():void 
		{
			if (!editedTeam) return;
			if (teams.length <= 2) return;
			
			var id:int = teams.indexOf(editedTeam);
			var removedTeam:Team = teams.splice(id, 1)[0];
			removedTeam.characterAppearance.assignedTo = null;
			availableCharacterAppearancesCount++;
			
			editTeamByID(Math.max(0, id - 1));
		}
		
		protected function changeTeamName(newName:String):void 
		{
			editedTeam.name = newName;
		}
		
		public function destroy():void 
		{
			level.onDestroy();
		}
		
		protected function fillRounds():void
		{
			var rc:Class;
			while (rounds.length < 3)
			{
				if (roundFillSwitch = !roundFillSwitch
					&& moveRoundsPool.length > 0)
					rc = moveRoundsPool[int(Math.random() * moveRoundsPool.length)];
				else rc = shootRoundsPool[int(Math.random() * shootRoundsPool.length)];
				rounds.push(new rc(this));
			}
			
			Program.mbToUI.newGameRounds = (new <GameRound>[currentRound]).concat(rounds);
		}
		
		public function spawnNew():Game
		{
			return new Game(this);
		}
		
		protected function getAllPossibleCharacterAppearances():Vector.<CharacterAppearance>
		{
			var result:Vector.<CharacterAppearance> = new Vector.<CharacterAppearance>();
			var characterNodes:XMLList = Program.assetLoader.assetInfo.c;
			for each (var characterNode:XML in characterNodes)
			{
				for (var i:int = 0; i < colourPool.length; i++)
				{
					result.push(new CharacterAppearance(characterNode, colourPool[i], i));
				}
			}
			return result;
		}
		
		protected function filterCharacterAppearances(input:Vector.<CharacterAppearance>):Vector.<CharacterAppearance>
		{
			var result:Vector.<CharacterAppearance> = new Vector.<CharacterAppearance>();
			for each (var ca:CharacterAppearance in input)
			{
				if (ca.type == 0) result.push(ca);
			}
			return result;
		}
		
		protected function setTeamAppearance(ca:CharacterAppearance):void
		{
			editedTeam.setCharacterAppearance(ca);
		}
		
		protected function fillRoundPools():void
		{
			for each (var c:Class in moveRoundClasses)
			{
				for (var i:int = 0, n:int = roundWeights[c]; i < n; i++)
				{
					moveRoundsPool.push(c);
				}
			}
			for each (c in shootRoundClasses)
			{
				for (i = 0, n = roundWeights[c]; i < n; i++)
				{
					shootRoundsPool.push(c);
				}
			}
		}
		
		protected function setRoundWeight(roundClass:Class, newWeight:int):void
		{
			if (newWeight == 0
				&& shootRoundClasses.indexOf(roundClass) > -1)
			{
				var thisIsTheLastOne:Boolean = true;
				for each (var c:Class in shootRoundClasses)
				{
					if (c !== roundClass
						&& roundWeights[c] > 0)
					{
						thisIsTheLastOne = false;
						break;
					}
				}
				if (thisIsTheLastOne)
				{
					Gui.prompt("A game must have at least one kind of shooting round. You cannot remove the last one.");
					return;
				}
			}
			
			roundWeights[roundClass] = Math.max(0, Math.min(10, Program.mbToP.newRoundWeight));
			Program.mbToUI.roundWeightsUpdated = true;
		}
	}

}