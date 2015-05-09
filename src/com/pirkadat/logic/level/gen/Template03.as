package com.pirkadat.logic.level.gen 
{
	import flash.geom.Point;
	public class Template03 implements ILevelTemplate
	{
		public function getData():Vector.<String> 
		{
			return new <String>[
				"354.20217,591.44834 152.17193,376.49979 380.55393,138.25635 560.62438,382.85294"
				, "690.52777,1294.5028 421.19549,1200.3202 604.83113,1005.3329 959.86018,1200.3202"
				, "1443.0076,1338.8681 1017.1784,1256.9785 1230.0931,866.51917 1719.7969,824.98096 1996.5857,1099.1334"
				, "1658.6148,555.0311 1465.3685,428.27426 1614.6951,170.62721 1764.0219,243.65016"
				, "957.35855,738.85138 808.03195,631.39068 878.30325,313.98386 1097.9013,567.71038"
				, "2163.5839,885.09825 1913.877,756.51178 2208.4029,343.68141 2029.1263,213.40298 2445.3042,314.91864"
				, "2607.2786,1340.0244 2475.5197,1185.8133 2629.2382,688.56089 2844.4445,1225.1528"
				, "2364.9824,1217.5462 2276.8774,1379.0508 1953.2048,1348.7 2177.7278,1099.321"
				, "91.245749,807.87932 266.8978,657.68683 472.6334,872.985 360.83739,995.99921"
				, "2871.1605,177.49885 2869.7072,306.34487 2593.5587,479.85275 2712.7518,133.25086"
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