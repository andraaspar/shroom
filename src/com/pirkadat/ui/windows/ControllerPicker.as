package com.pirkadat.ui.windows 
{
	import com.pirkadat.display.*;
	import com.pirkadat.logic.*;
	import com.pirkadat.ui.*;
	import flash.display.*;
	import flash.events.*;
	public class ControllerPicker extends Window 
	{
		public var mainRow:Row;
		public var controller:int = -1;
		public var aiLevel:int = -1;
		
		public function ControllerPicker() 
		{
			super(getContent(), new DynamicText("Controller picker"), true, true, true, true);
		}
		
		protected function getContent():ITrueSize
		{
			mainRow = new Row(false, 6);
			
			for each (var name:String in Team.controllerNames)
			{
				var aButton:Button = new Button(new DynamicText(name));
				mainRow.addChild(aButton);
				aButton.addEventListener(MouseEvent.CLICK, onButtonClicked);
			}
			
			var extender:Extender = new Extender(mainRow);
			
			return extender;
		}
		
		protected function onButtonClicked(e:Event):void
		{
			var index:int = mainRow.getChildIndex(DisplayObject(e.currentTarget));
			if (index < 0) return;
			if (index >= Team.CONTROLLER_AI)
			{
				Program.mbToP.newTeamAILevel = index - Team.CONTROLLER_AI;
				Program.mbToP.newTeamController = Team.CONTROLLER_AI;
			}
			else
			{
				Program.mbToP.newTeamController = index;
			}
			
			dispatchEvent(new Event(EVENT_CLOSE_REQUESTED, true));
		}
		
		override public function update():void 
		{
			if (Program.game.editedTeam.controller != controller
				|| Program.game.editedTeam.aiLevel != aiLevel)
			{
				var selection:int = controller + (controller == Team.CONTROLLER_AI ? aiLevel : 0);
				if (selection >= 0) Button(mainRow.getChildAt(selection)).setSelected(false);
				controller = Program.game.editedTeam.controller;
				aiLevel = Program.game.editedTeam.aiLevel;
				selection = controller + (controller == Team.CONTROLLER_AI ? aiLevel : 0);
				Button(mainRow.getChildAt(selection)).setSelected(true);
			}
			
			super.update();
		}
	}

}