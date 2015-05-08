package com.pirkadat.ui.windows 
{
	import com.pirkadat.display.*;
	import com.pirkadat.logic.*;
	import com.pirkadat.ui.*;
	
	public class TeamQueueWindow extends Window 
	{
		public var mainRow:Row;
		
		public function TeamQueueWindow() 
		{
			super(createContent(), new DynamicText("Team Queue"), true, false, true, true);
			
			alignmentX = 1;
			alignmentY = -1;
		}
		
		protected function createContent():ITrueSize
		{
			mainRow = new Row(false, 6);
			
			return new Extender(mainRow, 40, 10, 40, 10);
		}
		
		override public function update():void 
		{
			if (Program.mbToUI.newTeamQueue)
			{
				while (mainRow.numChildren) mainRow.removeChildAt(0);
				
				for each (var team:Team in Program.mbToUI.newTeamQueue)
				{
					var teamInfo:TeamInfo = new TeamInfo(team);
					mainRow.addChild(teamInfo);
				}
			}
			
			super.update();
		}
	}

}