package com.pirkadat.logic 
{
	import flash.geom.Point;
	public class MBToP
	{
		public var newGameRequested:Boolean;
		public var newQuickGameRequested:Boolean;
		public var gameDestroyRequested:Boolean;
		
		public var gameStartRequested:Boolean;
		
		public var assetLoaderReady:Boolean;
		public var allAssetsDownloaded:Boolean;
		
		public var leftStartRequested:Boolean;
		public var leftStopRequested:Boolean;
		public var rightStartRequested:Boolean;
		public var rightStopRequested:Boolean;
		public var upStartRequested:Boolean;
		public var upStopRequested:Boolean;
		public var downStartRequested:Boolean;
		public var downStopRequested:Boolean;
		public var special1StartRequested:Boolean;
		public var special1StopRequested:Boolean;
		public var newBounceCount:Number;
		public var fire1StartRequested:Boolean;
		public var fire1StopRequested:Boolean;
		public var switchMemberRequested:Boolean;
		public var switchMemberReverseRequested:Boolean;
		public var endTurnRequested:Boolean;
		public var humanIsBored:Boolean;
		public var iAmHere:Boolean;
		public var shunpoRequested:Point;
		
		public var newAim:Number;
		public var newFacing:int;
		public var newPowerMultiplier:Number;
		
		public var newSelectedLevel:XML;
		public var newRandomLevelRequested:Boolean;
		
		public var weightModifyRound:Class;
		public var newRoundWeight:int;
		
		public var addTeamRequested:Boolean;
		public var newEditTeamID:Number;
		public var newEditTeamName:String;
		public var removeTeamRequested:Boolean;
		public var newTeamController:Number;
		public var newTeamAILevel:Number;
		
		public var addTeamMemberRequested:Boolean;
		public var newEditTeamMemberID:Number;
		public var removeTeamMemberRequested:Boolean;
		public var newSelectedTeamMember:TeamMember;
		
		public var newWalkingSpeedMultiplier:Number;
		
		public var membersPerTeam:int;
		
		public var newTeamAppearance:CharacterAppearance;
		
		public var helpRequested:Boolean;
		
		public function MBToP() 
		{
			
		}
		
	}

}