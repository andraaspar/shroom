package com.pirkadat.ui.windows 
{
	import com.pirkadat.display.*;
	import com.pirkadat.ui.*;
	import flash.events.*;
	public class YesOrNoWindow extends Window 
	{
		public var onYes:Function;
		
		public function YesOrNoWindow(question:String, yesText:String, noText:String, onYes:Function, title:String) 
		{
			this.onYes = onYes;
			
			super(createContent(question, yesText, noText), new DynamicText(title), true, false, true, true);
		}
		
		private function createContent(question:String, yesText:String, noText:String):ITrueSize
		{
			var mainRow:Row = new Row(false, 12);
			
			var questionText:DynamicText = new DynamicText(question);
			mainRow.addChild(questionText);
			
			var buttonsRow:Row = new Row(true, 6);
			mainRow.addChild(buttonsRow);
			
			var yesButton:Button = new Button(new DynamicText(yesText));
			yesButton.spaceRuleX = SPACE_RULE_TOP_DOWN_MAXIMUM;
			buttonsRow.addChild(yesButton);
			yesButton.addEventListener(MouseEvent.CLICK, onYesButtonClicked);
			
			var noButton:Button = new Button(new DynamicText(noText));
			noButton.spaceRuleX = SPACE_RULE_TOP_DOWN_MAXIMUM;
			buttonsRow.addChild(noButton);
			noButton.addEventListener(MouseEvent.CLICK, onNoButtonClicked);
			
			return new Extender(mainRow);
		}
		
		private function onYesButtonClicked(e:Event = null):void
		{
			onYes();
			
			dispatchEvent(new Event(EVENT_CLOSE_REQUESTED, true));
		}
		
		private function onNoButtonClicked(e:Event = null):void
		{
			dispatchEvent(new Event(EVENT_CLOSE_REQUESTED, true));
		}
	}

}