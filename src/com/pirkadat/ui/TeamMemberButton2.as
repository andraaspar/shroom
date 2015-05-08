package com.pirkadat.ui 
{
	import com.pirkadat.display.ITrueSize;
	import com.pirkadat.geom.MultiplierColorTransform;
	import com.pirkadat.logic.Program;
	import com.pirkadat.logic.Team;
	import com.pirkadat.logic.TeamMember;
	import flash.events.Event;
	import flash.events.MouseEvent;
	public class TeamMemberButton2 extends Button
	{
		public var teamMember:TeamMember;
		public var icon:SimpleTeamMemberAppearance;
		public var isDead:Boolean;
		
		public function TeamMemberButton2(teamMember:TeamMember) 
		{
			this.teamMember = teamMember;
			super(icon = new SimpleTeamMemberAppearance(teamMember));
			insetX = insetY = 20;
			frame.transform.colorTransform = new MultiplierColorTransform(teamMember.team.characterAppearance.color);
			
			addEventListener(MouseEvent.CLICK, onClicked);
		}
		
		override public function update():void 
		{
			setSelected(teamMember.isSelected);
			
			icon.update();
			
			super.update();
		}
		
		public function onClicked(e:MouseEvent):void
		{
			if (teamMember.team.controller == Team.CONTROLLER_HUMAN) Program.mbToP.newSelectedTeamMember = teamMember;
			if (teamMember.isSelected) dispatchEvent(new Event(WorldWindow.EVENT_FOLLOW_AOI_REQUESTED, true));
		}
	}

}