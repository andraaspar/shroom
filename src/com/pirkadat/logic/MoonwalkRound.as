package com.pirkadat.logic 
{
	public class MoonwalkRound extends MoveRound
	{
		
		public function MoonwalkRound(game:Game) 
		{
			super(game);
			
			type = TYPE_MOONWALK;
		}
		
		override public function getName():String 
		{
			return "Moonwalking Round";
		}
		
		override public function getHelpSectionID():String 
		{
			return "#moonwalking_round";
		}
	}

}