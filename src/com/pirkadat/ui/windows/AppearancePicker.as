package com.pirkadat.ui.windows 
{
	import com.pirkadat.display.*;
	import com.pirkadat.geom.*;
	import com.pirkadat.logic.*;
	import com.pirkadat.ui.*;
	import flash.events.*;
	import flash.utils.*;
	public class AppearancePicker extends Window 
	{
		public var mainRow:Row;
		public var appearancesLabel:DynamicText;
		public var appearancesRow:Row;
		public var colorsLabel:DynamicText;
		public var colorsRow:Row;
		
		public var selectedTeam:Team;
		public var selectedCharacterAppearance:CharacterAppearance;
		public var browsedCharacterID:int = -1;
		public var needsRefresh:Boolean;
		
		public var buttonToCharacterIDDict:Dictionary;
		public var buttonToCharacterAppearanceDict:Dictionary;
		
		public function AppearancePicker() 
		{
			super(getContent(), new DynamicText("Appearance picker"), true, true, true, true);
		}
		
		protected function getContent():ITrueSize
		{
			mainRow = new Row(false, 12);
			
			appearancesLabel = new DynamicText("Available characters:");
			mainRow.addChild(appearancesLabel);
			mainRow.distances[appearancesLabel] = 20;
			
			colorsLabel = new DynamicText("Available colors:");
			mainRow.addChild(colorsLabel);
			mainRow.distances[colorsLabel] = 20;
				
			var extender:Extender = new Extender(mainRow);
			
			return extender;
		}
		
		override public function update():void 
		{
			var teamSelectionChanged:Boolean = Program.game.editedTeam != selectedTeam;
			var selectedCAChanged:Boolean = selectedTeam && selectedCharacterAppearance != selectedTeam.characterAppearance;
			if (needsRefresh || teamSelectionChanged || selectedCAChanged)
			{
				refreshLayout(teamSelectionChanged || selectedCAChanged);
			}
			
			super.update();
		}
		
		protected function refreshLayout(matchTeamCharacterID:Boolean):void
		{
			needsRefresh = false;
			
			selectedTeam = Program.game.editedTeam;
			if (matchTeamCharacterID)
			{
				browsedCharacterID = selectedTeam.characterAppearance.characterID;
				selectedCharacterAppearance = selectedTeam.characterAppearance;
			}
			
			if (appearancesRow) mainRow.removeChild(appearancesRow);
			if (colorsRow) mainRow.removeChild(colorsRow);
			
			appearancesRow = new Row(true, 6);
			appearancesRow.spaceRuleX = SPACE_RULE_BOTTOM_UP;
			mainRow.addChildAt(appearancesRow, mainRow.getChildIndex(appearancesLabel) + 1);
			
			colorsRow = new Row(true, 6);
			colorsRow.spaceRuleX = SPACE_RULE_BOTTOM_UP;
			mainRow.addChildAt(colorsRow, mainRow.getChildIndex(colorsLabel) + 1);
			
			//
			
			buttonToCharacterIDDict = new Dictionary(true);
			buttonToCharacterAppearanceDict = new Dictionary(true);
			var lastID:int = -1;
			for each (var ca:CharacterAppearance in Program.game.characterAppearances)
			{
				if (ca.assignedTo == null || ca.assignedTo == selectedTeam)
				{
					if (ca.characterID != lastID)
					{
						lastID = ca.characterID;
						
						var buttonRow:Row = new Row(false, 6);
						
						var icon:BitmapAnimation = new BitmapAnimation();
						icon.addLayer(Program.assetLoader.getAssetByID(1));
						icon.addLayer(Program.assetLoader.getAssetByID(0));
						icon.playRange(new AnimationRange(ca.characterID, ca.characterID), false);
						buttonRow.addChild(icon);
						
						buttonRow.addChild(new DynamicText(ca.characterName));
						
						var appearanceButton:Button = new Button(buttonRow);
						appearancesRow.addChild(appearanceButton);
						appearanceButton.setSelected(ca.characterID == browsedCharacterID);
						appearanceButton.addEventListener(MouseEvent.CLICK, onAppearanceButtonClicked);
						buttonToCharacterIDDict[appearanceButton] = ca.characterID;
						if (ca.type == 1) appearanceButton.frame.transform.colorTransform = new MultiplierColorTransform(0xffcc00);
					}
					
					if (ca.characterID == browsedCharacterID)
					{
						var icon2:BitmapAnimation = new BitmapAnimation();
						icon2.addLayer(Program.assetLoader.getAssetByID(1));
						icon2.addLayer(Program.assetLoader.getAssetByID(0));
						icon2.playRange(new AnimationRange(ca.characterID, ca.characterID), false);
						icon2.layers[0].transform.colorTransform = new MultiplierColorTransform(ca.color);
						
						var colorButton:Button = new Button(icon2);
						colorsRow.addChild(colorButton);
						if (ca.assignedTo == selectedTeam) colorButton.setSelected(true);
						colorButton.addEventListener(MouseEvent.CLICK, onColorButtonClicked);
						buttonToCharacterAppearanceDict[colorButton] = ca;
						if (ca.type == 1) colorButton.frame.transform.colorTransform = new MultiplierColorTransform(0xffcc00);
					}
				}
			}
		}
		
		protected function onAppearanceButtonClicked(e:MouseEvent):void
		{
			setBrowsedCharacterID(buttonToCharacterIDDict[e.currentTarget]);
		}
		
		protected function onColorButtonClicked(e:MouseEvent):void
		{
			setSelectedCharacterAppearance(buttonToCharacterAppearanceDict[e.currentTarget]);
		}
		
		public function setBrowsedCharacterID(value:int):void
		{
			browsedCharacterID = value;
			needsRefresh = true;
		}
		
		public function setSelectedCharacterAppearance(value:CharacterAppearance):void
		{
			Program.mbToP.newTeamAppearance = value;
			dispatchEvent(new Event(EVENT_CLOSE_REQUESTED, true));
		}
	}

}