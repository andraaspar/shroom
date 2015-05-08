package com.pirkadat.logic 
{
	public class DoubleMoveRound extends MoveRound
	{
		
		public function DoubleMoveRound(game:Game) 
		{
			super(game);
			
			type = TYPE_DOUBLE;
		}
		
		override public function getName():String 
		{
			return "Running Round";
		}
		
		override public function getHelpSectionID():String 
		{
			return "#running_round";
		}
	}

}