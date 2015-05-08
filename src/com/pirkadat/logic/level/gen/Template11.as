package com.pirkadat.logic.level.gen 
{
	import flash.geom.Point;
	public class Template11 implements ILevelTemplate
	{
		public function getData():Vector.<String> 
		{
			return new <String>[
				"111.85287,3052.0246 213.30082,2817.9139 572.27049,2672.2451 889.62049,3057.227"
				, "1017.0807,3046.8221 1162.7496,2771.0918 1326.6271,2732.0734 1480.0996,3075.4357"
				, "892.22172,2612.4168 1162.7496,2536.9811 1170.5533,2435.5332 684.12336,2456.343"
				, "171.68115,2375.7049 416.19672,2503.1652 603.48525,2388.7111 127.46025,2271.6557"
				, "1069.1053,2188.4164 1352.6393,2081.766 1396.8602,2178.0115 967.65738,2276.8582"
				, "450.01271,2045.3488 887.01926,2123.3857 861.00697,2024.5389 390.18443,1964.7107"
				, "900.02541,1803.4344 1180.9582,1694.1828 1251.1914,1774.8209 993.66967,1902.2811"
				, "262.72418,1577.1275 530.65082,1725.3975 421.39918,1819.0418 218.50328,1743.6061"
				, "574.87172,1389.8389 1053.498,1405.4463 1030.0869,1527.7041 512.44221,1509.4955"
				, "1157.5471,1197.3479 1402.0627,1264.9799 1287.6086,1361.2254 1011.8783,1228.5627"
				, "184.6873,1332.6119 676.31967,1181.7406 590.4791,1067.2865 140.46639,1241.5688"
				, "322.55246,856.58688 1334.4307,960.63606 733.54672,201.07704"
			];
		}
		
		public function getTranslate():String 
		{
			return "0,0";
		}
		
		public function getDimensions():Point 
		{
			return new Point(1500, 3000);
		}
	}

}