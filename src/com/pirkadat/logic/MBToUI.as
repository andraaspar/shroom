package com.pirkadat.logic 
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	public class MBToUI
	{
		public static const STATE_OVERVIEW:int = 1;
		public static const STATE_MOVE:int = 2;
		public static const STATE_AIM:int = 3;
		public static const STATE_FOCUS:int = 4;
		public static const STATE_SHUNPO:int = 5;
		public static const STATE_SHOOT:int = 6;
		
		public var newLevel:Boolean;
		
		public var showStartingPage:Boolean;
		
		public var newWorldObjects:Vector.<WorldObject> = new Vector.<WorldObject>();
		
		public var clearCanvas:Boolean;
		
		public var newMessageBoxText:String;
		public var newMessageBoxTime:int = -1;
		
		public var newState:int;
		
		public var newBounceCount:Number;
		
		public var memberSelectionChanged:Boolean;
		public var newSelectedMember:TeamMember;
		
		public var teamSelectionChanged:Boolean;
		public var newSelectedTeam:Team;
		
		public var newDoneButtonText:String;
		public var notSafeToDragMember:Boolean;
		
		public var objectsToBePlaced:Number;
		public var objectsRemainingToBePlaced:Number;
		
		public var newController:Number;
		
		public var membersPerTeam:int;
		
		public var newSounds:Vector.<SoundRequest> = new <SoundRequest>[];
		
		public var newPreviewAssetID:Number;
		
		public var allAssetsDownloaded:Boolean;
		public var levelPreviewDownloaded:Boolean;
		
		public var winner:Team;
		
		public var newTeamQueue:Vector.<Team>;
		
		public var newGameRounds:Vector.<GameRound>;
		
		public var newHelpImageAssetID:Number;
		
		public var newShunpoOptions:Vector.<Point>;
		
		public var newBulletSelected:Boolean;
		
		public var roundWeightsUpdated:Boolean;
		
		public function MBToUI() 
		{
			
		}
		
	}

}