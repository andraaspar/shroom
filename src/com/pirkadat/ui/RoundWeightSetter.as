package com.pirkadat.ui 
{
	import com.pirkadat.logic.Program;
	import com.pirkadat.ui.windows.Window;
	public class RoundWeightSetter extends Row 
	{
		
		public function RoundWeightSetter() 
		{
			super(false, 12);
			
			build();
		}
		
		private function build():void
		{
			var label1:HTMLText = new HTMLText("<p><c><l>Moving rounds' chances</l><br/><f>(Bigger values mean higher chances of getting that type.)");
			addChild(label1);
			
			for each (var roundClass:Class in Program.game.moveRoundClasses)
			{
				var roundWeightItem:RoundWeightItem = new RoundWeightItem(roundClass);
				addChild(roundWeightItem);
			}
			
			var label2:HTMLText = new HTMLText("<p><c><l>Shooting rounds' chances</l><br/><f>(Bigger values mean higher chances of getting that type.)");
			addChild(label2);
			distances[label2] = 18;
			
			for each (roundClass in Program.game.shootRoundClasses)
			{
				roundWeightItem = new RoundWeightItem(roundClass);
				addChild(roundWeightItem);
			}
		}
	}

}