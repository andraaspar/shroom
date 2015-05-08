package com.pirkadat.logic 
{
	import com.pirkadat.ui.Console;
	import flash.utils.Dictionary;
	
	public class Team
	{
		public static const CONTROLLER_HUMAN:int = 0;
		public static const CONTROLLER_AI:int = 1;
		
		public static const AI_EASY:int = 0;
		public static const AI_NORMAL:int = 1;
		public static const AI_HARD:int = 2;
		
		public static const controllerNames:Vector.<String> = new < String > ["Human", "Computer Easy", "Computer Normal", "Computer Hard"];
		
		public var selectedMember:TeamMember;
		public var selectedMemberIndex:int = -1;
		public var members:Vector.<TeamMember> = new Vector.<TeamMember>();
		
		public var name:String;
		
		public var isSelected:Boolean;
		public var controller:int;
		public var aiLevel:int;
		
		public var characterAppearance:CharacterAppearance;
		
		public function Team() 
		{
			
		}
		
		public function spawnNew(availableCharacterAppearances:Vector.<CharacterAppearance>):Team
		{
			var newTeam:Team = new Team();
			newTeam.name = name;
			newTeam.controller = controller;
			newTeam.aiLevel = aiLevel;
			var lastAvailableCA:CharacterAppearance;
			for each (var ca:CharacterAppearance in availableCharacterAppearances)
			{
				if (!ca.assignedTo)
				{
					lastAvailableCA = ca;
					if (ca.equals(characterAppearance)) break;
				}
			}
			if (lastAvailableCA) newTeam.setCharacterAppearance(lastAvailableCA);
			return newTeam;
		}
		
		public function selectNextMember(reversed:Boolean = false):void
		{
			var index:int = selectedMemberIndex;
			var aMember:TeamMember;
			
			while (true)
			{
				if (reversed)
				{
					index--;
					if (index < 0) index = members.length - 1;
				}
				else
				{
					index++;
					if (index >= members.length) index = 0;
				}
				
				aMember = members[index];
				if (aMember.health > 0)
				{
					if (selectedMember) selectedMember.onDeselected();
					
					selectedMember = aMember;
					selectedMemberIndex = index;
					selectedMember.onSelected();
					
					return;
				}
				
				if (index == selectedMemberIndex)
				{
					if (selectedMember) selectedMember.onDeselected();
					
					selectedMemberIndex = -1;
					selectedMember = null;
					
					return;
				}
			}
		}
		
		public function selectMemberByIndex(index:int):void
		{
			if (selectedMember) selectedMember.onDeselected();
			selectedMemberIndex = index;
			selectedMember = members[selectedMemberIndex];
			selectedMember.onSelected();
		}
		
		public function selectMember(member:TeamMember):void
		{
			var index:int = members.indexOf(member);
			if (index == -1) return;
			if (member.health <= 0) return;
			
			if (selectedMember) selectedMember.onDeselected();
			selectedMember = member;
			selectedMemberIndex = index;
			selectedMember.onSelected();
		}
		
		public function onSelected():void
		{
			if (!selectedMember) selectNextMember();
			selectedMember.onSelected();
			isSelected = true;
			setMovedStatus(false);
		}
		
		public function onDeselected():void
		{
			selectedMember.onDeselected();
			isSelected = false;
			setMovedStatus(true);
		}
		
		public function getMembersAliveCount():int
		{
			var result:int;
			for each (var member:TeamMember in members)
			{
				if (member.health > 0) result++;
			}
			return result;
		}
		
		public function getHealth():int
		{
			var health:int = 0;
			for each (var member:TeamMember in members)
			{
				if (member.health > 0) health += member.health;
			}
			return health;
		}
		
		public function checkIfAlive():Boolean
		{
			for each (var member:TeamMember in members)
			{
				if (member.health > 0) return true;
			}
			return false;
		}
		
		public function cycleController():void
		{
			if (controller == CONTROLLER_HUMAN)
			{
				controller = CONTROLLER_AI;
				aiLevel = AI_EASY;
			}
			else
			{
				aiLevel++;
				if (aiLevel > AI_HARD) controller = CONTROLLER_HUMAN;
			}
		}
		
		protected function setMovedStatus(flag:Boolean):void
		{
			for each (var member:TeamMember in members)
			{
				if (selectedMember != member) member.hasBeenSelected = flag;
			}
		}
		
		public function setCharacterAppearance(value:CharacterAppearance):void
		{
			if (value.assignedTo != null && value.assignedTo != this) throw new Error("Character appearance already used.");
			if (characterAppearance) characterAppearance.assignedTo = null;
			value.assignedTo = this;
			characterAppearance = value;
		}
	}
}