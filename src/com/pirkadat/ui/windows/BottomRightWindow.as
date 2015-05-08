package com.pirkadat.ui.windows 
{
	import com.pirkadat.display.*;
	import com.pirkadat.logic.*;
	import com.pirkadat.ui.*;
	import flash.events.*;
	public class BottomRightWindow extends Window 
	{
		public var endTurnButton:Button;
		public var endTurnButtonLabel:DynamicText;
		
		public function BottomRightWindow() 
		{
			super(createContent(), null, false);
			
			alignmentX = alignmentY = 1;
		}
		
		protected function createContent():ITrueSize
		{
			var mainRow:Row = new Row();
			
			endTurnButton = new Button(endTurnButtonLabel = new DynamicText(""));
			mainRow.addChild(endTurnButton);
			endTurnButton.addEventListener(MouseEvent.CLICK, onEndTurnButtonClicked);
			
			return new Extender(mainRow, 6, 6, 6, 6);
		}
		
		protected function onEndTurnButtonClicked(e:Event):void
		{
			Program.mbToP.endTurnRequested = true;
		}
		
		override public function update():void 
		{
			if (Program.mbToUI.newDoneButtonText != null)
			{
				if (Program.mbToUI.newDoneButtonText == "")
				{
					endTurnButton.visible = false;
				}
				else
				{
					endTurnButton.visible = true;
					endTurnButtonLabel.text = Program.mbToUI.newDoneButtonText;
					endTurnButton.sizeChanged = true;
				}
			}
			
			super.update();
		}
	}

}