package com.pirkadat.ui 
{
	public interface IUIElement 
	{
		function updateGetSizeChanged():Boolean;
		function fit(minXSize:Number = 0, maxXSize:Number = 0, minYSize:Number = 0, maxYSize:Number = 0):void;
	}
}