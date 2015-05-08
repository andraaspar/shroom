package com.pirkadat.logic 
{
	public class TeslaRound extends ShootRound
	{
		
		public function TeslaRound(game:Game) 
		{
			super(game);
			
			type = TYPE_TESLA;
			allowsBounceChanges = false;
		}
		
		override public function getName():String 
		{
			return "Tesla Round";
		}
		
		override public function getHelpSectionID():String 
		{
			return "#tesla_round";
		}
	}

}