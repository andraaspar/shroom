package com.pirkadat.display 
{
	import flash.display.Sprite;
	
	public class LimboHost extends StageSetter
	{
		public static var limbo:Sprite;
		
		public function LimboHost() 
		{
			addChild(limbo = new Sprite());
			limbo.visible = false;
		}
		
	}

}