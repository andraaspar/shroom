package com.pirkadat.logic.level 
{
	import com.pirkadat.logic.level.gen.LevelGenerator;
	import com.pirkadat.logic.Program;
	import com.pirkadat.shapes.Box;
	import com.pirkadat.shapes.FillStyle;
	import com.pirkadat.shapes.GradientStyle;
	import com.pirkadat.ui.*;
	import com.pirkadat.ui.windows.*;
	import flash.display.BitmapData;
	public class PaintedLevel implements ILevel
	{
		public var id:int = -1;
		public var levelNode:XML;
		private var isDowloadingPreview:Boolean;
		
		public function PaintedLevel(id:int = -1, oldLevel:PaintedLevel = null) 
		{
			if (id > -1)
			{
				setID(id);
			}
			else if (oldLevel)
			{
				randomizeID(oldLevel.id);
			}
			else
			{
				randomizeID();
			}
			
			Program.assetLoader.loadAssetByID(int(levelNode.@p));
			isDowloadingPreview = true;
		}
		
		private function setID(value:int):void
		{
			var newLevelNode:XML = Program.assetLoader.assetInfo.l.(@id == value)[0];
			
			Console.say("Level ID: ",value);
			id = value;
			levelNode = newLevelNode;
		}
		
		private function randomizeID(excludeID:int = -1):void
		{
			var levelList:XMLList = Program.assetLoader.assetInfo.l.(@id != excludeID);
			setID(int(levelList[int(Math.random() * levelList.length())].@id));
		}
		
		public function getRequiredAssetIDs():Vector.<int>
		{
			var result:Vector.<int> = new <int>[int(levelNode.@trn), int(levelNode.@bg), int(levelNode.@dst)];
			
			return result;
		}
		
		public function getTerrain():BitmapData
		{
			return Program.assetLoader.getAssetByID(int(levelNode.@trn));
		}
		
		public function getBackground():BitmapData
		{
			return Program.assetLoader.getAssetByID(int(levelNode.@bg));
		}
		
		public function getDistance():BitmapData
		{
			return Program.assetLoader.getAssetByID(int(levelNode.@dst));
		}
		
		public function onDestroy():void
		{
			Program.assetLoader.unloadAssetByID(int(levelNode.@trn));
			Program.assetLoader.unloadAssetByID(int(levelNode.@bg));
			Program.assetLoader.unloadAssetByID(int(levelNode.@dst));
			Program.assetLoader.unloadAssetByID(int(levelNode.@p));
		}
		
		public function getWaterColorGradient():Box
		{
			var result:Box;
			
			var waterColourRatios:Array = [];
			var waterColours:Array = [];
			var waterColourAlphas:Array = [];
			
			var wc:String = levelNode.@wc[0];
			var wcSplit:Array = wc.split(" ");
			for each (var s:String in wcSplit)
			{
				var sSplit:Array = s.split(":");
				waterColourRatios.push(Number(sSplit[0]));
				waterColours.push(Number(sSplit[1]));
				waterColourAlphas.push(Number(sSplit[2]));
			}
			
			result = new Box(null, new GradientStyle(waterColours, waterColourAlphas, waterColourRatios));
			
			return result;
		}
		
		public function getPreview():BitmapData 
		{
			return Program.assetLoader.getAssetByID(int(levelNode.@p));
		}
		
		public function getPreviewID():int
		{
			return int(levelNode.@p);
		}
		
		public function getIsLoadingPreview():Boolean 
		{
			return isDowloadingPreview;
		}
		
		public function onPreviewDownloaded():void 
		{
			isDowloadingPreview = false;
			Program.mbToUI.levelPreviewDownloaded = true;
		}
	}

}