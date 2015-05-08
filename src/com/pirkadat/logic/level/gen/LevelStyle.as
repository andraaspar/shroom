package com.pirkadat.logic.level.gen 
{
	import com.pirkadat.logic.Program;
	import com.pirkadat.shapes.FillStyle;
	import com.pirkadat.shapes.GradientStyle;
	import com.pirkadat.shapes.LineStyle;
	import flash.display.BitmapData;
	import flash.display.CapsStyle;
	import flash.display.Graphics;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	public class LevelStyle 
	{
		private var terrainTextureID:int;
		private var distanceImageID:int;
		
		public function LevelStyle(node:XML) 
		{
			terrainTextureID = int(node.@tt);
			distanceImageID = int(node.@d);
		}
		
		public function getTerrainFillStyle():FillStyle
		{
			return new FillStyle(0, 1, Program.assetLoader.getAssetByID(terrainTextureID));
		}
		
		public function getTerrainLineStyle():LineStyle
		{
			return new LineStyle(3, 0x20380c, 1, false, LineScaleMode.NORMAL, CapsStyle.ROUND, JointStyle.ROUND);
		}
		
		public function getBackgroundFillStyle():FillStyle 
		{
			return new FillStyle(0);
		}
		
		public function getBackgroundLineStyle():LineStyle 
		{
			return null;
		}
		
		public function getWaterColorGradientStyle():GradientStyle
		{
			return new GradientStyle([0xaed1ff, 0x4584e4, 0x1d4070, 0], [1, 1, 1, 1], [0, 32, 64, 255]);
		}
		
		public function getDistanceBmd():BitmapData 
		{
			return Program.assetLoader.getAssetByID(distanceImageID);
		}
		
		public function getRequiredAssetIDs():Vector.<int> 
		{
			return new <int>[terrainTextureID, distanceImageID];
		}
		
		public function unloadAssets():void 
		{
			Program.assetLoader.unloadAssetsByID(getRequiredAssetIDs());
		}
		
	}

}