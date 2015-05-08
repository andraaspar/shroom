package com.pirkadat.logic 
{
	public class CharacterAppearance 
	{
		public var characterID:int;
		public var characterName:String;
		public var type:int;
		public var animationAssetID:int;
		public var colorAssetID:int;
		public var inWaterSoundAssetID:int;
		public var hitSoundAssetID:int;
		public var color:int;
		public var colorNumber:int;
		public var assignedTo:Team;
		
		public function CharacterAppearance(characterNode:XML, color:int, colorNumber:int) 
		{
			characterID = characterNode.@id;
			characterName = characterNode.@n;
			type = characterNode.@t;
			animationAssetID = characterNode.@aa;
			colorAssetID = characterNode.@ca;
			inWaterSoundAssetID = characterNode.@iws;
			hitSoundAssetID = characterNode.@hs;
			
			this.color = color;
			this.colorNumber = colorNumber;
		}
		
		public function equals(ca:CharacterAppearance):Boolean
		{
			return (ca.characterID == characterID && ca.color == color);
		}
	}

}