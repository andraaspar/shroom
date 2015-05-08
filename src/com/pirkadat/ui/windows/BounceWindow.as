package com.pirkadat.ui.windows 
{
	import com.pirkadat.display.*;
	import com.pirkadat.logic.*;
	import com.pirkadat.ui.*;
	import flash.events.*;
	import flash.text.*;
	public class BounceWindow extends Window 
	{
		public var decreaseButton:Button;
		public var bounceCount:DynamicText;
		public var increaseButton:Button;
		protected var value:int = -1;
		
		public function BounceWindow() 
		{
			super(createContent(), new DynamicText("Bounce count"), true, false, true, true);
			setValue(0);
			alignmentY = 1;
		}
		
		protected function createContent():ITrueSize
		{
			var mainRow:Row = new Row(true, 6);
			
			decreaseButton = new Button(new DynamicText("-"));
			mainRow.addChild(decreaseButton);
			decreaseButton.addEventListener(MouseEvent.CLICK, onDecreaseButtonClicked);
			decreaseButton.spaceRuleY = SPACE_RULE_BOTTOM_UP;
			
			bounceCount = new DynamicText();
			bounceCount.wordWrap = true;
			bounceCount.width = 40;
			bounceCount.defaultTextFormat = new TextFormat(TextDefaults.globalDefaultTextFormat.font
				, 36
				, TextDefaults.globalDefaultTextFormat.color
				, null, null, null, null, null
				, TextFormatAlign.CENTER);
			mainRow.addChild(bounceCount);
			
			increaseButton = new Button(new DynamicText("+"));
			mainRow.addChild(increaseButton);
			increaseButton.addEventListener(MouseEvent.CLICK, onIncreaseButtonClicked);
			increaseButton.spaceRuleY = SPACE_RULE_BOTTOM_UP;
			
			return new Extender(mainRow, 40, 10, 40, 10);
		}
		
		public function setValue(value:int):void
		{
			if (value == this.value) return;
			
			this.value = value;
			bounceCount.text = value.toString();
		}
		
		override public function update():void 
		{
			setValue(Program.game.currentRound.selectedTeam.selectedMember.bounceCount);
			
			super.update();
		}
		
		protected function onIncreaseButtonClicked(e:Event):void
		{
			Program.mbToP.newBounceCount = value + 1;
		}
		
		protected function onDecreaseButtonClicked(e:Event):void
		{
			Program.mbToP.newBounceCount = value - 1;
		}
	}

}