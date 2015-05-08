package com.pirkadat.ui.windows 
{
	import com.pirkadat.display.*;
	import com.pirkadat.geom.MultiplierColorTransform;
	import com.pirkadat.logic.Program;
	import com.pirkadat.ui.*;
	import flash.events.*;
	public class MenuButtonsWindow extends Window 
	{
		public var menuButton:Button;
		public var endTurnButtonLabel:DynamicText;
		public var endTurnButton:Button;
		public var helpButton:Button;
		
		public var menuWindow:Window;
		
		public function MenuButtonsWindow() 
		{
			super(createContent(), null, false);
			
			alignmentX = alignmentY = -1;
		}
		
		protected function createContent():ITrueSize
		{
			var mainRow:Row = new Row(true, 6);
			
			menuButton = new Button(new DynamicText("Menu"));
			mainRow.addChild(menuButton);
			menuButton.addEventListener(MouseEvent.CLICK, onMenuButtonClicked);
			
			helpButton = new Button(new DynamicText("Help"));
			mainRow.addChild(helpButton);
			helpButton.frame.transform.colorTransform = new MultiplierColorTransform(Colors.BLUE);
			helpButton.addEventListener(MouseEvent.CLICK, function(e:Event):void { Program.mbToP.helpRequested = true; } );
			
			return new Extender(mainRow, 6, 6, 6, 6);
		}
		
		protected function onMenuButtonClicked(e:Event):void
		{
			if (!menuWindow) menuWindow = new MenuWindow();
			
			if (menuWindow.parent != Gui.windowManager) Gui.windowManager.addWindow(menuWindow);
		}
	}

}