package com.pirkadat.ui 
{
	import com.pirkadat.display.ITrueSize;
	import com.pirkadat.logic.DawnRound;
	import com.pirkadat.logic.GameRound;
	import com.pirkadat.logic.Program;
	import com.pirkadat.shapes.FillStyle;
	import com.pirkadat.shapes.LineStyle;
	import com.pirkadat.shapes.RoundedBox;
	import flash.events.Event;
	import flash.events.MouseEvent;
	public class RoundWeightItem extends Extender 
	{
		private var currentWeightLabel:HTMLText;
		public var roundClass:Class;
		public var weight:int;
		
		private var forceUpdate:Boolean;
		
		public function RoundWeightItem(roundClass:Class) 
		{
			this.roundClass = roundClass;
			weight = Program.game.roundWeights[roundClass];
			
			super(createContent(), 10, 10, 10, 10);
			
			spaceRuleX = SPACE_RULE_TOP_DOWN_MINIMUM;
			forceUpdate = true;
		}
		
		protected function createContent():UIElement
		{
			var mainRow:Row = new Row(true, 18);
			
			var exampleRound:GameRound = GameRound(new roundClass(null));
			
			var label:HTMLText;
			label = new HTMLText("<p>"+exampleRound.getName());
			mainRow.addChild(label);
			
			var decreaseButton:Button = new Button(new HTMLText("<p><l>-"));
			decreaseButton.insetY = 5;
			mainRow.addChild(decreaseButton);
			decreaseButton.addEventListener(MouseEvent.CLICK, onDecreaseButtonClicked);
			
			currentWeightLabel = new HTMLText();
			mainRow.addChild(currentWeightLabel);
			mainRow.distances[currentWeightLabel] = 6;
			
			var increaseButton:Button = new Button(new HTMLText("<p><l>+"));
			increaseButton.insetY = 5;
			mainRow.addChild(increaseButton);
			mainRow.distances[increaseButton] = 6;
			increaseButton.addEventListener(MouseEvent.CLICK, onIncreaseButtonClicked);
			
			return mainRow;
		}
		
		override protected function createExtension():ITrueSize 
		{
			return new RoundedBox(10, new FillStyle(Colors.BLACK, .6), null, new LineStyle(1, Colors.WHITE));
		}
		
		override public function update():void 
		{
			if (Program.mbToUI.roundWeightsUpdated
				|| forceUpdate)
			{
				forceUpdate = false;
				
				setWeight(Program.game.roundWeights[roundClass]);
				sizeChanged = true;
			}
			
			super.update();
		}
		
		protected function setWeight(value:int):void
		{
			if (value <= 0) currentWeightLabel.htmlText = "<p><r>Disabled</r></p>";
			else currentWeightLabel.htmlText = "<p><g>x <l>" + value;
			
			weight = value;
		}
		
		protected function onDecreaseButtonClicked(e:Event):void
		{
			Program.mbToP.weightModifyRound = roundClass;
			Program.mbToP.newRoundWeight = weight - 1;
		}
		
		protected function onIncreaseButtonClicked(e:Event):void
		{
			Program.mbToP.weightModifyRound = roundClass;
			Program.mbToP.newRoundWeight = weight + 1;
		}
	}

}