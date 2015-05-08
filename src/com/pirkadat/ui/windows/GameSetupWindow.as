package com.pirkadat.ui.windows 
{
	import com.pirkadat.display.*;
	import com.pirkadat.geom.MultiplierColorTransform;
	import com.pirkadat.logic.*;
	import com.pirkadat.ui.*;
	import flash.events.*;
	
	public class GameSetupWindow extends Window 
	{
		public function GameSetupWindow() 
		{
			super(getContent(), new DynamicText("Game Setup"), true, true, true, true);
		}
		
		private function getContent():TrueSize
		{
			var mainRow:Row = new Row(false, 18);
			mainRow.name = "mainRow";
			mainRow.spaceRuleY = SPACE_RULE_TOP_DOWN_MAXIMUM;
			
			var columnsRow:Row = new Row(true, 18);
			mainRow.addChild(columnsRow);
			
			var levelSelector:LevelSelector = new LevelSelector();
			columnsRow.addChild(levelSelector);
			
			columnsRow.addChild(new Separator());
			
			var teamConfig:TeamConfig = new TeamConfig();
			columnsRow.addChild(teamConfig);
			
			columnsRow.addChild(new Separator());
			
			var roundWeightSetter:RoundWeightSetter = new RoundWeightSetter();
			columnsRow.addChild(roundWeightSetter);
			
			mainRow.addChild(new Separator());
			
			var startRow:Row = new Row(true, 6);
			mainRow.addChild(startRow);
			
			var helpButton:Button = new Button(new DynamicText("Help"));
			startRow.addChild(helpButton);
			helpButton.addEventListener(MouseEvent.CLICK, function(e:Event):void { Program.mbToP.helpRequested = true; } );
			
			var startButton:Button = new Button(new HTMLText("<p><l>Start game!</l></p>"));
			startRow.addChild(startButton);
			startButton.frame.transform.colorTransform = new MultiplierColorTransform(0x00cc00);
			startButton.addEventListener(MouseEvent.CLICK, onStartButtonClicked);
			
			return new Extender(mainRow);
		}
		
		protected function onStartButtonClicked(e:Event):void
		{
			Program.mbToP.gameStartRequested = true;
			dispatchEvent(new Event(EVENT_CLOSE_REQUESTED, true));
		}
	}

}