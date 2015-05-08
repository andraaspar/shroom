package com.pirkadat.logic.level.gen 
{
	import flash.geom.Point;
	public class Template01 implements ILevelTemplate
	{
		public function getData():Vector.<String> 
		{
			return new <String>[
				"106.79608,1069.3473 237.14153,182.94959 869.43397,-250.0218 1410.7125,408.61812 657.71556,421.50686 606.00855,785.44835 1444.7563,820.97539 1569.3539,1111.8102 866.24204,1731.7677"
				, "1784.0784,1111.8102 1899.1469,858.41334 2438.7261,789.17777 2445.8514,599.93544 1898.5458,483.02036 1965.2869,30.095662 2421.3806,-289.73309 2804.7997,15.26717 2956.4735,1103.3176 2400.5662,1546.8184"
			];
		}
		
		public function getTranslate():String 
		{
			return "0,447.63782";
		}
		
		public function getDimensions():Point 
		{
			return new Point(3000, 1500);
		}
	}

}