package com.pirkadat.logic 
{
	public class DawnRound extends ShootRound
	{
		
		public function DawnRound(game:Game) 
		{
			super(game);
			
			type = TYPE_DAWN;
		}
		
		override public function getName():String 
		{
			return "Dawn Round";
		}
		
		override public function getHelpSectionID():String 
		{
			return "#dawn_round";
		}
	}

}