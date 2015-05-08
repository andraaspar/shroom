package com.pirkadat.logic.level.gen 
{
	import flash.geom.Point;
	public class Template07 implements ILevelTemplate
	{
		public function getData():Vector.<String> 
		{
			return new <String>[
				"117.05533,1615.5974 370.67521,1224.3917 2216.2475,1444.212 2177.2291,1053.0064 686.72459,926.33029 1420.2713,181.17664 2083.5848,497.86695 1467.0935,561.20499 1396.8602,751.21918 2465.9656,743.76764 2856.15,1552.2593 1506.1119,2245.2523"
				, "308.2457,536.24447 175.58299,259.21352 561.86557,177.27479"
				, "2684.4689,505.02971 2520.5914,255.31168 2852.2482,212.39139"
			];
		}
		
		public function getTranslate():String 
		{
			return "0,0";
		}
		
		public function getDimensions():Point 
		{
			return new Point(3000, 1500);
		}
	}

}