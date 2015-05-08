package com.pirkadat.logic.level 
{
	import com.pirkadat.shapes.Box;
	import flash.display.BitmapData;
	public interface ILevel 
	{
		function getTerrain():BitmapData;
		function getBackground():BitmapData;
		function getDistance():BitmapData;
		function getPreview():BitmapData;
		function getRequiredAssetIDs():Vector.<int>;
		function getWaterColorGradient():Box;
		function onDestroy():void;
		function getIsLoadingPreview():Boolean;
		function onPreviewDownloaded():void;
	}
	
}