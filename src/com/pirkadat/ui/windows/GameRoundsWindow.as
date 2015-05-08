package com.pirkadat.ui.windows 
{
	import com.pirkadat.display.ITrueSize;
	import com.pirkadat.logic.Program;
	import com.pirkadat.ui.*;
	public class GameRoundsWindow extends Window 
	{
		public var mainRow:Row;
		
		public function GameRoundsWindow() 
		{
			super(createContent(), null, false);
			alignmentY = -1;
		}
		
		protected function createContent():ITrueSize
		{
			mainRow = new Row(true, 6);
			
			return new Extender(mainRow, 6, 6, 6, 6);
		}
		
		override public function update():void 
		{
			if (Program.mbToUI.newGameRounds)
			{
				while (mainRow.numChildren) mainRow.removeChildAt(0);
				
				for (var i:int = Program.mbToUI.newGameRounds.length - 1; i >= 0; i--)
				{
					var button:Button = new Button(new DynamicText(Program.mbToUI.newGameRounds[i].getName()));
					mainRow.addChildAt(button, 0);
				}
				button.setSelected(true);
			}
			
			super.update();
		}
	}

}