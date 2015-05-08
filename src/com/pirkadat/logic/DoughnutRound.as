package com.pirkadat.logic 
{
	public class DoughnutRound extends ShootRound
	{
		
		public function DoughnutRound(game:Game) 
		{
			super(game);
			
			type = TYPE_DOUGHNUT;
		}
		
		override public function getName():String 
		{
			return "Doughnut Round";
		}
		
		override public function getHelpSectionID():String 
		{
			return "#doughnut_round";
		}
	}

}