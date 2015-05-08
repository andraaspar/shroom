package com.pirkadat.logic.level.gen 
{
	import flash.geom.Point;
	public interface ILevelTemplate 
	{
		function getDimensions():Point;
		function getData():Vector.<String>;
		function getTranslate():String;
	}
	
}