package com.pirkadat.ui.windows 
{
	import com.pirkadat.display.*;
	import com.pirkadat.logic.*;
	import com.pirkadat.ui.*;
	
	public class TeamWindow extends Window 
	{
		public var team:Team;
		public var mainRow:Row;
		
		public function TeamWindow(team:Team) 
		{
			this.team = team;
			super(createContent(), new DynamicText(team.name), true, false, true, true);
			
			alignmentX = -1;
			alignmentY = 1;
		}
		
		protected function createContent():ITrueSize
		{
			mainRow = new Row(true, 6);
			
			for each (var teamMember:TeamMember in team.members)
			{
				mainRow.addChild(new TeamMemberButton2(teamMember));
			}
			
			return new Extender(mainRow,40,10,40,10);
		}
		
		override public function update():void 
		{
			for (var i:int = mainRow.numChildren - 1; i >= 0; i--)
			{
				var button:TeamMemberButton2 = TeamMemberButton2(mainRow.getChildAt(i));
				if (button.teamMember.hasFinishedWorking) mainRow.removeChildAt(i);
			}
			
			super.update();
		}
	}

}