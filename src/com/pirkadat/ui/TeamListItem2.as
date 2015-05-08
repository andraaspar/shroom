package com.pirkadat.ui 
{
	import com.pirkadat.display.TrueSize;
	import com.pirkadat.geom.MultiplierColorTransform;
	import com.pirkadat.logic.AnimationRange;
	import com.pirkadat.logic.Program;
	import com.pirkadat.logic.Team;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	public class TeamListItem2 extends Button 
	{
		public static const EVENT_APPEARANCE_CHANGE_REQUESTED:String = "TeamListItem.Appearance.Change.Requested";
		public static const EVENT_CONTROLLER_CHANGE_REQUESTED:String = "TeamListItem.Controller.Change.Requested";
		
		public var appearanceButton:Button;
		public var teamAppearance:BitmapAnimation;
		public var nameField:InputField;
		public var controllerButton:Button;
		public var controllerLabel:DynamicText;
		
		public function TeamListItem2() 
		{
			super(getContent());
			
			spaceRuleX = SPACE_RULE_TOP_DOWN_MAXIMUM;
		}
		
		protected function getContent():TrueSize
		{
			var mainRow:Row = new Row(true, 6);
			mainRow.spaceRuleX = SPACE_RULE_TOP_DOWN_MAXIMUM;
			
			teamAppearance = new BitmapAnimation();
			teamAppearance.addLayer(Program.assetLoader.getAssetByID(1));
			teamAppearance.addLayer(Program.assetLoader.getAssetByID(0));
			
			appearanceButton = new Button(teamAppearance);
			mainRow.addChild(appearanceButton);
			appearanceButton.frame.alpha = .6;
			appearanceButton.addEventListener(MouseEvent.CLICK, onAppearanceButtonClicked);
			
			nameField = new InputField("Team:");
			nameField.spaceRuleX = SPACE_RULE_TOP_DOWN_MAXIMUM;
			mainRow.addChild(nameField);
			nameField.addEventListener(Event.CHANGE, onNameChanged);
			
			controllerButton = new Button(controllerLabel = new DynamicText());
			mainRow.addChild(controllerButton);
			controllerButton.frame.alpha = .6;
			controllerButton.addEventListener(MouseEvent.CLICK, onControllerButtonClicked);
			
			return mainRow;
		}
		
		public function useData(team:Team, selected:Boolean):void
		{
			setSelected(selected);
			
			teamAppearance.playRange(new AnimationRange(team.characterAppearance.characterID, team.characterAppearance.characterID), false);
			teamAppearance.layers[0].transform.colorTransform = new MultiplierColorTransform(team.characterAppearance.color);
			
			frame.transform.colorTransform = new MultiplierColorTransform(team.characterAppearance.color);
			
			nameField.input.field.text = team.name;
			
			var newLabel:String = Team.controllerNames[team.controller + (team.controller == Team.CONTROLLER_AI ? team.aiLevel : 0)];
			if (controllerLabel.text != newLabel)
			{
				controllerLabel.text = newLabel;
				controllerButton.sizeChanged = true;
			}
		}
		
		protected function onNameChanged(e:Event):void
		{
			Program.mbToP.newEditTeamName = nameField.input.field.text;
		}
		
		protected function onAppearanceButtonClicked(e:MouseEvent):void
		{
			dispatchEvent(new Event(EVENT_APPEARANCE_CHANGE_REQUESTED, true));
		}
		
		protected function onControllerButtonClicked(e:MouseEvent):void
		{
			dispatchEvent(new Event(EVENT_CONTROLLER_CHANGE_REQUESTED, true));
		}
	}

}