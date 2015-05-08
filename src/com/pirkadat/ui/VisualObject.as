package com.pirkadat.ui 
{
	import com.pirkadat.logic.WorldObject;
	
	public class VisualObject extends WorldObjectAppearance
	{
		public var hasFinishedWorking:Boolean;
		
		public function VisualObject(worldAppearance:WorldAppearance = null) 
		{
			super(null, worldAppearance);
			
		}
		
	}

}