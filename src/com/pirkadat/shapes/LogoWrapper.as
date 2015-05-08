package com.pirkadat.shapes 
{
	import com.pirkadat.display.TrueSize;
	
	public class LogoWrapper extends TrueSize 
	{
		
		public function LogoWrapper() 
		{
			addChild(new Logo());
		}
		
	}

}