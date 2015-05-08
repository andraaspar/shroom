package com.pirkadat.logic 
{
	public class GameRound
	{
		public var game:Game;
		
		public var teamQueue:Vector.<Team>;
		public var selectedTeam:Team;
		
		public var state:int;
		
		public static const STATE_ENDED:int = 999;
		public static const STATE_GAME_OVER:int = 1000;
		
		public var allowsBounceChanges:Boolean;
		
		public function GameRound(game:Game) 
		{
			this.game = game;
		}
		
		public function execute():void
		{
			
		}
		
		protected function setStamina(value:Number = 1):void
		{
			for each (var member:TeamMember in selectedTeam.members)
			{
				member.restoreStaminaTo(value);
			}
		}
		
		protected function fire():void
		{
			for each (var team:Team in game.teams)
			{
				for each (var member:TeamMember in team.members)
				{
					member.fire();
				}
			}
		}
		
		protected function compareTeams(aTeam:Team, bTeam:Team):int
		{
			var aMembersCount:int = aTeam.getMembersAliveCount();
			var bMembersCount:int = bTeam.getMembersAliveCount();
			
			if (aMembersCount == bMembersCount)
			{
				var aHealth:int = aTeam.getHealth();
				var bHealth:int = bTeam.getHealth();
				if (aHealth == bHealth)
				{
					return game.teams.indexOf(aTeam) - game.teams.indexOf(bTeam);
				}
				return bHealth - aHealth;
			}
			
			return bMembersCount - aMembersCount;
		}
		
		protected function selectNextTeam():void
		{
			if (selectedTeam) selectedTeam.onDeselected();
			
			while (true)
			{
				selectedTeam = teamQueue.shift();
				if (!selectedTeam)
				{
					Program.mbToUI.newController = Team.CONTROLLER_HUMAN;
					return;
				}
				if (selectedTeam.checkIfAlive())
				{
					selectedTeam.onSelected();
					Program.mbToUI.teamSelectionChanged = true;
					Program.mbToUI.newSelectedTeam = selectedTeam;
					Program.mbToUI.newController = selectedTeam.controller;
					return;
				}
			}
		}
		
		protected function deselectTeam():void
		{
			if (selectedTeam) selectedTeam.onDeselected();
			
			selectedTeam = null;
			Program.mbToUI.teamSelectionChanged = true;
			Program.mbToUI.newSelectedTeam = null;
			Program.mbToUI.newController = Team.CONTROLLER_HUMAN;
		}
		
		protected function getSortedTeams(source:Vector.<Team>):Vector.<Team>
		{
			var result:Vector.<Team> = source.concat().sort(compareTeams);
			for (var i:int = result.length - 1; i >= 0; i--)
			{
				var team:Team = result[i];
				if (!team.checkIfAlive()) result.splice(i, 1);
			}
			return result;
		}
		
		public function getName():String
		{
			return "Game Round";
		}
		
		public function getHelpSectionID():String
		{
			return "";
		}
	}

}