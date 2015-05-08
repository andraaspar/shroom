package com.pirkadat.logic 
{
	import com.pirkadat.ui.Console;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	public class AssetLoaderWithIDs extends AssetLoader
	{
		public var assetInfo:XML;
		public var animationRangeDicts:Array = [];
		
		public const ASSET_BASE_ADDRESS:String = "data/";
		
		public function AssetLoaderWithIDs() 
		{
			super();
		}
		
		public function loadAssetsByID(assetIDs:Vector.<int>):void
		{
			for each (var id:int in assetIDs)
			{
				loadAssetByID(id);
			}
		}
		
		public function loadAssetByID(id:int):void
		{
			var node:XML = assetInfo.a.(@id == id)[0];
			
			var url:String;
			var filters:Vector.<AssetFilter>;
			var fSplit:Array;
			var s:String;
			
			url = ASSET_BASE_ADDRESS + node.@url.toString();
			if (node.@f[0])
			{
				filters = new Vector.<AssetFilter>();
				fSplit = node.@f.toString().split(" ");
				for each (s in fSplit)
				{
					switch (s)
					{
						case "0":
							filters.push(new AlphaColorMergerFilter());
						break;
						case "1":
							filters.push(new FrameVectorGeneratorFilter(int(node.@fcc[0]), int(node.@tfc[0])));
						break;
						case "2":
							filters.push(new AlphaColorMergerFilterH());
						break;
						default:
							throw new Error("Unknown filter.");
					}
				}
			}
			else
			{
				filters = null;
			}
			
			load(url, filters);
		}
		
		public function getAssetByID(id:int):*
		{
			var assetNode:XML = assetInfo.a.(@id == id)[0];
			return getDownloadedData(ASSET_BASE_ADDRESS + assetNode.@url.toString());
		}
		
		public function unloadAssetByID(id:int):void
		{
			var assetNode:XML = assetInfo.a.(@id == id)[0];
			if (assetNode) unloadData(ASSET_BASE_ADDRESS + assetNode.@url.toString());
		}
		
		public function unloadAssetsByID(assetIDs:Vector.<int>):void
		{
			for each (var id:int in assetIDs)
			{
				unloadAssetByID(id);
			}
		}
		
		public function getAssetAnimationRangesByID(id:int):Dictionary
		{
			var animationRanges:Dictionary;
			
			if (animationRangeDicts[id])
			{
				animationRanges = animationRangeDicts[id];
			}
			else
			{
				animationRanges = new Dictionary();
				var assetNode:XML = assetInfo.a.(@id == id)[0];
				var aniStr:String = assetNode.@ani.toString();
				var aniRE:RegExp = /([^ :]+):(\d+)-(\d+)/g;
				var result:Object;
				while (true)
				{
					result = aniRE.exec(aniStr);
					if (!result) break;
					animationRanges[result[1]] = new AnimationRange(int(result[2]), int(result[3]));
				}
				animationRangeDicts[id] = animationRanges;
			}
			
			return animationRanges;
		}
	}

}