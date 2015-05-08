package com.pirkadat.ui.windows 
{
	import com.pirkadat.display.*;
	import com.pirkadat.logic.*;
	import com.pirkadat.ui.*;
	import flash.events.*;
	public class MenuWindow extends Window 
	{
		
		
		public function MenuWindow() 
		{
			super(createContent(), new DynamicText("Menu"), true, true, true, true);
			
			alignmentX = alignmentY = -1;
		}
		
		protected function createContent():ITrueSize
		{
			var mainRow:Row = new Row(false, 6);
			
			var exitGameButton:Button = new Button(new DynamicText("Exit game"));
			mainRow.addChild(exitGameButton);
			exitGameButton.addEventListener(MouseEvent.CLICK, onExitGameButtonClicked);
			
			return new Extender(mainRow, 40, 10, 40, 10);
		}
		
		protected function onExitGameButtonClicked(e:Event):void
		{
			Gui.modalWindowManager.addWindow(new ConfirmationWindow("exit this game", "Warning", onExitGameConfirmedCallback, null));
			dispatchEvent(new Event(EVENT_CLOSE_REQUESTED, true));
		}
		
		protected function onExitGameConfirmedCallback():void
		{
			Program.mbToP.gameDestroyRequested = true;
		}
	}

}